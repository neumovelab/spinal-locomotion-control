function f = parfor_sim(paramSets, varargin)

objFile1        = varargin{1}{1};
sim_params      = varargin{1}{2};
optim_params    = varargin{1}{3};
tmpDir          = varargin{1}{4};

parN	= size(paramSets,2);
f       = nan(1,parN);

flag_disp = 0;
if parN == 1
    i           = 1;    
    param_all   = paramSets(:,i);    
    f(i)        = feval(objFile1, param_all, sim_params, optim_params, flag_disp);
else
    spmd
        cd(tmpDir);
%         load_system(model);
    end
    parfor i = 1:parN
        param_all	= paramSets(:,i);
%         load_system(model);
        f(i)        = feval(objFile1, param_all, sim_params, optim_params, flag_disp);
    end
end
