function f = sim_nms_compLocoControllers_2D_cost(params, sim_params, optim_params, flag_disp)
    warning off all;

    unpack_parameters(sim_params);
    unpack_parameters(optim_params);
    
    % Set musculoskeletal parameters
    nms_MS_2D_scaled;                                   % musculokeletal model properties

    % Set initial parameters (pose and initial velocity)
    param_ic    = params(1:7);
    
    % Set default parameters for all the controllers
    param_ctrl = ones(64, 1);                           % set reflex controller parameters
    setCtrlPar_optim_reflex2015_2D;
    param_ctrl = ones(99, 1);                           % set cpg-reflex controller parameters
    setCtrlPar_optim_CPGreflex2001_2D;
    param_ctrl = ones(41, 1);                           % set muscle synergy controller parameters
    setCtrlPar_optim_musclesynergy2019_2D;
    param_ctrl = ones(240, 1);                          % set cpg-reflex-syn controller parameters
    setCtrlPar_optim_CPGreflexsynergy2023_2D;

    % Set control parameters (optimized)
    setInitPar_optim_2D;              % param_ic
    switch flag_controller
        case 1
            param_ctrl = params(8:end);                 % set reflex controller parameters
            setCtrlPar_optim_reflex2015_2D;
        case 2
            param_ctrl = params(8:end);                 % set cpg-reflex controller parameters
            setCtrlPar_optim_CPGreflex2001_2D;
        case 3
            param_ctrl = params(8:end);                 % set muscle synergy controller parameters
            setCtrlPar_optim_musclesynergy2019_2D;
        case 4
            param_ctrl = params(8:end);                 % set cpg-reflex-syn controller parameters
            setCtrlPar_optim_CPGreflexsynergy2023_2D;
    end

    % muscle effort power
    cost_act_exponent = 2;
    
    % Create slope terrain
    gAngle          = terrain_slope_angle;
    ground          = fn_createSlope(gAngle);
    v_plateX        = ground.v_plateXZ(1,:);
    v_plateZ        = ground.v_plateXZ(2,:);
    v_plateS1       = [ground.v_plateS 1];

    if flag_disp
        disp(['==========================='])
        disp(['  subject height: ' num2str(sub_height) ' m'])
        disp(['  subject mass: ' num2str(sub_mass) ' kg'])
        disp(['==========================='])
    end
    
    try
        if flag_disp
            tic;
        end
        simout = sim(model, ...
                    'SrcWorkspace', 'current', ...
                    'SimMechanicsOpenEditorOnUpdate', flag_disp);
        if flag_disp
            tend    = toc;
            treal   = simout.tEnd.Data/tend*100;
            disp(['simulation speed: ' num2str(treal) '% of real time']);
        end
    catch exception
        disp('error in running simulation!!!');
        disp(exception.message);
        f  = NaN;
        return;
    end
    
    if simout.flag.Data == 0
        if simout.flag_fall.data
            % STAGE 1:
            c_xdist = simout.xHAT_end.Data;
            f = 2*c_0^2 - c_xdist;
        else
            % STAGE 2:
            c_ss = sum(simout.v_SSdist.Data);
            f = c_0^2 + c_ss;
        end
    else
        % Speed constraint
        del_x = simout.del_x.Data/cos(gAngle);
        del_t = simout.del_t.Data;
        c_v = max(abs(cost_v_tgt - del_x/del_t)-v_range, 0);

        % Flight phase constraint
        c_flight = simout.c_flight.data;
    
        if c_v > 0 || c_flight > 0
            % STAGE 3:
            f = c_0 + c_v + c_flight;
        else
            c_p  = sum(abs(simout.v_del_pain.Data));
            c_e = simout.del_Act_pow.Data/(del_x*num_muscles);

            % STAGE 4:
            f = c_p + c_e;

        end
    end

    % Parameter boundary penalties
    f = f + parOffreflex + parOffcpgreflex + parOffmusclesynergy + parOff_cpgreflexsynergy;
    
end

function unpack_parameters(params)
    fields = fieldnames(params); % Get the field names of the structure
    for i = 1:length(fields)
        field = fields{i};
        value = params.(field);
        assignin('caller', field, value); % Set the field value on the workspace
    end
end