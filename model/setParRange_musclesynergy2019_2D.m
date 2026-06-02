%
% setParRange.m
%   set parameter boundary for muscle synergy controller
% 
% set:
%   parRange
%
% by Vincent Ton
% November 2024
%

parRangeLim = 0.6; % [x %] of range

LN = 1e3;

parRange2D(1, :)        = [-LN LN]; % gait cycle

parRange2D(2, :)        = [-LN LN]; % Pulse amplitude
parRange2D(3, :)        = [-LN LN]; % Pulse amplitude
parRange2D(4, :)        = [-LN LN]; % Pulse amplitude
parRange2D(5, :)        = [-LN LN]; % Pulse amplitude
parRange2D(6, :)        = [-LN LN]; % Pulse amplitude

parRange2D(7, :)        = [1-parRangeLim, 1+parRangeLim]; % onset phase
parRange2D(8, :)        = [1-parRangeLim, 1+parRangeLim]; % onset phase
parRange2D(9, :)        = [1-parRangeLim, 1+parRangeLim]; % onset phase
parRange2D(10, :)       = [1-parRangeLim, 1+parRangeLim]; % onset phase
parRange2D(11, :)       = [1-parRangeLim, 1+parRangeLim]; % onset phase

parRange2D(12, :)       = [-LN LN]; % onsetphase left leg
parRange2D(13, :)       = [-LN LN]; % onsetphase right leg

parRange2D(14, :)       = [1-parRangeLim, 1+parRangeLim]; % pulse duration
parRange2D(15, :)       = [1-parRangeLim, 1+parRangeLim]; % pulse duration
parRange2D(16, :)       = [1-parRangeLim, 1+parRangeLim]; % pulse duration
parRange2D(17, :)       = [1-parRangeLim, 1+parRangeLim]; % pulse duration
parRange2D(18, :)       = [1-parRangeLim, 1+parRangeLim]; % pulse duration

parRange2D(19, :)       = [-LN LN]; % muscle pulse weights
parRange2D(20, :)       = [-LN LN]; % muscle pulse weights
parRange2D(21, :)       = [-LN LN]; % muscle pulse weights
parRange2D(22, :)       = [-LN LN]; % muscle pulse weights
parRange2D(23, :)       = [-LN LN]; % muscle pulse weights
parRange2D(24, :)       = [-LN LN]; % muscle pulse weights
parRange2D(25, :)       = [-LN LN]; % muscle pulse weights
parRange2D(26, :)       = [-LN LN]; % muscle pulse weights
parRange2D(27, :)       = [-LN LN]; % muscle pulse weights
parRange2D(28, :)       = [-LN LN]; % muscle pulse weights
parRange2D(29, :)       = [-LN LN]; % muscle pulse weights
parRange2D(30, :)       = [-LN LN]; % muscle pulse weights
parRange2D(31, :)       = [-LN LN]; % muscle pulse weights
parRange2D(32, :)       = [-LN LN]; % muscle pulse weights
parRange2D(33, :)       = [-LN LN]; % muscle pulse weights
parRange2D(34, :)       = [-LN LN]; % muscle pulse weights

parRange2D(35, :)       = [-LN LN]; % trunk balance weights
parRange2D(36, :)       = [-LN LN]; % trunk balance weights
parRange2D(37, :)       = [-LN LN]; % trunk balance weights
parRange2D(38, :)       = [-LN LN]; % trunk balance weights

parRange2D(39, :)       = [-LN LN]; % target theta

parRange2D(40, :)       = [-LN LN]; % speed control weights
parRange2D(41, :)       = [-LN LN]; % speed control weights

parRange2D(42, :)       = [-LN LN]; % target speed

parRange  	= parRange2D;