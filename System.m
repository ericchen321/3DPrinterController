% This script sets the model parameters for the SLS 3-D Printer

% Example: Specifying a Dynamics Block
% n = [1 2 3];
% d = [4 5 6];
% Transfer Function = (s^2 + 2s + 3) / (4s^2 + 5s + 6)

% ========================
% PHYSICAL UNIT CONVERSION
% ========================
% Example: if you decide to work in (Kg), all masses must be represented
%          in (Kg) but the spec sheet may provide masses in (g)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Over-write the default values from DEFAULT.m %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ==========================
% Choose Motors
% ==========================
AMAX22_5W_SB;                % Default Maxon motor
Q0 = MotorParam;
Q1 = MotorParam;

% Motor Unit Conversions
ConversionArray = ...
...             
[1                      % NomV          (V)
 RadPSecPerRPM          % NoLoadSpd     (rpm)
 0.001                  % NoLoadCurr    (mA)
 RadPSecPerRPM          % NomSpd        (rpm)
 0.001                  % NomTorque     (mNm)
 0.001                  % NomCurr       (mA)
 0.001                  % StallTorque   (mNm)
 1                      % StallCurr     (A)
 0.01                   % MaxEff        (%)
...
...                     % Characteristics
 1                      % TermR         (Ohms)
 0.001                  % TermL         (mH)
 0.001                  % TorqueConst   (mNm/A)
 RadPSecPerRPM          % SpdConst      (rpm/V)
 RadPSecPerRPM*1000     % SpdTorqueGrad (rpm/mNm)
 0.001                  % MechTimeConst (ms)
 1e-7                   % RotJ          (gcm^2)
...
...                     % Thermal Data
 1                      % ThermRhous    (K/W)
 1                      % ThermRwind    (K/W)
 1                      % ThermTCwind   (s)
 1                      % ThermTCmot    (s) 
 1                      % AmbTemp       (degC) --NEED LATER CONVERSION
 1                      % MaxTemp       (degC) --NEED LATER CONVERSION
...
...                     % Mechanical Data
 RadPSecPerRPM          % MaxSpd        (rpm)
 0.001                  % AxialPlay     (mm)
 0.001                  % RadPlay       (mm)
 1                      % MaxAxLd       (N)
 1                      % MaxF          (N)
 1                      % MaxRadLd      (N)
...
...                     % Other Specifications
 1                      % NoPolePair    (pure)
 1                      % NoCommSeg     (pure)
 0.001                  % Weight        (g)
...
...                     % Physical Dimensions
 0.001                  % OuterDiam     (mm)
 0.001];                % Length        (mm)

% Convert units to standard units
Q0 = ConversionArray .* Q0; 
Q1 = ConversionArray .* Q1;

% Convert temperatures to Kelvin
Q0(21) = Q0(21)+273; 
Q1(21) = Q1(21)+273;
Q0(22) = Q0(22)+273;
Q1(22) = Q1(22)+273;


% ==========================
% Motor Parameters
% ==========================

% Maximum Current
NomI0   = 1;                 % Max average current
StallI0 = 1;                 % Max peak current
NomI1   = 1;                 % Max average current
StallI1 = 1;                 % Max peak current

% =============================
% Q0 : Rotation about y-axis
% =============================

% Amplifier Dynamics
% ------------------

% Electrical Motor Dynamics
% -------------------------

% Torque Const & Back EMF
TConst0  = Q0(12);

% Mechanical Motor Dynamics
% -------------------------

% Sensor Dynamics
% ---------------

% Static Friction
% ---------------


% =============================
% Q1 : Rotation about x-axis
% =============================

% Amplifier Dynamics
% ------------------

% Electrical Motor Dynamics
% -------------------------

% Torque Const & Back EMF
TConst1  = Q1(12);

% Mechanical Motor Dynamics
% -------------------------

% Sensor Dynamics
% ---------------

% Static Friction
% ---------------


% ==================
% TRANSFER FUNCTIONS
% ==================
% Compute transfer functions from above values and perform system analysis
% You may prefer to put this section in a separate .m file
