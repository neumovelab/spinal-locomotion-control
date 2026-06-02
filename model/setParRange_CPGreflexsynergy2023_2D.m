%
% setParRange.m
%   set parameter boundary for muscle synergy controller
% 
% set:
%   parRange
%
% by Vincent Ton
% November 2024

LN = 1e3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Central Pattern Generator %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parRange2D(1, :) = [-1 1];
parRange2D(2, :) = [-1 1];
parRange2D(3, :) = [-1 1];
parRange2D(4, :) = [-1 1];
parRange2D(5, :) = [-1 1];
parRange2D(6, :) = [-1 1];
parRange2D(7, :) = [-1 1];
parRange2D(8, :) = [-1 1];
parRange2D(9, :) = [-1 1];

parRange2D(10, :) = [-1 1];
parRange2D(11, :) = [-1 1];
parRange2D(12, :) = [-1 1];
parRange2D(13, :) = [-1 1];
parRange2D(14, :) = [-1 1];
parRange2D(15, :) = [-1 1];
parRange2D(16, :) = [-1 1];
parRange2D(17, :) = [-1 1];
parRange2D(18, :) = [-1 1];

parRange2D(19, :) = [-1 1];
parRange2D(20, :) = [-1 1];
parRange2D(21, :) = [-1 1];
parRange2D(22, :) = [-1 1];
parRange2D(23, :) = [-1 1];
parRange2D(24, :) = [-1 1];
parRange2D(25, :) = [-1 1];
parRange2D(26, :) = [-1 1];
parRange2D(27, :) = [-1 1];

parRange2D(28, :) = [-1 1];
parRange2D(29, :) = [-1 1];
parRange2D(30, :) = [-1 1];
parRange2D(31, :) = [-1 1];
parRange2D(32, :) = [-1 1];
parRange2D(33, :) = [-1 1];
parRange2D(34, :) = [-1 1];
parRange2D(35, :) = [-1 1];
parRange2D(36, :) = [-1 1];

parRange2D(37, :) = [-1 1];
parRange2D(38, :) = [-1 1];
parRange2D(39, :) = [-1 1];
parRange2D(40, :) = [-1 1];
parRange2D(41, :) = [-1 1];
parRange2D(42, :) = [-1 1];
parRange2D(43, :) = [-1 1];
parRange2D(44, :) = [-1 1];
parRange2D(45, :) = [-1 1];

parRange  	= parRange2D;

% Keep in range
v_parOffcpgreflexsynergy	= zeros(length(w_cpgreflexsynergy),1);
for iP = 1:length(w_cpgreflexsynergy)
    % calculate how off param is
    v_parOffcpgreflexsynergy(iP) = v_parOffcpgreflexsynergy(iP) + (-w_cpgreflexsynergy(iP)+parRange(iP,1))*(w_cpgreflexsynergy(iP)<parRange(iP,1));
    v_parOffcpgreflexsynergy(iP) = v_parOffcpgreflexsynergy(iP) + (w_cpgreflexsynergy(iP)-parRange(iP,2))*(w_cpgreflexsynergy(iP)>parRange(iP,2));

    % keep param in range
    w_cpgreflexsynergy(iP)	= max(parRange(iP,1), min(parRange(iP,2), w_cpgreflexsynergy(iP)));
end

w1HFL           = w_cpgreflexsynergy(1);
w1GLU           = w_cpgreflexsynergy(2);
w1HAM           = w_cpgreflexsynergy(3);
w1RF            = w_cpgreflexsynergy(4);
w1VAS           = w_cpgreflexsynergy(5);
w1BFSH          = w_cpgreflexsynergy(6);
w1GAS           = w_cpgreflexsynergy(7);
w1SOL           = w_cpgreflexsynergy(8);
w1TA            = w_cpgreflexsynergy(9);

w2HFL           = w_cpgreflexsynergy(10);
w2GLU           = w_cpgreflexsynergy(11);
w2HAM           = w_cpgreflexsynergy(12);
w2RF            = w_cpgreflexsynergy(13);
w2VAS           = w_cpgreflexsynergy(14);
w2BFSH          = w_cpgreflexsynergy(15);
w2GAS           = w_cpgreflexsynergy(16);
w2SOL           = w_cpgreflexsynergy(17);
w2TA            = w_cpgreflexsynergy(18);

w3HFL           = w_cpgreflexsynergy(19);
w3GLU           = w_cpgreflexsynergy(20);
w3HAM           = w_cpgreflexsynergy(21);
w3RF            = w_cpgreflexsynergy(22);
w3VAS           = w_cpgreflexsynergy(23);
w3BFSH          = w_cpgreflexsynergy(24);
w3GAS           = w_cpgreflexsynergy(25);
w3SOL           = w_cpgreflexsynergy(26);
w3TA            = w_cpgreflexsynergy(27);

w4HFL           = w_cpgreflexsynergy(28);
w4GLU           = w_cpgreflexsynergy(29);
w4HAM           = w_cpgreflexsynergy(30);
w4RF            = w_cpgreflexsynergy(31);
w4VAS           = w_cpgreflexsynergy(32);
w4BFSH          = w_cpgreflexsynergy(33);
w4GAS           = w_cpgreflexsynergy(34);
w4SOL           = w_cpgreflexsynergy(35);
w4TA            = w_cpgreflexsynergy(36);

w5HFL           = w_cpgreflexsynergy(37);
w5GLU           = w_cpgreflexsynergy(38);
w5HAM           = w_cpgreflexsynergy(39);
w5RF            = w_cpgreflexsynergy(40);
w5VAS           = w_cpgreflexsynergy(41);
w5BFSH          = w_cpgreflexsynergy(42);
w5GAS           = w_cpgreflexsynergy(43);
w5SOL           = w_cpgreflexsynergy(44);
w5TA            = w_cpgreflexsynergy(45);

parOffcpgreflexsynergy1 = sum(v_parOffcpgreflexsynergy);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reflex controller
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parRange2D(61, :)        = [0 LN];
parRange2D(62, :)        = [0 LN];
parRange2D(63, :)        = [0 LN];
parRange2D(64, :)        = [0 LN];
parRange2D(65, :)        = [0 LN];
parRange2D(66, :)        = [0 LN];
parRange2D(67, :)        = [0 LN];
parRange2D(68, :)        = [0 LN];
parRange2D(69, :)        = [0 LN];
parRange2D(70, :)        = [0 LN];
parRange2D(71, :)        = [0 LN];
parRange2D(72, :)        = [0 LN];
parRange2D(73, :)        = [0 LN];
parRange2D(74, :)        = [0 LN];
parRange2D(75, :)        = [0 LN];
parRange2D(76, :)        = [0 LN];
parRange2D(77, :)        = [0 LN];
parRange2D(78, :)        = [0 LN];
parRange2D(79, :)        = [0 LN];
parRange2D(80, :)        = [0 LN];
parRange2D(81, :)        = [0 LN];
parRange2D(82, :)        = [0 LN];
parRange2D(83, :)        = [0 LN];
parRange2D(84, :)        = [0 LN];
parRange2D(85, :)        = [0 LN];
parRange2D(86, :)        = [0 LN];
parRange2D(87, :)        = [0 LN];
parRange2D(88, :)        = [0 LN];
parRange2D(89, :)        = [0 LN];
parRange2D(90, :)        = [0 LN];
parRange2D(91, :)        = [0 LN];
parRange2D(92, :)        = [0 LN];
parRange2D(93, :)        = [0 LN];
parRange2D(94, :)        = [0 LN];
parRange2D(95, :)        = [0 LN];
parRange2D(96, :)        = [0 LN];
parRange2D(97, :)        = [0 LN];
parRange2D(98, :)        = [0 LN];
parRange2D(99, :)        = [0 LN];
parRange2D(100, :)       = [0 LN];
parRange2D(101, :)       = [0 LN];
parRange2D(102, :)       = [0 LN];
parRange2D(103, :)       = [0 LN];
parRange2D(104, :)       = [0 LN];
parRange2D(105, :)       = [0 LN];
parRange2D(106, :)       = [0 LN];
parRange2D(107, :)       = [0 LN];
parRange2D(108, :)       = [0 LN];
parRange2D(109, :)       = [0 LN];
parRange2D(110, :)       = [0 LN];
parRange2D(111, :)       = [0 LN];
parRange2D(112, :)       = [0 LN];
parRange2D(113, :)       = [0 LN];
parRange2D(114, :)       = [0 LN];
parRange2D(115, :)       = [0 LN];
parRange2D(116, :)       = [0 LN];
parRange2D(117, :)       = [0 LN];
parRange2D(118, :)       = [0 LN];
parRange2D(119, :)       = [0 LN];
parRange2D(120, :)       = [0 LN];
parRange2D(121, :)       = [0 LN];
parRange2D(122, :)       = [0 LN];
parRange2D(123, :)       = [0 LN];
parRange2D(124, :)       = [0 LN];
parRange2D(125, :)       = [0 LN];
parRange2D(126, :)       = [0 LN];
parRange2D(127, :)       = [0 LN];
parRange2D(128, :)       = [0 LN];
parRange2D(129, :)       = [0 LN];
parRange2D(130, :)       = [0 LN];
parRange2D(131, :)       = [0 LN];
parRange2D(132, :)       = [0 LN];
parRange2D(133, :)       = [0 LN];
parRange2D(134, :)       = [0 LN];
parRange2D(135, :)       = [0 LN];
parRange2D(136, :)       = [0 LN];
parRange2D(137, :)       = [0 LN];
parRange2D(138, :)       = [0 LN];
parRange2D(139, :)       = [0 LN];
parRange2D(140, :)       = [0 LN];
parRange2D(141, :)       = [0 LN];
parRange2D(142, :)       = [0 LN];
parRange2D(143, :)       = [0 LN];
parRange2D(144, :)       = [0 LN];
parRange2D(145, :)       = [0 LN];
parRange2D(146, :)       = [0 LN];
parRange2D(147, :)       = [0 LN];
parRange2D(148, :)       = [0 LN];
parRange2D(149, :)       = [0 LN];
parRange2D(150, :)       = [0 LN];
parRange2D(151, :)       = [0 LN];
parRange2D(152, :)       = [0 LN];
parRange2D(153, :)       = [0 LN];
parRange2D(154, :)       = [0 LN];
parRange2D(155, :)       = [0 LN];
parRange2D(156, :)       = [0 LN];
parRange2D(157, :)       = [0 LN];
parRange2D(158, :)       = [0 LN];
parRange2D(159, :)       = [0 LN];
parRange2D(160, :)       = [0 LN];
parRange2D(161, :)       = [0 LN];
parRange2D(162, :)       = [0 LN];
parRange2D(163, :)       = [0 LN];
parRange2D(164, :)       = [0 LN];
parRange2D(165, :)       = [0 LN];
parRange2D(166, :)       = [0 LN];
parRange2D(167, :)       = [0 LN];
parRange2D(168, :)       = [0 LN];
parRange2D(169, :)       = [0 LN];
parRange2D(170, :)       = [0 LN];
parRange2D(171, :)       = [0 LN];
parRange2D(172, :)       = [0 LN];
parRange2D(173, :)       = [0 LN];
parRange2D(174, :)       = [0 LN];
parRange2D(175, :)       = [0 LN];
parRange2D(176, :)       = [0 LN];
parRange2D(177, :)       = [0 LN];
parRange2D(178, :)       = [0 LN];
parRange2D(179, :)       = [0 LN];
parRange2D(180, :)       = [0 LN];
parRange2D(181, :)       = [0 LN];
parRange2D(182, :)       = [0 LN];
parRange2D(183, :)       = [0 LN];
parRange2D(184, :)       = [0 LN];
parRange2D(185, :)       = [0 LN];
parRange2D(186, :)       = [0 LN];
parRange2D(187, :)       = [0 LN];
parRange2D(188, :)       = [0 LN];
parRange2D(189, :)       = [0 LN];
parRange2D(190, :)       = [0 LN];
parRange2D(191, :)       = [0 LN];
parRange2D(192, :)       = [0 LN];
parRange2D(193, :)       = [0 LN];
parRange2D(194, :)       = [0 LN];
parRange2D(195, :)       = [0 LN];
parRange2D(196, :)       = [0 LN];
parRange2D(197, :)       = [0 LN];
parRange2D(198, :)       = [0 LN];
parRange2D(199, :)       = [0 LN];
parRange2D(200, :)       = [0 LN];
parRange2D(201, :)       = [0 LN];
parRange2D(202, :)       = [0 LN];
parRange2D(203, :)       = [0 LN];
parRange2D(204, :)       = [0 LN];
parRange2D(205, :)       = [0 LN];
parRange2D(206, :)       = [0 LN];
parRange2D(207, :)       = [0 LN];
parRange2D(208, :)       = [0 LN];
parRange2D(209, :)       = [0 LN];
parRange2D(210, :)       = [0 LN];
parRange2D(211, :)       = [0 LN];
parRange2D(212, :)       = [0 LN];
parRange2D(213, :)       = [0 LN];
parRange2D(214, :)       = [0 LN];
parRange2D(215, :)       = [0 LN];
parRange2D(216, :)       = [0 LN];
parRange2D(217, :)       = [0 LN];
parRange2D(218, :)       = [0 LN];
parRange2D(219, :)       = [0 LN];
parRange2D(220, :)       = [0 LN];
parRange2D(221, :)       = [0 LN];
parRange2D(222, :)       = [0 LN];
parRange2D(223, :)       = [0 LN];
parRange2D(224, :)       = [0 LN];
parRange2D(225, :)       = [0 LN];
parRange2D(226, :)       = [0 LN];
parRange2D(227, :)       = [0 LN];
parRange2D(228, :)       = [0 LN];
parRange2D(229, :)       = [0 LN];
parRange2D(230, :)       = [0 LN];
parRange2D(231, :)       = [0 LN];
parRange2D(232, :)       = [0 LN];
parRange2D(233, :)       = [0 LN];
parRange2D(234, :)       = [0 LN];
parRange2D(235, :)       = [0 LN];
parRange2D(236, :)       = [0 LN];
parRange2D(237, :)       = [0 LN];
parRange2D(238, :)       = [0 LN];
parRange2D(239, :)       = [0 LN];
parRange2D(240, :)       = [0 LN];

parRange  	= parRange2D;

% Keep in range
v_parOffcpgreflexsynergy	= zeros(length(param_ctrl),1);
for iP = 58:length(param_ctrl)
    % calculate how off param is
    v_parOffcpgreflexsynergy(iP) = v_parOffcpgreflexsynergy(iP) + (-param_ctrl(iP)+parRange(iP,1))*(param_ctrl(iP)<parRange(iP,1));
    v_parOffcpgreflexsynergy(iP) = v_parOffcpgreflexsynergy(iP) + (param_ctrl(iP)-parRange(iP,2))*(param_ctrl(iP)>parRange(iP,2));

    % keep param in range
    param_ctrl(iP)	= max(parRange(iP,1), min(parRange(iP,2), param_ctrl(iP)));
end
parOffcpgreflexsynergy2 = sum(v_parOffcpgreflexsynergy);

parOff_cpgreflexsynergy = parOffcpgreflexsynergy1 + parOffcpgreflexsynergy2;
