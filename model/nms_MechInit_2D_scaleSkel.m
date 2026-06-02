
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

if sub_height == 0 && sub_mass == 0
    scaleSkel = 0;  % 2015 JPhys model
else
    scaleSkel = 1;
end

scaleL_JPhys  = sub_height/1.80;    % scale from 2015_SongEA_JPhys
scaleM  = sub_mass/80;

% default NM model (2015 JPhys model)
% height = 180 cm, mass = 80 kg
if ~scaleSkel
    
    % ------------------------
    % 1.1 General Foot Segment
    % ------------------------

    % Note: CS1 is position of fore-foot impact point and contacts 
    %       the adjoining ground.

    % distance CS1 to CG (local center of gravity)
    D1G_F = 0.14; %[m]

    % distance CS1 to C2 (ankle joint)
    D12_F = 0.16; %[m]

    % distance CS1 to CS3 (heel pad impact point)
    D13_F = 0.20; %[m]

    % distance sole to ankle (y-axis)
    D12y_F = 0.08;
    
    % distance CS1 to CG (y-axis)
    D1Gy_F = D12y_F*D1G_F/D12_F;
    
    % foot mass
    m_F  = 1.25; %[kg]

    % foot inertia with respect to axis ball-CG-heel (scaled from other papers)
    In_F = 0.005; %[kg*m^2]


    % -------------------------
    % 1.2 General Shank Segment
    % -------------------------

    % Note: CS1 is position of ankle joint.

    % distance CS1 to CG (local center of gravity)
    D1G_S = 0.3 - D12y_F/4; %[m]

    % distance CS1 to C2 (knee joint)
    D12_S = 0.5 - D12y_F/2; %[m]

    % shank mass
    m_S  = 3.5; %[kg]

    % shank inertia with respect to axis ankle-CG-knee (scaled from other papers)
    In_S = 0.05; %[kg*m^2]


    % -------------------------
    % 1.3 General Thigh Segment
    % -------------------------

    % Note: CS1 is position of knee joint.

    % distance CS1 to CG (local center of gravity)
    D1G_T = 0.3 - D12y_F/4; %[m] 

    % distance CS1 to C2 (hip joint)
    D12_T = 0.5 - D12y_F/2; %[m]

    % thigh mass
    m_T  = 8.5; %[kg]

    % thigh inertia with respect to axis ball-CG-heel (scaled from other papers)
    In_T = 0.15; %[kg*m^2]


    % -----------------------------------------
    % 1.4 General Head-Arms-Trunk (HAT) Segment
    % -----------------------------------------

    % HAT length
    L_HAT = 0.8; %[m]

    % distance hip to center of gravity
    D1G_HAT = 0.35; %[m]

    % HAT mass
    m_HAT = 53.5; %[kg]

    % HAT inertia (scaled from other papers)
    In_HAT = 2.5; %'3' in the original 2D model    
else    
    % distance CS1 to CG (local center of gravity)
    D1G_F = 0.14    *scaleL_JPhys; %[m]

    % distance CS1 to C2 (ankle joint)
    D12_F = 0.16    *scaleL_JPhys; %[m]

    % distance CS1 to CS3 (heel pad impact point)
    D13_F = 0.20    *scaleL_JPhys; %[m]

    % distance sole to ankle (y-axis)
    D12y_F = 0.039  *sub_height;
    
    % distance CS1 to CG (y-axis)
    D1Gy_F = D12y_F*D1G_F/D12_F;
    
    % foot mass
    m_F  = 1.16     *scaleM; %[kg]

    % foot inertia with respect to axis ball-CG-heel (scaled from other papers)
    In_F = 0.005    *scaleM*scaleL_JPhys^2; %[kg*m^2]


    % -------------------------
    % 1.2 General Shank Segment
    % -------------------------

    % Note: CS1 is position of ankle joint.

    % distance CS1 to CG (local center of gravity)
    D1G_S = (0.3 - D12y_F/4)	*scaleL_JPhys; %[m]

    % distance CS1 to C2 (knee joint)
    D12_S = 0.2460	*sub_height; %[m]

    % shank mass
    m_S  = 3.72  	*scaleM; %[kg]

    % shank inertia with respect to axis ankle-CG-knee (scaled from other papers)
    In_S = 0.05     *scaleM*scaleL_JPhys^2; %[kg*m^2]


    % -------------------------
    % 1.3 General Thigh Segment
    % -------------------------

    % Note: CS1 is position of knee joint.

    % distance CS1 to CG (local center of gravity)
    D1G_T = (0.3 - D12y_F/4)	*scaleL_JPhys; %[m] 

    % distance CS1 to C2 (hip joint)
    D12_T = 0.2450  *sub_height; %[m]

    % thigh mass
    m_T  = 8.0      *scaleM; %[kg]

    % thigh inertia with respect to axis ball-CG-heel (scaled from other papers)
    In_T = 0.15     *scaleM*scaleL_JPhys^2; %[kg*m^2]


    % -----------------------------------------
    % 1.4 General Head-Arms-Trunk (HAT) Segment
    % -----------------------------------------

    % HAT length
    L_HAT = 0.47    *sub_height; %[m]

    % distance hip to center of gravity
    D1G_HAT = 0.35  *scaleL_JPhys; %[m]

    % HAT mass
    m_HAT = 54.24    *scaleM; %[kg]

    % HAT inertia (scaled from other papers)
    In_HAT = 2.5    *scaleM*scaleL_JPhys^2; %[kg*m^2]
end

leg_0 = D12_S + D12_T; % [m] distance from hip to ankle

% check segment length and mass
if abs(L_HAT+D12_T+D12_S+D12y_F - sub_height) > eps
    error('something wrong with segment length');
end
if abs(m_HAT+2*(m_T+m_S+m_F) - sub_mass) > eps
    error('something wrong with segment mass');
end




