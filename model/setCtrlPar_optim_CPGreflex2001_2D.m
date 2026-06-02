% Script sets CPG-reflex control parameters

n_CtrP  = 99;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if length(param_ctrl) ~= n_CtrP
    flag_SS	= 0;
else
    flag_SS = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%
% Rhythm CPG Parameters %
%%%%%%%%%%%%%%%%%%%%%%%%
tao_r   = param_ctrl(94)*0.05;
tao_a   = param_ctrl(95)*0.6;
ai      = param_ctrl(96)*2.0;
bias    = param_ctrl(97)*2.5;
s_ext   = param_ctrl(98)*5;

v_parOffcpg	= zeros(1,1);
parRange(99, :) = [0, 10];
for iP = 99:99
    % calculate how off param is
    v_parOffcpg = v_parOffcpg + (-param_ctrl(iP)+parRange(iP,1))*(param_ctrl(iP)<parRange(iP,1));
    v_parOffcpg = v_parOffcpg + (param_ctrl(iP)-parRange(iP,2))*(param_ctrl(iP)>parRange(iP,2));
    
    % keep param in range
    param_ctrl(iP)	= max(parRange(iP,1), min(parRange(iP,2), param_ctrl(iP)));
end
parOffcpgreflex = sum(v_parOffcpg);

phi_off_osc = param_ctrl(99)*10;

% Determine neural oscillator initial conditions
tspan = [0 t_sim*5];
y0pre = [1, 0, 1, 1];

[t, y] = ode45(@(t, y) system_of_odes(t, y, tao_r, tao_a, ai, bias, s_ext), tspan, y0pre);
y = max(y, 0);

osc_signal = y(:,1)-y(:,2);
i_lastOscillation = find(osc_signal(1:end-1) < 0 & osc_signal(2:end) >= 0);

t_osc = t(i_lastOscillation(end-1):i_lastOscillation(end),1);
osc_signal = osc_signal(i_lastOscillation(end-1):i_lastOscillation(end),1);
osc_signal1 = y(i_lastOscillation(end-1):i_lastOscillation(end),1);
osc_signal2 = y(i_lastOscillation(end-1):i_lastOscillation(end),2);
osc_signal3 = y(i_lastOscillation(end-1):i_lastOscillation(end),3);
osc_signal4 = y(i_lastOscillation(end-1):i_lastOscillation(end),4);

interp_length = 100;

x_osc_original = linspace(1, length(osc_signal), length(osc_signal));
x_osc_new = linspace(1, length(osc_signal), interp_length);
osc_signal = interp1(x_osc_original, osc_signal, x_osc_new, 'linear');
osc_signal1 = interp1(x_osc_original, osc_signal1, x_osc_new, 'linear');
osc_signal2 = interp1(x_osc_original, osc_signal2, x_osc_new, 'linear');
osc_signal3 = interp1(x_osc_original, osc_signal3, x_osc_new, 'linear');
osc_signal4 = interp1(x_osc_original, osc_signal4, x_osc_new, 'linear');
t_osc = interp1(x_osc_original, t_osc, x_osc_new, 'linear') - min(t_osc);

[~, phi_off_osc_ind] = min(abs(linspace(1, interp_length, interp_length)-phi_off_osc));

t_presim = t(phi_off_osc_ind);
init_N1 = osc_signal1(phi_off_osc_ind);
init_N2 = osc_signal2(phi_off_osc_ind);
init_V1 = osc_signal3(phi_off_osc_ind);
init_V2 = osc_signal4(phi_off_osc_ind);

%%%%%%%%%%%%%%%%%%%%%%%%
% Muscle Spindle Parameters %
%%%%%%%%%%%%%%%%%%%%%%%%
tao_spindle     = param_ctrl(1)*1; % time constant 

% weight of neural connection for muscle length velocity
p_GLU           = param_ctrl(2)*1;
p_HFL           = param_ctrl(3)*1;
p_HAM           = param_ctrl(4)*1;
p_RF            = param_ctrl(5)*1;
p_BFSH          = param_ctrl(6)*1;
p_VAS           = param_ctrl(7)*1;
p_GAS           = param_ctrl(8)*1;
p_SOL           = param_ctrl(9)*1;
p_TA            = param_ctrl(10)*1;

% weight of neural connection for muscle length
q_GLU           = param_ctrl(11)*1;
q_HFL           = param_ctrl(12)*1;
q_HAM           = param_ctrl(13)*1;
q_RF            = param_ctrl(14)*1;
q_BFSH          = param_ctrl(15)*1;
q_VAS           = param_ctrl(16)*1;
q_GAS           = param_ctrl(17)*1;
q_SOL           = param_ctrl(18)*1;
q_TA            = param_ctrl(19)*1;

% constant maximum muscle contractile velocity (given by Ogihara & Yamazaki 2001)
dloptGLU        = 3.0; % [m/s]
dloptHFL        = 3.0; % [m/s]
dloptHAM        = 3.0; % [m/s]
dloptRF         = 3.0; % [m/s]
dloptBFSH       = 3.0; % [m/s]
dloptVAS        = 3.0; % [m/s]
dloptGAS        = 3.0; % [m/s]
dloptSOL        = 3.0; % [m/s]
dloptTA         = 3.0; % [m/s]

%%%%%%%%%%%%%%%%%%%%%%%%
% Golgi Tendon Organ Parameters %
%%%%%%%%%%%%%%%%%%%%%%%%
tao_golgi       = param_ctrl(20) *1; % time constant

%%%%%%%%%%%%%%%%%%%%%%%%
% Alpha Motoneuron Parameters %
%%%%%%%%%%%%%%%%%%%%%%%%
tao_alpha       = param_ctrl(21) *1; % time constant

% weight of connection of the rhythm input
d_GLU           = param_ctrl(22)*1;
d_HFL           = param_ctrl(23)*1;
d_HAM           = param_ctrl(24)*1;
d_RF            = param_ctrl(25)*1;
d_BFSH          = param_ctrl(26)*1;
d_VAS           = param_ctrl(27)*1;
d_GAS           = param_ctrl(28)*1;
d_SOL           = param_ctrl(29)*1;
d_TA            = param_ctrl(30)*1;

% weight of connection of the Golgi tendon organ
a_GLU           = param_ctrl(31)*1;
a_HFL           = param_ctrl(32)*1;
a_HAM           = param_ctrl(33)*1;
a_RF            = param_ctrl(34)*1;
a_BFSH          = param_ctrl(35)*1;
a_VAS           = param_ctrl(36)*1;
a_GAS           = param_ctrl(37)*1;
a_SOL           = param_ctrl(38)*1;
a_TA            = param_ctrl(39)*1;

% weight of connection netween all muscle spindles
b_GLU           = param_ctrl(40)*.51;
b_GLUHFL        = param_ctrl(41)*.51;
b_GLUHAM        = param_ctrl(42)*.51;
b_HFL           = param_ctrl(43)*.51;
b_HFLGLU        = param_ctrl(44)*.51;
b_HFLRF         = param_ctrl(45)*.51;
b_HAM           = param_ctrl(46)*.51;
b_HAMGLU        = param_ctrl(47)*.51;
b_HAMBFSH       = param_ctrl(48)*.51;
b_RF            = param_ctrl(49)*.51;
b_RFHFL         = param_ctrl(50)*.51;
b_RFVAS         = param_ctrl(51)*.51;
b_BFSH          = param_ctrl(52)*.51;
b_BFSHVAS       = param_ctrl(53)*.51;
b_BFSHHAM       = param_ctrl(54)*.51;
b_BFSHGAS       = param_ctrl(55)*.51;
b_VAS           = param_ctrl(56)*.51;
b_VASBFSH       = param_ctrl(57)*.51;
b_VASRF         = param_ctrl(58)*.51;
b_GAS           = param_ctrl(59)*.51;
b_GASBFSH       = param_ctrl(60)*.51;
b_GASSOL        = param_ctrl(61)*.51;
b_SOL           = param_ctrl(62)*.51;
b_SOLTA         = param_ctrl(63)*.51;
b_SOLGAS        = param_ctrl(64)*.51;
b_TA            = param_ctrl(65)*.51;
b_TASOL         = param_ctrl(66)*.51;

% threshold of aMN (contact input)
h_GLU           = param_ctrl(67)*.1;
h_HFL           = param_ctrl(68)*.1;
h_HAM           = param_ctrl(69)*.1;
h_RF            = param_ctrl(70)*.1;
h_BFSH          = param_ctrl(71)*.1;
h_VAS           = param_ctrl(72)*.1;
h_GAS           = param_ctrl(73)*.1;
h_SOL           = param_ctrl(74)*.1;
h_TA            = param_ctrl(75)*.1;

%%%%%%%%%%%%%%%%%%%%%%%%
% Tactile Feedback Parameters %
%%%%%%%%%%%%%%%%%%%%%%%%
% weights of connection of foot contact signals
ec_GLU           = param_ctrl(76)*0.15;
ec_HFL           = param_ctrl(77)*0.15;
ec_HAM           = param_ctrl(78)*0.15;
ec_RF            = param_ctrl(79)*0.15;
ec_BFSH          = param_ctrl(80)*0.15;
ec_VAS           = param_ctrl(81)*0.15;
ec_GAS           = param_ctrl(82)*0.15;
ec_SOL           = param_ctrl(83)*0.15;
ec_TA            = param_ctrl(84)*0.15;

% weights of connection of foot swing signals
es_GLU           = param_ctrl(85)*0.15;
es_HFL           = param_ctrl(86)*0.15;
es_HAM           = param_ctrl(87)*0.15;
es_RF            = param_ctrl(88)*0.15;
es_BFSH          = param_ctrl(89)*0.15;
es_VAS           = param_ctrl(90)*0.15;
es_GAS           = param_ctrl(91)*0.15;
es_SOL           = param_ctrl(92)*0.15;
es_TA            = param_ctrl(93)*0.15;

function dydt = system_of_odes(t, y, tao_r, tao_a, a, b, s)
    dydt = zeros(4, 1);
    
    z0 = y(1);
    z1 = y(2);
    v0 = y(3);
    v1 = y(4);

    dydt(1) = (1/tao_r) * (-z0 - a*max(z1, 0) - b*v0 + s);
    dydt(2) = (1/tao_r) * (-z1 - a*max(z0, 0) - b*v1 + s);
    dydt(3) = (1/tao_a) * (-v0 + max(z0, 0));
    dydt(4) = (1/tao_a) * (-v1 + max(z1, 0));
end