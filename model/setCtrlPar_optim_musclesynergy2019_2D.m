% Script sets muscle synergy control parameters

n_MG = 33;
n_MR = 8;
n_CtrP = n_MG + n_MR;

if length(param_ctrl) ~= n_CtrP
    flag_SS	= 0;
else
    flag_SS = 1;
end

% ====================== %
% BOUND PARAMETER VALUES %
% ====================== %

synergyPow = 2;

setParRange_musclesynergy2019_2D;    % parRange

v_parOffmusclesynergy	= zeros(n_MG + n_MR,1);
for iP = 1:(n_MG + n_MR)
    % calculate how off param is
    v_parOffmusclesynergy(iP) = v_parOffmusclesynergy(iP) + (-param_ctrl(iP)+parRange(iP,1))*(param_ctrl(iP)<parRange(iP,1));
    v_parOffmusclesynergy(iP) = v_parOffmusclesynergy(iP) + (param_ctrl(iP)-parRange(iP,2))*(param_ctrl(iP)>parRange(iP,2));
    
    % keep param in range
    param_ctrl(iP)	= max(parRange(iP,1), min(parRange(iP,2), param_ctrl(iP)));
end
parOffmusclesynergy = sum(v_parOffmusclesynergy);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Movement Generator %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gait Parameters
T_gaitCycle     = param_ctrl(1)      *1; % gait duration cycle (s)

% Pulse amplitude
pulseW1         = param_ctrl(2)      *1;
pulseW2         = param_ctrl(3)      *1;
pulseW3         = param_ctrl(4)      *1;
pulseW4         = param_ctrl(5)      *1;
pulseW5         = param_ctrl(6)      *1;
pulseW = [pulseW1, pulseW2, pulseW3, pulseW4, pulseW5];

% Onset Phase of Pulse Activation (rad)
onsetphase1     = param_ctrl(7)      *0.01 *(T_gaitCycle/(2*pi)); %[rad] -> [/gait cycle] -> [s]
onsetphase2     = param_ctrl(8)      *1.59*(T_gaitCycle/(2*pi)); %[rad] -> [/gait cycle] -> [s]
onsetphase3     = param_ctrl(9)      *2.44*(T_gaitCycle/(2*pi)); %[rad] -> [/gait cycle] -> [s]
onsetphase4     = param_ctrl(10)     *3.69*(T_gaitCycle/(2*pi)); %[rad] -> [/gait cycle] -> [s]
onsetphase5     = param_ctrl(11)     *5.36*(T_gaitCycle/(2*pi)); %[rad] -> [/gait cycle] -> [s]
onsetphase = [onsetphase1, onsetphase2, onsetphase3, onsetphase4, onsetphase5];
% clip onsetphase to maintain boundaries:
onsetphase = mod(onsetphase, T_gaitCycle);
onsetphase1 = mod(onsetphase1, T_gaitCycle);
onsetphase2 = mod(onsetphase2, T_gaitCycle);
onsetphase3 = mod(onsetphase3, T_gaitCycle);
onsetphase4 = mod(onsetphase4, T_gaitCycle);
onsetphase5 = mod(onsetphase5, T_gaitCycle);
onsetphase_LLegStart = param_ctrl(12)      *(0.01)*(T_gaitCycle/(2*pi)); % [rad] --> [s]
onsetphase_RLegStart = (onsetphase_LLegStart*((2*pi)/T_gaitCycle) + pi)*(T_gaitCycle/(2*pi)); % {([rad] --> [s]) + [pi rad]} --> s

% Duration of Pulse Activations (rad)
dur_1           = param_ctrl(13)     *0.75 * (T_gaitCycle/(2*pi)) *100; % [rad] -> [/ gait cycle] -> [%]
dur_2           = param_ctrl(14)     *1.10 * (T_gaitCycle/(2*pi)) *100; % [rad] -> [/ gait cycle] -> [%]
dur_3           = param_ctrl(15)     *1.20 * (T_gaitCycle/(2*pi)) *100; % [rad] -> [/ gait cycle] -> [%]
dur_4           = param_ctrl(16)     *1.07 * (T_gaitCycle/(2*pi)) *100; % [rad] -> [/ gait cycle] -> [%]
dur_5           = param_ctrl(17)     *0.94 * (T_gaitCycle/(2*pi)) *100; % [rad] -> [/ gait cycle] -> [%]

dur = [dur_1, dur_2, dur_3, dur_4, dur_5];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% polynomial pulse function;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t_ms = linspace(0, t_sim, 20000);
mod_t_ms = mod(t_ms + onsetphase_LLegStart, T_gaitCycle);
mod_t_msR = mod(t_ms + onsetphase_RLegStart, T_gaitCycle);

pulse1L = genPulses(mod_t_ms, onsetphase1, dur_1, synergyPow);
pulse2L = genPulses(mod_t_ms, onsetphase2, dur_2, synergyPow);
pulse3L = genPulses(mod_t_ms, onsetphase3, dur_3, synergyPow);
pulse4L = genPulses(mod_t_ms, onsetphase4, dur_4, synergyPow);
pulse5L = genPulses(mod_t_ms, onsetphase5, dur_5, synergyPow);

pulse1L = [t_ms', pulse1L];
pulse2L = [t_ms', pulse2L];
pulse3L = [t_ms', pulse3L];
pulse4L = [t_ms', pulse4L];
pulse5L = [t_ms', pulse5L];

pulse1R = genPulses(mod_t_msR, onsetphase1, dur_1, synergyPow);
pulse2R = genPulses(mod_t_msR, onsetphase2, dur_2, synergyPow);
pulse3R = genPulses(mod_t_msR, onsetphase3, dur_3, synergyPow);
pulse4R = genPulses(mod_t_msR, onsetphase4, dur_4, synergyPow);
pulse5R = genPulses(mod_t_msR, onsetphase5, dur_5, synergyPow);

pulse1R = [t_ms', pulse1R];
pulse2R = [t_ms', pulse2R];
pulse3R = [t_ms', pulse3R];
pulse4R = [t_ms', pulse4R];
pulse5R = [t_ms', pulse5R];

% Weighted Coefficients of activation pulses:
% Pulse 1 Weights:
w_GLU1          = param_ctrl(18)     *0.33;
w_VAS1          = param_ctrl(19)     *1.02;
w_TA1           = param_ctrl(20)     *0.27;

% Pulse 2 Weights:
w_SOL2          = param_ctrl(21)     *1.09;
w_GAS2          = param_ctrl(22)     *0.84;

% Pulse 3 Weights:
w_HFL3           = param_ctrl(23)     *0.99;
w_BFSH3         = param_ctrl(24)     *0.34;
w_TA3           = param_ctrl(25)     *0.97;
w_RF3           = param_ctrl(26)     *0.02;
w_GAS3          = param_ctrl(27)     *0.65;

% Pulse 4 Weights:
w_VAS4          = param_ctrl(28)     *0.23;
w_TA4           = param_ctrl(29)     *0.15;

% Pulse 5 Weights:
w_GLU5          = param_ctrl(30)     *1.17;
w_BFSH5         = param_ctrl(31)     *0.76;
w_RF5           = param_ctrl(32)     *0.29;
w_HAM5          = param_ctrl(33)     *0.14;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Movement Regulator %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gain Parameters:
% Trunk Balance
k_HFL           = param_ctrl(34)     *+1.0;
k_GLU           = param_ctrl(35)     *-2.0;
sigma_HFL       = param_ctrl(36)     *+0.2;
sigma_GLU       = param_ctrl(37)     *-0.4;
theta_trunk_tgt = param_ctrl(38)     *0.01;

%Speed Balance
lambda_TA       = param_ctrl(39)     *-0.2;
lambda_SOL      = param_ctrl(40)     *0.04;
v_tgt           = param_ctrl(41)     *1.6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Additional Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pulse = genPulses(t_ms, onsetphase, dur, synergyPow)
    pulse = zeros(length(t_ms), 1);
    a = -1/(onsetphase - (onsetphase + dur/200))^synergyPow;
    for i = 1:length(t_ms)
        if onsetphase < t_ms(i) && t_ms(i) <= (onsetphase + dur/100)
            % pulse(i) = 1;
            pulse(i) = a*((t_ms(i)) - (onsetphase + dur/200))^synergyPow + 1;
        end
    end
end