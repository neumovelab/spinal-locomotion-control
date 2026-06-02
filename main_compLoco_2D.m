
clear; close all;
clc;
warning off all;

addpath('./params')
addpath('./ext')
addpath('./model')
addpath('./src')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set sim and optim parameters %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

model	= 'nms_sim_2D_cost';
load_system(model);

% Set simulation mode (flag_modelMode)
% - 'normal':       slower computation
% - 'accelerator':   faster computation, but requires building MEX file
% - we recommend using 'accelerator' for hand tuning and optimization while
%   using normal for typical troubleshooting
flag_modelMode = 'normal';
set_param(model, 'SimulationMode', flag_modelMode);
simModelMode = get_param(model, 'SimulationMode');
disp(['Model in ' simModelMode ' mode']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select an optimized parameter set to load %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set name of optimized control parameters from CMA-ES
% - the following are examples for setting parameter file names to simulate 
%   walking at v_tgt=1.2m/s on level ground

param_file = 'param_reflex_v12_sp0';
% param_file = 'param_CPGreflex_v12_sp0';
% param_file = 'param_musclesynergy_v12_sp0';
% param_file = 'param_CPGreflexsynergy_v12_sp0';

% Uncomment below for manual setting
% param_file = '';

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set control parameters %
%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isempty(param_file)
    load(['params/' param_file]);
    % load params, sim_params, optim_params,
else % to manually set the control parameters
    % Set control model to simulate with:
    sim_params.flag_controller      = 1;
    % - 1: reflex (2015 Song and Geyer)
    % - 2: CPG-reflex (2001 Ogihara, et al.)
    % - 3: muscle synergy (2019 Aoi, et al.)
    % - 4: CPG-reflex-synergy (2023 Di Russo, et al.)

    switch sim_params.flag_controller
        case 1
            params = ones(71, 1);
        case 2
            params = ones(106, 1);
        case 3
            params = ones(48, 1);
        case 4
            params = ones(247, 1);
    end

    % simulation and optimization parameters
    % - used in sim_nms_reflex2015_2D.m and nms_reflex2015_2D_cost.slx
    % - leave uncommented to set parameters
    % - comment if loading these parameters from a saved CMA-ES optimization
    sim_params.model                    = model;
    sim_params.t_sim                    = 20;
    sim_params.dt_max                   = 0.001;
    sim_params.terrain_slope_angle      = 0*pi/180;     % define slope [rad]

    optim_params.c_0                    = 1E4;
    optim_params.cost_v_tgt             = 1.2;
    optim_params.v_range                = 0.02;
    optim_params.nStep_startKin         = 2;            % start checking SSW after nStep_startKin steps since the control changed
    optim_params.nStep_obj              = 6;            % calculate obj fn for nStep_obj steps of SSW, minval = 1
    optim_params.SSW_kin                = 0.03;         % allows SS_kin difference in total (among x,y pos. of 5 markers)

end

% display model height, weight, and computation time (simulationTime/realTime [%])
flag_disp = 1;


%%%%%%%%%%%%%%%%%%
% Run simulation %
%%%%%%%%%%%%%%%%%%
f = sim_nms_compLocoControllers_2D_cost(params, sim_params, optim_params, flag_disp);
