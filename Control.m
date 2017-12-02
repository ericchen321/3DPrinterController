% This script sets the controller parameters for the SLS 3-D Printer

% ================
% CONTROLLER GAINS
% ================


% System (Open-loop) Transfer Functions
SysOLXF0 = minreal(MotorXF0, 1e-3);             % Open loop gain of the system
                                                % (PID) not included is
                                                % just the motors' gains
SysOLXF1 = minreal(MotorXF1, 1e-3);
[SysOLXF0p,SysOLXF0z]=pzmap(SysOLXF0);          % Open loop poles that will be cancelled by the PIDs
[SysOLXF1p,SysOLXF1z]=pzmap(SysOLXF1);

% For Q0: Root Locus
UnityGain = 1;                                  % We have to determine Kd later
PID0z = [SysOLXF0p(3) SysOLXF0p(4)];            % Defines which two open-loop poles to cancel
PID0p = [0];                                    % PID adds a zero to the open loop xfer fctn
PIDXF0 = zpk(PID0z, PID0p, UnityGain);          % PID0's transfer function with Kd undetermined
OLXF0 = minreal((PIDXF0 * SysOLXF0), 1e-3);
figure;
rlocus(OLXF0);
title('RLocus Q0');

% For Q1: Root Locus
PID1z = [SysOLXF1p(1) SysOLXF1p(4)]; % Defines which two open-loop poles to cancel
PID1p = [0]; % PID adds a zero to the open loop xfer fctn
PIDXF1 = zpk(PID1z, PID1p, UnityGain);  %PID0's transfer function with Kd undetermined
OLXF1 = minreal(PIDXF1 * SysOLXF1, 1e-3);
figure;
rlocus(OLXF1);
title('RLocus Q1');

% PID gain values for Q0 and Q1
[PID0n, PID0d] = tfdata(PIDXF0, 'v');   % extract num and den coefficicents
KpPerKd0 = PID0n(2);                    % ratio of Kp over Kd
KiPerKd0 = PID0n(3);                    % ratio of Ki over Kd
Kd0 = 0.0785;                           % Kd for Q0, chosen by humans
Kp0 = KpPerKd0 * Kd0;
Ki0 = KiPerKd0 * Kd0;
CLXF0 = (Kd0 * OLXF0) / (1 + Kd0 * OLXF0);

[PID1n, PID1d] = tfdata(PIDXF1, 'v');   % extract num and den coefficicents
KpPerKd1 = PID1n(2);
KiPerKd1 = PID1n(3);
Kd1 = 0.0025;                           % Kd for Q1, chosen by humans
Kp1 = KpPerKd1 * Kd1;
Ki1 = KiPerKd1 * Kd1;
CLXF1 = (Kd1 * OLXF1) / (1 + Kd1 * OLXF1);

% Enter optimized PID values here.
% No more than 3 significant figures per gain value.
PID0 = [0.178 8.83 0.0785];
PID1 = [0.123 0 0.00250];

% Enter feedback sensor values here.

FB0 = 1/Sens0;  % We want total gain along feedback loop to be 1
                % because we want the angle read by the sensors
                % to be the same as the actual output angle
FB1 = 1/Sens1;


% =====================
% Set-Point Time Vector
% =====================

% The Time Vector is stored in a variable called "Time".
% It's initial value is equally spaced for all samples and is
% set in TRAJECTORY.M
%
% Redefine this vector here to optimize the build time of the part.
% You can define it analytically or type in the elements manually but
% you must not change the length because it must contain one value for
% each Xd/Yd position pair.
% In the Matlab window, enter "length(Time)" to see how big it is.

% The Time vector must range from 0 to TotalTime

%Time       = 0:SampleTime:TotalTime;       % DO NOT CHANGE TotalTime
