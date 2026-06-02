
% Fmax is updated based on Miller (2014)

% FmaxGLU   = 1500 -> 4000
% FmaxHAM   = 3000 -> 2000
% FmaxRF	= 1200 -> 850 maximum isometric force [N]
% FmaxVAS 	= 6000 -> 5000
% FmaxGAS  	= 1500 -> 2000
% 
% NMS_Model_MechInit.m  - Set mechanical parameters of the model.
%
%    This parameter setup includes: 
%    1. segment geometries, masses and inertias,
%    2. muscle-skeleton mechanical links,
%    3. muscle mechanics, and
%    4. ground interaction.
%
% by Seungmoon Song
% December 2015
%   April 2021: "4.10 Scale muscle forces" added
%

% scale skeleton segment properties based on height and mass
% - segment lenghts and masses are scaled from subject height based on 
%   page 83 of Winter's book
% - foot segment lengths along the x-axis is scaled from 2015JPhys model
% - other properties are scaled from 2015JPhys model
% 	- position of COM
% 	- inertia
% - at the end... Winter's book & 2015JPhys are not much different
%
%   Winter's book: 
%       DA Winter, Biomechanics and motor control of human movement,
%       John Wiley & Sons, 2009.
%   2015JPhys: 
%       S Song and H Geyer, A neural circuitry that emphasizes spinal
%       feedback generates diverse behaviours of human locomotion,
%       The Journal of physiology, 2015.
%
% by Seungmoon Song
% December 2015
%   April 2021: removed default NM model (2015 JPhys model)
%


% gravity
g = 9.81;


% ********************* %
% 1. BIPED SEGMENTATION %
% ********************* %


sub_height = 1.8;
sub_mass = 80;

% Scale Skeleton
nms_MechInit_2D_scaleSkel;

% % distance CS1 to CG (local center of gravity)
% D1G_F = 0.14; %[m]
% 
% % distance CS1 to C2 (ankle joint)
% D12_F = 0.16; %[m]
% 
% % distance CS1 to CS3 (heel pad impact point)
% D13_F = 0.20; %[m]
% 
% % distance sole to ankle (y-axis)
% D12y_F = 0.039  *sub_height;
% 
% % distance CS1 to CG (y-axis)
% D1Gy_F = D12y_F*D1G_F/D12_F;
% 
% % foot mass
% m_F  = 1.16; %[kg]
% 
% % foot inertia with respect to axis ball-CG-heel (scaled from other papers)
% In_F = 0.005; %[kg*m^2]
% 
% 
% % -------------------------
% % 1.2 General Shank Segment
% % -------------------------
% 
% % Note: CS1 is position of ankle joint.
% 
% % distance CS1 to CG (local center of gravity)
% D1G_S = (0.3 - D12y_F/4); %[m]
% 
% % distance CS1 to C2 (knee joint)
% D12_S = 0.2460	*sub_height; %[m]
% 
% % shank mass
% m_S  = 3.72; %[kg]
% 
% % shank inertia with respect to axis ankle-CG-knee (scaled from other papers)
% In_S = 0.05; %[kg*m^2]
% 
% 
% % -------------------------
% % 1.3 General Thigh Segment
% % -------------------------
% 
% % Note: CS1 is position of knee joint.
% 
% % distance CS1 to CG (local center of gravity)
% D1G_T = (0.3 - D12y_F/4); %[m] 
% 
% % distance CS1 to C2 (hip joint)
% D12_T = 0.2450  *sub_height; %[m]
% 
% % thigh mass
% m_T  = 8.0; %[kg]
% 
% % thigh inertia with respect to axis ball-CG-heel (scaled from other papers)
% In_T = 0.15; %[kg*m^2]
% 
% 
% % -----------------------------------------
% % 1.4 General Head-Arms-Trunk (HAT) Segment
% % -----------------------------------------
% 
% % HAT length
% L_HAT = 0.47    *sub_height; %[m]
% 
% % distance hip to center of gravity
% D1G_HAT = 0.35; %[m]
% 
% % HAT mass
% m_HAT = 54.24; %[kg]
% 
% % HAT inertia (scaled from other papers)
% In_HAT = 2.5; %[kg*m^2]
% 
% leg_0 = D12_S + D12_T; % [m] distance from hip to ankle


% --------------------------------
% 1.5 Thigh Segment Pressure Sheet
% --------------------------------

% reference compression corresponding to steady-state with HAT mass
DeltaThRef = 5e-3; %[m]
% interaction stiffness
k_pressure = m_HAT * 9.81 / DeltaThRef; %[N/m]
% max relaxation speed (one side)
v_max_pressure = 0.5; %[m/s]
% position in thigh
ThPos = 4/5; % in length of thigh, measured from lower thigh end


% ---------------------
% 1.6 Joint Soft Limits
% ---------------------

% angles at which soft limits engages
% % https://www.cdc.gov/ncbddd/jointrom/index.html
phi12_LowLimit =  70*pi/180; %[rad]
phi12_UpLimit  = 155*pi/180; %[rad]
phi23_LowLimit  = 35*pi/180; %[rad]
phi23_UpLimit  = 180*pi/180; %[rad]
phi34_LowLimit  = 45*pi/180; %[rad]
phi34_UpLimit  = 200*pi/180; %[rad]

% angles for penalizing passive joint torque
P_hipLowLim	            = 45*pi/180;
P_hipUpLim	            = 205*pi/180;
P_kneeLowLim	        = 35*pi/180;
P_kneeUpLim	            = 183*pi/180;
P_ankleLowLim	        = 70*pi/180;
P_ankleUpLim	        = 155*pi/180;

% soft block reference joint stiffness
c_jointstop     = 0.3 / (pi/180);  %[Nm/rad]
% soft block maximum joint stop relaxation speed
w_max_jointstop = 1 * pi/180; %[rad/s]

% ****************************** %
% 2. BIPED MUSCLE-SKELETON-LINKS %
% ****************************** %

num_muscles = 2*9; % (HFL, GLU, HAM, RF, VAS, BFSH, GAS, SOL, TA) * 2

% ----------------------------------------
% 2.1 Ankle Joint Specific Link Parameters
% ----------------------------------------
       
% Hip FLexor group attachement
rHFL       =       0.08; % [m]   constant lever contribution 
phirefHFL  = 160*pi/180; % [rad] reference angle at which MTU length equals 
rhoHFL     =        0.5; %       sum of lopt and lslack          

% GLUtei group attachement
rGLU       =       0.08; % [m]   constant lever contribution 
phirefGLU  = 120*pi/180; % [rad] reference angle at which MTU length equals 
rhoGLU     =        0.5; %       sum of lopt and lslack 
                         
% HAMstring group attachement (hip)
rHAMh       = 0.08;         % [m]   constant lever contribution 
phirefHAMh  = 150*pi/180;   % [rad] reference angle at which MTU length equals 
rhoHAMh     = 0.5;          %       sum of lopt and lslack 

% HAMstring group attachement (knee)
rHAMk       = 0.05;         % [m]   constant lever contribution 
phirefHAMk  = 180*pi/180;   % [rad] reference angle at which MTU length equals 
rhoHAMk     = 0.5;          %       sum of lopt and lslack 

% RF group attachement (hip)
rRFh      =       0.08; % [m]   constant lever contribution 
phirefRFh = 170*pi/180; %155 % [rad] reference angle at which MTU length equals 
rhoRFh    =        0.3; % %0.4      sum of lopt and lslack 

% RF group attachement (knee)
rRFkmax     = 0.06;         % [m]   
rRFkmin     = 0.04;         % [m]   
phimaxRFk   = 165*pi/180;   % [rad] angle of maximum lever contribution
phiminRFk   =  45*pi/180;
phirefRFk   = 125*pi/180;   % [rad] reference angle at which MTU length equals 
rhoRFk      = 0.5;          %
phiScaleRFk = acos(rRFkmin/rRFkmax)/(phiminRFk-phimaxRFk);

% VAStus group attachement
rVASmax     = 0.06;         % [m]
rVASmin     = 0.04;         % [m]
phimaxVAS   = 165*pi/180;   % [rad] angle of maximum lever contribution
phiminVAS   =  45*pi/180;
phirefVAS   = 120*pi/180;   % [rad] reference angle at which MTU length equals 
rhoVAS      = 0.6;          %       sum of lopt and lslack
phiScaleVAS = acos(rVASmin/rVASmax)/(phiminVAS-phimaxVAS);

% BFSH group attachement
rBFSH    	= 0.04;         % [m]   constant lever contribution 
phirefBFSH 	= 160*pi/180;   % [rad] reference angle at which MTU length equals 
rhoBFSH    	= 0.7;          %       sum of lopt and lslack
   
% GAStrocnemius attachement (knee joint)
rGASkmax    = 0.05;         % [m]
rGASkmin    = 0.02;         % [m]
phimaxGASk  = 140*pi/180;   % [rad] angle of maximum lever contribution
phiminGASk  =  45*pi/180;   % [rad] angle of maximum lever contribution
phirefGASk  = 165*pi/180;   % [rad] reference angle at which MTU length equals 
rhoGASk     = 0.7;          %       sum of lopt and lslack 
phiScaleGASk = acos(rGASkmin/rGASkmax)/(phiminGASk-phimaxGASk);

% GAStrocnemius attachement (ankle joint)
rGASamax    = 0.06;         % [m]   
rGASamin    = 0.02;         % [m]   
phimaxGASa  = 100*pi/180;    % [rad] angle of maximum lever contribution
phiminGASa  = 180*pi/180;    % [rad] 
phirefGASa  =  80*pi/180;    % [rad] reference angle at which MTU length equals 
rhoGASa     =        0.7;    %       sum of lopt and lslack 
phiScaleGASa  = acos(rGASamin/rGASamax)/(phiminGASa-phimaxGASa);

% SOLeus attachement
rSOLmax     = 0.06;         % [m] 
rSOLmin     = 0.02;         % [m] 
phimaxSOL   = 100*pi/180;   % [rad] angle of maximum lever contribution
phiminSOL   = 180*pi/180;   % [rad] 
phirefSOL   =  90*pi/180;   % [rad] reference angle at which MTU length equals 
rhoSOL      = 0.5;          %       sum of lopt and lslack 
phiScaleSOL = acos(rSOLmin/rSOLmax)/(phiminSOL-phimaxSOL);

% Tibialis Anterior attachement
rTAmax      = 0.04;         % [m]   
rTAmin      = 0.01;         % [m]   
phimaxTA    =  80*pi/180;   % [rad] angle of maximum lever contribution
phiminTA    = 180*pi/180;   % [rad] 
phirefTA    = 110*pi/180;   % 100[rad] reference angle at which MTU length equals 
phiScaleTA  = acos(rTAmin/rTAmax)/(phiminTA-phimaxTA);
rhoTA       = 0.7; 

                        
% ************************* %
% 3. BIPED MUSCLE MECHANICS %
% ************************* %

% -----------------------------------
% 3.1 Shared Muscle Tendon Parameters
% -----------------------------------

% excitation-contraction coupling
preA =  0.01; %[] preactivation
% tau  =  0.01; %[s] delay time constant
tau_act     =  0.01; %[s] delay time constant
tau_deact	=  0.04; %[s] delay time constant

% contractile element (CE) force-length relationship
w       =   0.56; %[lopt] width
c       =   0.05; %[]; remaining force at +/- width
w_pe	= w;

% CE force-velocity relationship
N    =   1.5; %[Fmax] eccentric force enhancement
K    =     5; %[] shape factor

% Series elastic element (SE) force-length relationship
eref =  0.04; %[lslack] tendon reference strain

eref_GAS =  0.1; %[lslack] tendon reference strain
eref_SOL =  0.1; %[lslack] tendon reference strain


% ------------------------------
% 3.2 Muscle-Specific Parameters
% ------------------------------


% hip flexor muscles
FmaxHFL   = 2000; % maximum isometric force [N]
loptHFL   = 0.11; % optimum fiber length CE [m]
vmaxHFL   =   12; % maximum contraction velocity [lopt/s]
lslackHFL = 0.10; % tendon slack length [m]

% glutei muscles
% FmaxGLU   = 1500; % maximum isometric force [N]
FmaxGLU   = 4000; % maximum isometric force [N]
loptGLU   = 0.11; % optimum fiber length CE [m]
vmaxGLU   =   12; % maximum contraction velocity [lopt/s]
lslackGLU = 0.13; % tendon slack length [m]

% hamstring muscles
% FmaxHAM   = 3000; % maximum isometric force [N]
FmaxHAM   = 2000; % maximum isometric force [N]
loptHAM   = 0.10; % optimum fiber length CE [m]
vmaxHAM   =   12; % maximum contraction velocity [lopt/s]
lslackHAM = 0.31; % tendon slack length [m]

% rectus femoris muscles
% FmaxRF   = 1200; % %850 maximum isometric force [N]
FmaxRF   = 850; % %850 maximum isometric force [N]
loptRF   = 0.08; % optimum fiber length CE [m]
vmaxRF   =   12; % maximum contraction velocity [lopt/s]
lslackRF = 0.35; % tendon slack length [m]

% vasti muscles
% FmaxVAS     = 6000; % maximum isometric force [N]
FmaxVAS     = 5000; % maximum isometric force [N]
loptVAS     = 0.08; % optimum fiber length CE [m]
vmaxVAS     =   12; % maximum contraction velocity [lopt/s]
lslackVAS   = 0.23; % tendon slack length [m]

% BFSH
FmaxBFSH	=  350; % maximum isometric force [N]
loptBFSH    = 0.12; % optimum fiber length CE [m]
vmaxBFSH    =   12; %6 % maximum contraction velocity [lopt/s]
lslackBFSH  = 0.10; % tendon slack length [m]

% gastrocnemius muscle
% FmaxGAS    = 1500; % maximum isometric force [N]
FmaxGAS    = 2000; % maximum isometric force [N]
loptGAS    = 0.05; % optimum fiber length CE [m]
vmaxGAS    =   12; % maximum contraction velocity [lopt/s]
lslackGAS  = 0.40; % tendon slack length [m]

% soleus muscle
FmaxSOL    = 4000; % maximum isometric force [N]
loptSOL    = 0.04; % optimum fiber length CE [m]
vmaxSOL    =    6; % maximum contraction velocity [lopt/s]
lslackSOL  = 0.26; % tendon slack length [m]

% tibialis anterior
FmaxTA     =  800; % maximum isometric force [N]
loptTA     = 0.06; % optimum fiber length CE [m]
vmaxTA     =   12; % maximum contraction velocity [lopt/s]
lslackTA   = 0.24; % tendon slack length [m]



% *************************** %
% 4. Ground Interaction Model %
% *************************** %

% ----------------------
% 4.1 Vertical component
% ----------------------

% stiffness of vertical ground interaction
k_gn = (2*(m_F+m_S+m_T)+m_HAT)*g/0.01; %[N/m]

% max relaxation speed of vertical ground interaction
v_gn_max = 0.03; %[m/s]


% ------------------------
% 4.2 Horizontal component
% ------------------------

% sliding friction coefficient
mu_slide = 0.8;

% sliding to stiction transition velocity limit
vLimit = 0.01; %[m/s]

% stiffness of horizontal ground stiction
k_gt = (2*(m_F+m_S+m_T)+m_HAT)*g/0.1; %[N/m] 0.01

% max relaxation speed of horizontal ground stiction
v_gt_max = 0.03; %[m/s] 0.03

% stiction to sliding transition coefficient
mu_stick = 0.9;


% ----------------------------
% 5 Neural Transmission Delays
% ----------------------------

LongLoopDelay   = 0.030/2; % additional to spinal reflexes [s]
LongDelay  = 0.020/2; % ankle joint muscles [s]
MidDelay   = 0.010/2; % knee joint muscles [s]
ShortDelay = 0.005/2; % hip joint muscles [s]
MinDelay   = 0.001/2; % between neurons in the spinal cord


% ---------------
% 6 Visualization
% ---------------

D12z_HAT = 0.1;     %[m] hip to hip = 2*D12z_HAT

col_RFoot = [159, 192, 213]/255;
col_RShank = [123, 168, 197]/255;
col_RThigh = [88, 144, 180]/255;
col_HAT = [54, 120, 161]/255; 
col_LThigh = [24, 96, 140]/255;
col_LShank = [4, 72, 115]/255;
col_LFoot = [0, 50, 85]/255;

col_AFO = [0, 0, 0];

% Plane
xPla_0 = -10;       % x plane length [m]
xPla = 60;          % x plane length [m]
yPla = 0.01;        % y plane length [m]
zPla = 2;           % z plane depth [m]
