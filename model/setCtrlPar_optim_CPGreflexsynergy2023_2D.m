% Script sets CPG-reflex-synergy control parameters

n_balance = 9;
n_cpg = 48;
n_reflex = 183;
n_CtrP = n_balance + n_cpg + n_reflex;

if length(param_ctrl) ~= n_CtrP
    flag_SS	= 0;
else
    flag_SS = 1;
end

tau_act_diRusso = 0.01;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Balance Controller %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tgt_theta_4_HFL = param_ctrl(1) * 0.01;
kp_4_HFL        = param_ctrl(2) * 1;
kv_4_HFL        = param_ctrl(3) * 1;

tgt_theta_4_GLU = param_ctrl(4) * 0.01;
kp_4_GLU        = param_ctrl(5) * 1;
kv_4_GLU        = param_ctrl(6) * 1;

tgt_theta_4_HAM = param_ctrl(7) * 0.01;
kp_4_HAM        = param_ctrl(8) * 1;
kv_4_HAM        = param_ctrl(9) * 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Central Pattern Generator %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
omega_4         = param_ctrl(10) * 2*pi;
gamma_4         = param_ctrl(11) * 1.7;

init_LCPG       = param_ctrl(12) * 0.01;
init_RCPG       = init_LCPG + pi;

u1              = 0.1 * 2*pi;
sigma1          = 0.2 * 2*pi;
u2              = 0.3 * 2*pi;
sigma2          = 0.2 * 2*pi;
u3              = 0.5 * 2*pi;
sigma3          = 0.2 * 2*pi;
u4              = 0.7 * 2*pi;
sigma4          = 0.2 * 2*pi;
u5              = 0.9 * 2*pi;
sigma5          = 0.2 * 2*pi;

w1HFL           = param_ctrl(13) * 1;
w1GLU           = param_ctrl(14) * 1;
w1HAM           = param_ctrl(15) * 1;
w1RF            = param_ctrl(16) * 1;
w1VAS           = param_ctrl(17) * 1;
w1BFSH          = param_ctrl(18) * 1;
w1GAS           = param_ctrl(19) * 1;
w1SOL           = param_ctrl(20) * 1;
w1TA            = param_ctrl(21) * 1;

w2HFL           = param_ctrl(22) * 1;
w2GLU           = param_ctrl(23) * 1;
w2HAM           = param_ctrl(24) * 1;
w2RF            = param_ctrl(25) * 1;
w2VAS           = param_ctrl(26) * 1;
w2BFSH          = param_ctrl(27) * 1;
w2GAS           = param_ctrl(28) * 1;
w2SOL           = param_ctrl(29) * 1;
w2TA            = param_ctrl(30) * 1;

w3HFL           = param_ctrl(31) * 1;
w3GLU           = param_ctrl(32) * 1;
w3HAM           = param_ctrl(33) * 1;
w3RF            = param_ctrl(34) * 1;
w3VAS           = param_ctrl(35) * 1;
w3BFSH          = param_ctrl(36) * 1;
w3GAS           = param_ctrl(37) * 1;
w3SOL           = param_ctrl(38) * 1;
w3TA            = param_ctrl(39) * 1;

w4HFL           = param_ctrl(40) * 1;
w4GLU           = param_ctrl(41) * 1;
w4HAM           = param_ctrl(42) * 1;
w4RF            = param_ctrl(43) * 1;
w4VAS           = param_ctrl(44) * 1;
w4BFSH          = param_ctrl(45) * 1;
w4GAS           = param_ctrl(46) * 1;
w4SOL           = param_ctrl(47) * 1;
w4TA            = param_ctrl(48) * 1;

w5HFL           = param_ctrl(49) * 1;
w5GLU           = param_ctrl(50) * 1;
w5HAM           = param_ctrl(51) * 1;
w5RF            = param_ctrl(52) * 1;
w5VAS           = param_ctrl(53) * 1;
w5BFSH          = param_ctrl(54) * 1;
w5GAS           = param_ctrl(55) * 1;
w5SOL           = param_ctrl(56) * 1;
w5TA            = param_ctrl(57) * 1;

% Keep weights within limits
w_cpgreflexsynergy = [w1HFL w1GLU w1HAM w1RF w1VAS w1BFSH w1GAS w1SOL w1TA ...
    w2HFL w2GLU w2HAM w2RF w2VAS w2BFSH w2GAS w2SOL w2TA ...
    w3HFL w3GLU w3HAM w3RF w3VAS w3BFSH w3GAS w3SOL w3TA ...
    w4HFL w4GLU w4HAM w4RF w4VAS w4BFSH w4GAS w4SOL w4TA ...
    w5HFL w5GLU w5HAM w5RF w5VAS w5BFSH w5GAS w5SOL w5TA];

setParRange_CPGreflexsynergy2023_2D;    % parRange for CPG weights

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reflex parameters - Interneurons %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%% Interneuron HFL %%%%%%%%%%%%%%%%%
k_INIA_HFL_SNIA_HFL         = param_ctrl(58) * 1;
k_INIA_HFL_INIA_GLU         = param_ctrl(59) * 1;
k_INIA_HFL_INIA_HAM         = param_ctrl(60) * 1;
k_INIA_HFL_INRC_GLU         = param_ctrl(61) * 1;
k_INIA_HFL_INRC_HAM         = param_ctrl(62) * 1;
k_INIA_HFL_MN_HFL           = param_ctrl(63) * 1;

k_INII_HFL_SNII_HFL         = param_ctrl(64) * 1;

k_INIB_HFL_SNIB_HFL         = param_ctrl(65) * 1;
k_INIB_HFL_INIB_GLU         = param_ctrl(66) * 1;
k_INIB_HFL_INIB_HAM         = param_ctrl(67) * 1;

k_INRC_HFL_Act_HFL          = param_ctrl(68) * 1;
k_INRC_HFL_INRC_GLU         = param_ctrl(69) * 1;
k_INRC_HFL_INRC_HAM         = param_ctrl(70) * 1;

%%%%%%%%%%%%%% Interneuron GLU %%%%%%%%%%%%%%%%
k_INIA_GLU_SNIA_GLU         = param_ctrl(71) * 1;
k_INIA_GLU_INIA_HFL         = param_ctrl(72) * 1;
k_INIA_GLU_INRC_HFL         = param_ctrl(73) * 1;
k_INIA_GLU_MN_GLU           = param_ctrl(74) * 1;

k_INII_GLU_SNII_GLU         = param_ctrl(75) * 1;

k_INIB_GLU_SNIB_GLU         = param_ctrl(76) * 1;
k_INIB_GLU_INIB_HFL         = param_ctrl(77) * 1;

k_INIB_GLU_SNIBext_GLU      = param_ctrl(78) * 1;

k_INRC_GLU_Act_GLU          = param_ctrl(79) * 1;
k_INRC_GLU_INRC_HFL         = param_ctrl(80) * 1;

%%%%%%%%%%%%%% Interneuron HAM %%%%%%%%%%%%%%%%
k_INIA_HAM_SNIA_HAM         = param_ctrl(81) * 1;
k_INIA_HAM_INIA_VAS         = param_ctrl(82) * 1;
k_INIA_HAM_INIA_RF          = param_ctrl(83) * 1;
k_INIA_HAM_INRC_VAS         = param_ctrl(84) * 1;
k_INIA_HAM_INRC_RF          = param_ctrl(85) * 1;
k_INIA_HAM_MN_HAM           = param_ctrl(86) * 1;

k_INII_HAM_SNII_HAM         = param_ctrl(87) * 1;

k_INIB_HAM_SNIB_HAM         = param_ctrl(88) * 1;
k_INIB_HAM_INIB_VAS         = param_ctrl(89) * 1;
k_INIB_HAM_INIB_RF          = param_ctrl(90) * 1;

k_INIB_HAM_SNIBext_HAM      = param_ctrl(91) * 1;

k_INRC_HAM_Act_HAM          = param_ctrl(92) * 1;
k_INRC_HAM_INRC_VAS         = param_ctrl(93) * 1;
k_INRC_HAM_INRC_RF          = param_ctrl(94) * 1;

%%%%%%%%%%%%%% Interneuron RF  %%%%%%%%%%%%%%%%
k_INIA_RF_SNIA_RF           = param_ctrl(95) * 1;
k_INIA_RF_INIA_HAM          = param_ctrl(96) * 1;
k_INIA_RF_INIA_BFSH         = param_ctrl(97) * 1;
k_INIA_RF_INRC_HAM          = param_ctrl(98) * 1;
k_INIA_RF_INRC_BFSH         = param_ctrl(99) * 1;
k_INIA_RF_MN_RF             = param_ctrl(100) * 1;

k_INII_RF_SNII_RF           = param_ctrl(101) * 1;

k_INIB_RF_SNIB_RF           = param_ctrl(102) * 1;
k_INIB_RF_INIB_HAM          = param_ctrl(103) * 1;
k_INIB_RF_INIB_BFSH         = param_ctrl(104) * 1;

k_INIB_RF_SNIBext_RF        = param_ctrl(105) * 1;

k_INRC_RF_Act_RF            = param_ctrl(106) * 1;
k_INRC_RF_INRC_HAM          = param_ctrl(107) * 1;
k_INRC_RF_INRC_BFSH         = param_ctrl(108) * 1;

%%%%%%%%%%%%%% Interneuron VAS %%%%%%%%%%%%%%%%
k_INIA_VAS_SNIA_VAS         = param_ctrl(109) * 1;
k_INIA_VAS_INIA_HAM         = param_ctrl(110) * 1;
k_INIA_VAS_INIA_BFSH        = param_ctrl(111) * 1;
k_INIA_VAS_INRC_HAM         = param_ctrl(112) * 1;
k_INIA_VAS_INRC_BFSH        = param_ctrl(113) * 1;
k_INIA_VAS_MN_VAS           = param_ctrl(114) * 1;

k_INII_VAS_SNII_VAS         = param_ctrl(115) * 1;

k_INIB_VAS_SNIB_VAS         = param_ctrl(116) * 1;
k_INIB_VAS_INIB_HAM         = param_ctrl(117) * 1;
k_INIB_VAS_INIB_BFSH        = param_ctrl(118) * 1;

k_INIB_VAS_SNIBext_VAS      = param_ctrl(119) * 1;

k_INRC_VAS_Act_VAS          = param_ctrl(120) * 1;
k_INRC_VAS_INRC_HAM         = param_ctrl(121) * 1;
k_INRC_VAS_INRC_BFSH        = param_ctrl(122) * 1;

%%%%%%%%%%%%%% Interneuron BFSH %%%%%%%%%%%%%%%%
k_INIA_BFSH_SNIA_BFSH       = param_ctrl(123) * 1;
k_INIA_BFSH_INIA_VAS        = param_ctrl(124) * 1;
k_INIA_BFSH_INIA_RF         = param_ctrl(125) * 1;
k_INIA_BFSH_INRC_VAS        = param_ctrl(126) * 1;
k_INIA_BFSH_INRC_RF         = param_ctrl(127) * 1;
k_INIA_BFSH_MN_BFSH         = param_ctrl(128) * 1;

k_INII_BFSH_SNII_BFSH       = param_ctrl(129) * 1;

k_INIB_BFSH_SNIB_BFSH       = param_ctrl(130) * 1;
k_INIB_BFSH_INIB_VAS        = param_ctrl(131) * 1;
k_INIB_BFSH_INIB_RF         = param_ctrl(132) * 1;

k_INRC_BFSH_Act_BFSH        = param_ctrl(133) * 1;
k_INRC_BFSH_INRC_VAS        = param_ctrl(134) * 1;
k_INRC_BFSH_INRC_RF         = param_ctrl(135) * 1;

%%%%%%%%%%%%%% Interneuron GAS %%%%%%%%%%%%%%%%
k_INIA_GAS_SNIA_GAS         = param_ctrl(136) * 1;
k_INIA_GAS_INIA_TA          = param_ctrl(137) * 1;
k_INIA_GAS_INRC_TA          = param_ctrl(138) * 1;
k_INIA_GAS_MN_GAS           = param_ctrl(139) * 1;

k_INII_GAS_SNII_GAS         = param_ctrl(140) * 1;

k_INIB_GAS_SNIB_GAS         = param_ctrl(141) * 1;
k_INIB_GAS_INIB_TA          = param_ctrl(142) * 1;

k_INIB_GAS_SNIBext_GAS      = param_ctrl(143) * 1;

k_INRC_GAS_Act_GAS          = param_ctrl(144) * 1;
k_INRC_GAS_INRC_TA          = param_ctrl(145) * 1;

%%%%%%%%%%%%%% Interneuron SOL %%%%%%%%%%%%%%%%
k_INIA_SOL_SNIA_SOL         = param_ctrl(146) * 1;
k_INIA_SOL_INIA_TA          = param_ctrl(147) * 1;
k_INIA_SOL_INRC_TA          = param_ctrl(148) * 1;
k_INIA_SOL_MN_SOL           = param_ctrl(149) * 1;

k_INII_SOL_SNII_SOL         = param_ctrl(150) * 1;

k_INIB_SOL_SNIB_SOL         = param_ctrl(151) * 1;
k_INIB_SOL_INIB_TA          = param_ctrl(152) * 1;

k_INIB_SOL_SNIBext_SOL      = param_ctrl(153) * 1;

k_INRC_SOL_Act_SOL          = param_ctrl(154) * 1;
k_INRC_SOL_INRC_TA          = param_ctrl(155) * 1;

%%%%%%%%%%%%%% Interneuron TA %%%%%%%%%%%%%%%%
k_INIA_TA_SNIA_TA           = param_ctrl(156) * 1;
k_INIA_TA_INIA_GAS          = param_ctrl(157) * 1;
k_INIA_TA_INIA_SOL          = param_ctrl(158) * 1;
k_INIA_TA_INRC_GAS          = param_ctrl(159) * 1;
k_INIA_TA_INRC_SOL          = param_ctrl(160) * 1;
k_INIA_TA_MN_TA             = param_ctrl(161) * 1;

k_INII_TA_SNII_TA           = param_ctrl(162) * 1;

k_INIB_TA_SNIB_TA           = param_ctrl(163) * 1;
k_INIB_TA_INIB_GAS          = param_ctrl(164) * 1;
k_INIB_TA_INIB_SOL          = param_ctrl(165) * 1;

k_INRC_TA_Act_TA            = param_ctrl(166) * 1;
k_INRC_TA_INRC_GAS          = param_ctrl(167) * 1;
k_INRC_TA_INRC_SOL          = param_ctrl(168) * 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reflex parameters - motoneurons %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Motoneuron HFL %%%%%%%%%%%%%%%%%
k_MN_HFL_SNIA_HFL           = param_ctrl(169) * 1;
k_MN_HFL_INIA_GLU           = param_ctrl(170) * 1;
k_MN_HFL_INIA_HAM           = param_ctrl(171) * 1;
k_MN_HFL_INII_HFL           = param_ctrl(172) * 1;
k_MN_HFL_INII_GLU           = param_ctrl(173) * 1;
k_MN_HFL_INII_HAM           = param_ctrl(174) * 1;
k_MN_HFL_INIB_HFL           = param_ctrl(175) * 1;
k_MN_HFL_INRC_HFL           = param_ctrl(176) * 1;

%%%%%%%%%%%%%% Motoneuron GLU %%%%%%%%%%%%%%%%%
k_MN_GLU_SNIA_GLU           = param_ctrl(177) * 1;
k_MN_GLU_INIA_HFL           = param_ctrl(178) * 1;
k_MN_GLU_INII_GLU           = param_ctrl(179) * 1;
k_MN_GLU_INII_HFL           = param_ctrl(180) * 1;
k_MN_GLU_INIB_GLU           = param_ctrl(181) * 1;
k_MN_GLU_INIBext_GLU        = param_ctrl(182) * 1;
k_MN_GLU_INRC_GLU           = param_ctrl(183) * 1;

%%%%%%%%%%%%%% Motoneuron HAM %%%%%%%%%%%%%%%%%
k_MN_HAM_SNIA_HAM           = param_ctrl(184) * 1;
k_MN_HAM_INIA_VAS           = param_ctrl(185) * 1;
k_MN_HAM_INIA_RF            = param_ctrl(186) * 1;
k_MN_HAM_INII_HAM           = param_ctrl(187) * 1;
k_MN_HAM_INII_VAS           = param_ctrl(188) * 1;
k_MN_HAM_INII_RF            = param_ctrl(189) * 1;
k_MN_HAM_INIB_HAM           = param_ctrl(190) * 1;
k_MN_HAM_INIBext_HAM        = param_ctrl(191) * 1;
k_MN_HAM_INRC_HAM           = param_ctrl(192) * 1;

%%%%%%%%%%%%%% Motoneuron RF  %%%%%%%%%%%%%%%%%
k_MN_RF_SNIA_RF             = param_ctrl(193) * 1;
k_MN_RF_INIA_HAM            = param_ctrl(194) * 1;
k_MN_RF_INIA_BFSH           = param_ctrl(195) * 1;
k_MN_RF_INII_RF             = param_ctrl(196) * 1;
k_MN_RF_INII_HAM            = param_ctrl(197) * 1;
k_MN_RF_INII_BFSH           = param_ctrl(198) * 1;
k_MN_RF_INIB_RF             = param_ctrl(199) * 1;
k_MN_RF_INIBext_RF          = param_ctrl(200) * 1;
k_MN_RF_INRC_RF             = param_ctrl(201) * 1;

%%%%%%%%%%%%%% Motoneuron VAS %%%%%%%%%%%%%%%%%
k_MN_VAS_SNIA_VAS           = param_ctrl(202) * 1;
k_MN_VAS_INIA_HAM           = param_ctrl(203) * 1;
k_MN_VAS_INIA_BFSH          = param_ctrl(204) * 1;
k_MN_VAS_INII_VAS           = param_ctrl(205) * 1;
k_MN_VAS_INII_HAM           = param_ctrl(206) * 1;
k_MN_VAS_INII_BFSH          = param_ctrl(207) * 1;
k_MN_VAS_INIB_VAS           = param_ctrl(208) * 1;
k_MN_VAS_INIBext_VAS        = param_ctrl(209) * 1;
k_MN_VAS_INRC_VAS           = param_ctrl(210) * 1;

%%%%%%%%%%%%%% Motoneuron BFSH %%%%%%%%%%%%%%%%
k_MN_BFSH_SNIA_BFSH         = param_ctrl(211) * 1;
k_MN_BFSH_INIA_VAS          = param_ctrl(212) * 1;
k_MN_BFSH_INIA_RF           = param_ctrl(213) * 1;
k_MN_BFSH_INII_BFSH         = param_ctrl(214) * 1;
k_MN_BFSH_INII_VAS          = param_ctrl(215) * 1;
k_MN_BFSH_INII_RF           = param_ctrl(216) * 1;
k_MN_BFSH_INIB_BFSH         = param_ctrl(217) * 1;
k_MN_BFSH_INRC_BFSH         = param_ctrl(218) * 1;

%%%%%%%%%%%%%% Motoneuron GAS %%%%%%%%%%%%%%%%
k_MN_GAS_SNIA_GAS           = param_ctrl(219) * 1;
k_MN_GAS_INIA_TA            = param_ctrl(220) * 1;
k_MN_GAS_INII_GAS           = param_ctrl(221) * 1;
k_MN_GAS_INII_TA            = param_ctrl(222) * 1;
k_MN_GAS_INIB_GAS           = param_ctrl(223) * 1;
k_MN_GAS_INIBext_GAS        = param_ctrl(224) * 1;
k_MN_GAS_INRC_GAS           = param_ctrl(225) * 1;

%%%%%%%%%%%%%% Motoneuron SOL %%%%%%%%%%%%%%%%
k_MN_SOL_SNIA_SOL           = param_ctrl(226) * 1;
k_MN_SOL_INIA_TA            = param_ctrl(227) * 1;
k_MN_SOL_INII_SOL           = param_ctrl(228) * 1;
k_MN_SOL_INII_TA            = param_ctrl(229) * 1;
k_MN_SOL_INIB_SOL           = param_ctrl(230) * 1;
k_MN_SOL_INIBext_SOL        = param_ctrl(231) * 1;
k_MN_SOL_INRC_SOL           = param_ctrl(232) * 1;

%%%%%%%%%%%%%% Motoneuron HFL %%%%%%%%%%%%%%%%%
k_MN_TA_SNIA_TA             = param_ctrl(233) * 1;
k_MN_TA_INIA_GAS            = param_ctrl(234) * 1;
k_MN_TA_INIA_SOL            = param_ctrl(235) * 1;
k_MN_TA_INII_TA             = param_ctrl(236) * 1;
k_MN_TA_INII_GAS            = param_ctrl(237) * 1;
k_MN_TA_INII_SOL            = param_ctrl(238) * 1;
k_MN_TA_INIB_TA             = param_ctrl(239) * 1;
k_MN_TA_INRC_TA             = param_ctrl(240) * 1;

