
clear; clc; close all;
tStart = tic;
warning off all;

n_par = feature('numcores');    % assign number of workers to number of physical cores on local machine
n_pop = 32;
% assign population size according to 1) the number of parameters (N) and 2) the number of workers available (n_par)
% - cma-es recommends (4 + floor(3*log(N)))
% - we recommend k*n_par, where k = 1, 2, 3, ...

addpath('./params')
addpath('./ext')
addpath('./model')
addpath('./src')

% Set name of optimized control parameters from CMA-ES
% - Leave as '' to run CMA-ES with control parameters as initial seed of ones
% - Input .mat file name to run CMA-ES with previously optimized control parameters as an initial seed
param_file = 'param_reflex_v12_sp0';
% param_file = 'param_CPGreflex_v12_sp0';
% param_file = 'param_musclesynergy_v12_sp0';
% param_file = 'param_CPGreflexsynergy_v12_sp0';
% param_file = '';

% Set control model to optimize:
% 1: reflex (2015 Song and Geyer)
% 2: CPG-reflex (2001 Ogihara, et al.)
% 3: muscle synergy (2019 Aoi, et al.)
% 4: CPG-reflex-synergy (2023 Di Russo, et al.)
sim_params.flag_controller      = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set control parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(param_file)
    switch sim_params.flag_controller
        case 1
            initParam = ones(71, 1);
        case 2
            initParam = ones(106, 1);
        case 3
            initParam = ones(48, 1);
        case 4
            initParam = ones(247, 1);
    end
else
    load(['params/' param_file], 'params');
    initParam = params;
end

% Set all control parameters of non-used control models to 1
switch sim_params.flag_controller
    case 1
        strSave = 'reflex';
        v_sPar	= [1:7 10:12];
        % v_sPar specifies parameters that use a smaller exploration range during optimization
    case 2
        strSave = 'CPGreflex';
        v_sPar	= [1:7 8 27 28 101:106];
    case 3
        strSave = 'musclesynergy';
        v_sPar	= [1:7 8 14:24];
    case 4
        strSave = 'CPGreflexsynergy';
        v_sPar	= [1:7 17:19];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set sim and optim parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%

objFile     = 'parfor_sim';
objFile1    = 'sim_nms_compLocoControllers_2D_cost';
model	    = 'nms_sim_2D_cost';

% Set simulation mode (flag_modelMode)
% - 'normal':       slower computation
% - 'accelerator':   faster computation, but requires building MEX file
% - we recommend using 'accelerator' for hand tuning and optimization while
%   using normal for typical troubleshooting
load_system(model);
flag_modelMode = 'normal';
set_param(model, 'SimulationMode', flag_modelMode);
simModelMode = get_param(model, 'SimulationMode');
disp(['Model in ' simModelMode ' mode']);

% simulation and optimization variables
% - used in sim_nms_reflex2015_2D.m and nms_reflex2015_2D_cost.slx
% - uncomment to set initial parameters and 
% - comment if loading parameters from optimized CMA-ES output
sim_params.model                    = model;
sim_params.t_sim                    = 20;
sim_params.dt_max                   = 0.001;
sim_params.terrain_slope_angle      = 0*pi/180;     % define slope [deg] -> [rad]

optim_params.c_0                    = 1E4;
optim_params.cost_v_tgt             = 1.2;          % define target speed [m/s]
optim_params.v_range                = 0.02;
optim_params.nStep_startKin         = 2;            % start checking steady state walking after nStep_startKin steps since the control changed
optim_params.nStep_obj              = 6;            % number of steps to evaluate obj fcn in steady state walking, minval = 1
optim_params.SSW_kin                = 0.03;         % [m] allowed cartesian differences between joints at heel strike to determine steady state (among x,y pos. of 5 markers)

varargin = {objFile1, sim_params, optim_params};

% cmaes options
sigma_scale = 1E-1;
sigma_scale_small = .1;
sigma   = sigma_scale*abs(initParam);
sigma(v_sPar)   = sigma(v_sPar)*sigma_scale_small;
sigma = max(sigma, sigma_scale*sigma_scale_small);

opts.stopOnEqualFunctionValues  = 0;
opts.DiagonalOnly = 1;
opts.DispModulo = 1;
opts.EvalParallel = 1;
opts.maxiter = 800;
opts.PopSize = n_pop;   

% To resume from stopped CMA-ES, set opts.Resume = 1 and set str_date
% - saved optimization files are set with timestamp here for traceability
opts.Resume = 0;
if opts.Resume
    opts.ResumeFile = 'nms_sim_2D_cost_variablescmaes';   % insert cmaes variables file here ('nms_reflex2015_2D_cost_variablescmaes')
    str_date = '2026_00_00_00_00';                               % input CMAES directory where variables are saved
else
    str_date = datestr(datetime('now'),'yyyy_mm_dd_HH_MM');
end

% log files setup
if sim_params.terrain_slope_angle >= 0
    str_slope = 'sp';
else
    str_slope = 'sn';
end
st_dir = ['params/' strSave, '_v', sprintf('%02d', optim_params.cost_v_tgt * 10), '_', str_slope, sprintf('%01d', abs(sim_params.terrain_slope_angle * 180/pi)), '_', str_date];
mkdir(st_dir);
opts.LogFilenamePrefix = [st_dir '/' model '_'];
opts.SaveFilename = [st_dir '/' model '_variablescmaes.mat'];

% parpool setup start
if ~isempty(gcp('nocreate'))
    delete(gcp('nocreate'))
end
load_system(model);
c = parcluster;
p = parpool(c, n_par);
model_files = dependencies.fileDependencyAnalysis(model);
model_files{end + 1} = ['src/' objFile1 '.m'];
model_files{end + 1} = 'model/fn_createSlope.m';
model_files{end + 1} = 'model/fn_terrainSlope.m';
model_files{end + 1} = 'model/nms_MS_2D_scaled.m';
model_files{end + 1} = 'model/nms_MechInit_2D_scaleSkel.m';
model_files{end + 1} = 'model/setInitPar_optim_2D.m';
model_files{end + 1} = 'model/setCtrlPar_optim_reflex2015_2D.m';
model_files{end + 1} = 'model/setParRange_reflex2015_2D.m';
model_files{end + 1} = 'model/setCtrlPar_optim_CPGreflex2001_2D.m';
model_files{end + 1} = 'model/setCtrlPar_optim_musclesynergy2019_2D.m';
model_files{end + 1} = 'model/setParRange_musclesynergy2019_2D.m';
model_files{end + 1} = 'model/setCtrlPar_optim_CPGreflexsynergy2023_2D.m';
model_files{end + 1} = 'model/setParRange_CPGreflexsynergy2023_2D.m';

p.addAttachedFiles(model_files);
spmd
    currDir = pwd;
    addpath(currDir);
    tmpDir = tempname;
    mkdir(tmpDir);
    cd(tmpDir);
    load_system(model);
    set_param(model, 'SimulationMode', flag_modelMode);
end
varargin{end+1} = tmpDir;

% run cmaes
tic;
try
    [xmin, fmin, counteval, stopflag, out, bestever] = ...
        cmaes( objFile, initParam, sigma, opts, varargin);
    flag_error = 0;
catch exception
    exception.message
    flag_error = 1;
end

% stop the timer and display elapsed time
elapsedTime = toc;
hours = floor(elapsedTime / 3600);
minutes = floor(mod(elapsedTime, 3600) / 60);
seconds = mod(elapsedTime, 60);
fprintf('Elapsed time is %d hours, %d minutes and %.2f seconds./n', hours, minutes, seconds);

if ~flag_error
    params = out.solutions.bestever.x;
    save(['params/param_', st_dir(8:end)], ...
        'params', 'sim_params', 'optim_params');
end

plotcmaesdat(1, opts.LogFilenamePrefix)

% clean up parpool
spmd
    cd(currDir);
    rmdir(tmpDir, 's');
    rmpath(currDir);
    close_system(model, 0);
end

close_system(model, 0)
delete(gcp('nocreate'))
