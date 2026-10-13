% Script sets initial values for simulation

x0                  = 0;
y0                  = 0;
phi0                = 0*pi/180;

vx0                 = param_ic(1)      *1.4; %[m/s] 
Lphi120             = param_ic(2)      *100*pi/180; %[rad]
Lphi230             = param_ic(3)      *180*pi/180; %[rad]
Lphi340             = param_ic(4)      *155*pi/180; %[rad]
Rphi120             = param_ic(5)      *90*pi/180; %[rad]
Rphi230             = param_ic(6)      *165*pi/180; %[rad]
Rphi340             = param_ic(7)      *190*pi/180; %[rad]

% initial delayed data
init_exc       = 0.01;
init_fm         = 0.01;
init_lce        = 1;
init_vce        = 0;
init_LStance    = 1;
init_RStance    = 0;

% Compute HAT initial conditions
xHAT0 = (-D12_F*cos(terrain_slope_angle)) - D12y_F*sin(terrain_slope_angle) ...
    + (D12_S*cos(terrain_slope_angle+Lphi120)) ...
    + (D12_T*cos(pi-(Lphi230-(terrain_slope_angle+Lphi120)))) ...
    + (L_HAT*0.5*cos(Lphi340-Lphi230+(terrain_slope_angle+Lphi120)));
yHAT0 = (-D12_F*sin(terrain_slope_angle)) + D12y_F*cos(terrain_slope_angle)...
    + (D12_S*sin(terrain_slope_angle+Lphi120)) ...
    + (D12_T*sin(pi-(Lphi230-(terrain_slope_angle+Lphi120)))) ...
    + (L_HAT*0.5*sin(Lphi340-Lphi230+(terrain_slope_angle+Lphi120)));
init_xyzHAT     = [xHAT0, yHAT0, 0];


xLShank0 = (-D12_F*cos(terrain_slope_angle)) - D12y_F*sin(terrain_slope_angle);
yLShank0 = (-D12_F*sin(terrain_slope_angle)) + D12y_F*cos(terrain_slope_angle);

xRShank0 = (-D12_F*cos(terrain_slope_angle)) - D12y_F*sin(terrain_slope_angle) ...
    + (D12_S*cos(terrain_slope_angle+Lphi120)) ...
    + (D12_T*cos(pi-(Lphi230-(terrain_slope_angle+Lphi120))))...
    + (D12_T*cos(2*pi-(Rphi340-(Lphi340-Lphi230+(terrain_slope_angle+Lphi120)))))...
    + D12_S*cos(Rphi230 + pi-(Rphi340 - (Lphi340-Lphi230+(terrain_slope_angle+Lphi120))));
yRShank0 = (-D12_F*sin(terrain_slope_angle)) + D12y_F*cos(terrain_slope_angle) ...
    + (D12_S*sin(terrain_slope_angle+Lphi120)) ...
    + (D12_T*sin(pi-(Lphi230-(terrain_slope_angle+Lphi120))))...
    + (D12_T*sin(2*pi-(Rphi340-(Lphi340-Lphi230+(terrain_slope_angle+Lphi120)))))...
    + D12_S*sin(Rphi230 + pi-(Rphi340 - (Lphi340-Lphi230+(terrain_slope_angle+Lphi120))));
init_xyzLShank = [xLShank0, yLShank0, 0];
init_xyzRShank = [xRShank0, yRShank0, 0];

init_theta = Lphi340 - (Lphi230 - (terrain_slope_angle+Lphi120));
if init_theta > pi/2
    init_theta = -(init_theta - pi/2);
else
    init_theta = pi/2 - init_theta;
end