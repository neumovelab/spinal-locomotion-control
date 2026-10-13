% Script sets reflex control parameters

l_HLP = 5;
l_StP = 30;
l_SwP = 27;
l_TrP = 2;

n_CtrP  = l_HLP + l_StP + l_SwP + l_TrP;

if length(param_ctrl) ~= n_CtrP
    flag_SS	= 0;
else
    flag_SS = 1;
end


% ====================== %
% BOUND PARAMETER VALUES %
% ====================== %

setParRange_reflex2015_2D;    % parRange

v_parOffR	= zeros(length(param_ctrl),1);
for iP = 1:length(param_ctrl)
    % calculate how off param is
    v_parOffR(iP) = v_parOffR(iP) + (-param_ctrl(iP)+parRange(iP,1))*(param_ctrl(iP)<parRange(iP,1));
    v_parOffR(iP) = v_parOffR(iP) + (param_ctrl(iP)-parRange(iP,2))*(param_ctrl(iP)>parRange(iP,2));
    
    % keep param in range
    param_ctrl(iP)	= max(parRange(iP,1), min(parRange(iP,2), param_ctrl(iP)));
end
parOffreflex = sum(v_parOffR);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%

param2D     = param_ctrl(1:n_CtrP);


%% control params

parHLCtrl   = param2D(1                         : l_HLP);
parStCtrl   = param2D(l_HLP + 1                 : l_HLP + l_StP);
parSwCtrl   = param2D(l_HLP + l_StP + 1         : l_HLP + l_StP + l_SwP);
parTrCtrl   = param2D(l_HLP + l_StP + l_SwP + 1 : l_HLP + l_StP + l_SwP + l_TrP);


%%%%%%%%%%%%%%%%%%%%%%%%
% higher layer control %
%%%%%%%%%%%%%%%%%%%%%%%%

% Trunk Balance Ctrl
theta_tgt  = parHLCtrl(1)   *5*pi/180;

% Swing Leg Length Control
leg_l   = [D12_T D12_S];
l_clr   = max(eps, min(parHLCtrl(2)*0.85, leg_l(1) + leg_l(2)));

% Foot Placement Control (alpha Ctrl)
alpha_tgt   = parHLCtrl(3)      *80*pi/180;
alpha_cd    = parHLCtrl(4)      *(-10) *pi/180; % [rad/m]
alpha_cv    = parHLCtrl(5)      *(-10) *pi/180; % [rad*s/m]

HLCtrlPar = [theta_tgt l_clr alpha_tgt alpha_cd alpha_cv];


%%%%%%%%%%%%%%%%%%%%%%
% Stance Leg Control %
%%%%%%%%%%%%%%%%%%%%%%

% 0: pre-excitations
St_PreEHFL          = parStCtrl(1)      *0.01; %[]
St_PreEGLU          = parStCtrl(2)      *0.01; %[]
St_PreEHAM          = parStCtrl(3)      *0.01; %[]
St_PreERF           = parStCtrl(4)      *0.01;
St_PreEVAS          = parStCtrl(5)      *0.05; %[]
St_PreEBFSH         = parStCtrl(6)      *0.01;
St_PreEGAS          = parStCtrl(7)      *0.01;
St_PreESOL          = parStCtrl(8)      *0.01;
St_PreETA           = parStCtrl(9)      *0.01;

% M1: realize compliant leg
St_FGain_GLU      	= parStCtrl(10)     *0.5;
St_FGain_VAS     	= parStCtrl(11)     *1.2;
St_FGain_SOL     	= parStCtrl(12)     *1.4;

% M2: prevent knee overextension
St_FGain_HAM     	= parStCtrl(13)     *0.5;
St_loffBFSH_VAS     = parStCtrl(14)     *1.0;
St_LGainBFSH_VAS    = parStCtrl(15)     *1.2;
St_loffBFSH         = parStCtrl(16)     *1.0;
St_LGain_BFSH       = parStCtrl(17)     *1.2;
St_FGain_GAS        = parStCtrl(18)     *1.0;

% M3: balance trunk
St_GainTh_HFL       = parStCtrl(19)     *0.6;
St_GainDTh_HFL      = parStCtrl(20)     *0.3;
St_GainTh_GLU       = parStCtrl(21)     *0.5;
St_GainDTh_GLU      = parStCtrl(22)     *0.1;
St_SGainGLU_HAM     = parStCtrl(23)     *1;

% M4: compensate swing leg
St_SGainCGLU_HFL    = parStCtrl(24)     *.1;
St_SGainCHAM_HFL    = parStCtrl(25)     *.1;
St_SGainCHFL_GLU    = parStCtrl(26)     *.1;
St_SGainCRF_GLU     = parStCtrl(27)     *.1;

% M5: flex ankle
St_LceOffTA         = parStCtrl(28)     *(1-0.65*w); %[loptTA]
St_LGainTA          = parStCtrl(29)     *1.1;
St_FGainSOL_TA      = parStCtrl(30)     *0.4;

% pass control parameters to Simulink
StPreExc           =   ...
    [St_PreEHFL St_PreEGLU St_PreEHAM St_PreERF St_PreEVAS ...
    St_PreEBFSH St_PreEGAS St_PreESOL St_PreETA];

St_M1       = [St_FGain_GLU St_FGain_VAS St_FGain_SOL];
St_M2       = [St_FGain_HAM St_loffBFSH_VAS St_LGainBFSH_VAS St_loffBFSH St_LGain_BFSH St_FGain_GAS];
St_M3       = [St_GainTh_HFL St_GainDTh_HFL St_GainTh_GLU St_GainDTh_GLU St_SGainGLU_HAM];
St_M4       = [St_SGainCGLU_HFL St_SGainCHAM_HFL St_SGainCHFL_GLU St_SGainCRF_GLU St_SGainGLU_HAM];
St_M5       = [St_LceOffTA St_LGainTA St_FGainSOL_TA];


StCtrlPar = [StPreExc St_M1 St_M2 St_M3 St_M4 St_M5];

% indexes of control parameters
St_i = 0;
parSt_PreE_i    = St_i + 1	: St_i + length(StPreExc);
St_i = St_i + length(StPreExc);
parSt_M1_i   	= St_i + 1	: St_i + length(St_M1);
St_i = St_i + length(St_M1);
parSt_M2_i      = St_i + 1	: St_i + length(St_M2);
St_i = St_i + length(St_M2);
parSt_M3_i      = St_i + 1	: St_i + length(St_M3);
St_i = St_i + length(St_M3);
parSt_M4_i      = St_i + 1	: St_i + length(St_M4);
St_i = St_i + length(St_M4);
parSt_M5_i      = St_i + 1	: St_i + length(St_M5);
St_i = St_i + length(St_M5); % St_i is used in the Simulink file



%%%%%%%%%%%%%%%%%%%%%
% Swing Leg Control %
%%%%%%%%%%%%%%%%%%%%%

% constants (measurment parameters)
Sw_phi2lopt_BFSH    = 1.00*rBFSH*rhoBFSH/loptBFSH;
Sw_phiRef_BFSH      = 1.00*phirefBFSH;
Sw_a2lopt_RF        = 1.00*rRFh*rhoRFh/loptRF;
Sw_aRef_RF          = 1.00*(phirefRFh-phirefRFk/2);
Sw_a2lopt_HAM       = 1.00*rHAMh*rhoHAMh/loptHAM;
Sw_aRef_HAM         = 1.00*(phirefHAMh-phirefHAMk/2);
Sw_phi2lopt_HFL     = 1.00*rHFL*rhoHFL/loptHFL;
Sw_phiRef_HFL       = 1.00*phirefHFL;
Sw_phi2lopt_GLU     = 1.00*rGLU*rhoGLU/loptGLU;
Sw_phiRef_GLU       = 1.00*phirefGLU;

% Control Parameters (Pre-excitations)
Sw_PreEHFL          = parSwCtrl(1)      *0.01;
Sw_PreEGLU          = parSwCtrl(2)      *0.01;
Sw_PreEHAM          = parSwCtrl(3)      *0.01;
Sw_PreERF           = parSwCtrl(4)      *0.01;
Sw_PreEVAS          = parSwCtrl(5)      *0.01;
Sw_PreEBFSH         = parSwCtrl(6)      *0.01;
Sw_PreEGAS          = parSwCtrl(7)      *0.01;
Sw_PreESOL          = parSwCtrl(8)      *0.01;
Sw_PreETA           = parSwCtrl(9)      *0.01;

% Swing Phase
Sw_a_del            = parSwCtrl(10)     *10*pi/180;

% Swing Ctrl (Hip)
Sw_LGainRF_HFL      = parSwCtrl(11)     *1.5/Sw_a2lopt_RF;
Sw_VGainRF_HFL      = parSwCtrl(12)     *1.0;
Sw_LGainHAM_GLU     = parSwCtrl(13)     *0.5/Sw_a2lopt_HAM;
Sw_VGainHAM_GLU     = parSwCtrl(14)     *.5;

% Swing Ctrl (Ankle)
Sw_LGainTA_TA       = parSwCtrl(15)     *1.1;
Sw_LceOffTA         = parSwCtrl(16)     *(1-0.65*w);

% Swing Ctrl (Knee_i)
Sw_VGainRF_BFSH   	= parSwCtrl(17)     *0.5*loptRF/(rRFh*rhoRFh);

% Swing Ctrl (Knee_ii)
Sw_VGainVAS_RF  	= parSwCtrl(18)     *0.1*loptBFSH/(rBFSH*rhoBFSH);
Sw_VGainBFSH     	= parSwCtrl(19)     *1.25/Sw_a2lopt_RF*2;

% Swing Ctrl (Knee_iii)
Sw_LGainHAM         = parSwCtrl(20)     *1/Sw_a2lopt_HAM;
Sw_SGainHAM_BFSH   	= parSwCtrl(21)     *3;
Sw_SGainHAM_GAS     = parSwCtrl(22)     *2;
Sw_SHAM_thr         = parSwCtrl(23)     *0.65;

% Swing Ctrl (Stance Preparation)
Sw_LGainHFL         = parSwCtrl(24)     *0.4;
Sw_LGainGLU         = parSwCtrl(25)     *0.4;
Sw_loffVAS          = parSwCtrl(26)     *0.2;
Sw_LGainVAS         = parSwCtrl(27)     *0.3;

% pass control parameters to Simulink
SwPreExc       =   ...
    [Sw_PreEHFL Sw_PreEGLU Sw_PreEHAM Sw_PreERF Sw_PreEVAS ...
    Sw_PreEBFSH Sw_PreEGAS Sw_PreESOL Sw_PreETA];

SwPhasePari     = ...
    [Sw_phi2lopt_BFSH Sw_phiRef_BFSH];

SwPhaseParii    = ...
    [Sw_aRef_RF Sw_a2lopt_RF Sw_a_del Sw_aRef_HAM Sw_a2lopt_HAM];
                
SwCtrlPar_H      = ...
    [Sw_a2lopt_RF Sw_aRef_RF Sw_LGainRF_HFL Sw_VGainRF_HFL Sw_a2lopt_HAM ...
    Sw_a_del Sw_aRef_HAM Sw_LGainHAM_GLU Sw_VGainHAM_GLU];

SwCtrlPar_A     = [Sw_LGainTA_TA Sw_LceOffTA];

SwCtrlPar_Ki    = Sw_VGainRF_BFSH;

SwCtrlPar_Kii   = ...
    [Sw_VGainVAS_RF Sw_VGainBFSH Sw_phi2lopt_BFSH Sw_a2lopt_RF Sw_aRef_RF];
 
SwCtrlPar_Kiii  = ...
    [Sw_a_del Sw_aRef_HAM Sw_a2lopt_HAM Sw_LGainHAM Sw_SHAM_thr ...
    Sw_SGainHAM_BFSH Sw_SGainHAM_GAS];
     
SwCtrlPar_StP   = ...
    [Sw_phiRef_HFL Sw_phi2lopt_HFL Sw_LGainHFL Sw_phiRef_GLU Sw_phi2lopt_GLU ...
    Sw_LGainGLU Sw_loffVAS Sw_LGainVAS];

SwCtrlPar       =   ...
    [SwPreExc SwPhasePari SwPhaseParii SwCtrlPar_H SwCtrlPar_A ...
    SwCtrlPar_Ki SwCtrlPar_Kii SwCtrlPar_Kiii SwCtrlPar_StP];

% indexes of control parameters
Sw_i = 0;
parSwPreE_i     = Sw_i + 1	: Sw_i + length(SwPreExc);
Sw_i = Sw_i + length(SwPreExc);
parSwPhi_i      = Sw_i + 1	: Sw_i + length(SwPhasePari);
Sw_i = Sw_i + length(SwPhasePari);
parSwPhii_i     = Sw_i + 1	: Sw_i + length(SwPhaseParii);
Sw_i = Sw_i + length(SwPhaseParii);
parSwH_i        = Sw_i + 1	: Sw_i + length(SwCtrlPar_H);
Sw_i = Sw_i + length(SwCtrlPar_H);
parSwA_i        = Sw_i + 1	: Sw_i + length(SwCtrlPar_A);
Sw_i = Sw_i + length(SwCtrlPar_A);
parSwKi_i       = Sw_i + 1	: Sw_i + length(SwCtrlPar_Ki);
Sw_i = Sw_i + length(SwCtrlPar_Ki);    
parSwKii_i      = Sw_i + 1	: Sw_i + length(SwCtrlPar_Kii);
Sw_i = Sw_i + length(SwCtrlPar_Kii);
parSwKiii_i     = Sw_i + 1	: Sw_i + length(SwCtrlPar_Kiii);
Sw_i = Sw_i + length(SwCtrlPar_Kiii);
parSwKiv_i      = Sw_i + 1	: Sw_i + length(SwCtrlPar_StP);
Sw_i = Sw_i + length(SwCtrlPar_StP);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stance -> Swing Transition Control %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% stance to swing transition Ctrl
Tr_St_sup           = parTrCtrl(1)    *1;
Tr_Sw               = parTrCtrl(2)    *1.5;

TrCtrlPar = [Tr_St_sup Tr_Sw];

CtrlPar = [HLCtrlPar StCtrlPar SwCtrlPar TrCtrlPar];    % l_HLP St_i Sw_i l_TrP