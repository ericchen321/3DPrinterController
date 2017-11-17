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
SpringConst = SpringK * 0.001 * 1/(2*pi);
Router = LinkR2 * 0.001;    % outer radius of the ring
Rinner = LinkR1 * 0.001;    % inner radius of the ring
D = LinkD * 0.001;          % depth of the ring
Mq = Q1(31);                % mass of q1
Rq = Q1(32)/2;                % outer radius of q1
Hq = Q1(33);                % height of q1
pAl = RhoAl;                % density of Al

% Convert temperatures to Kelvin
Q0(21) = Q0(21)+273; 
Q1(21) = Q1(21)+273;
Q0(22) = Q0(22)+273;
Q1(22) = Q1(22)+273;


% ==========================
% Motor Parameters
% ==========================

% Maximum Current
NomI0   = Q0(6);                 % Max average current
StallI0 = Q0(8);                 % Max peak current
NomI1   = Q1(6);                 % Max average current
StallI1 = Q1(8);                 % Max peak current

% =============================
% Q0 : Rotation about y-axis
% =============================

% Amplifier Dynamics
% The transfer function: (R1*R2-L/C)/(R1*R2+s*R1*L)
Ampn0 = ((R1*10^6)*R2)-(L*10^(-3)/(C*10^-6));
Ampd0 = ((R1*10^6)*R2);
Ampd1 = ((R1*10^-6)*(L*10^-3));
Amp0d = [Ampd1 Ampd0];
Amp0n = [Ampn0];
AmpSat0 =  Q0(1);
% Electrical Motor Dynamics
Elec0n  = [1];               % Numerator
Elec0d  = [Q0(11) Q0(10)];          % Denominator
% This transfer function relates rotor current to (input voltage - emf),
% and in DC is the conductance of the terminal resistor

% Torque Const & Back EMF
TConst0  = Q0(12);
BackEMF0 = 1/(Q0(13));

% Mechanical Motor Dynamics
% Determining J:
Maux = (Rinner/Hq)*Mq*2;
SigH = Rinner + Hq;
SigM = ((Rinner/Hq)*2 + 2)*Mq;
Jbar = SigM * (1/12) * (3*Rq^2 + (2*SigH)^2);
Jaux = Maux * (1/12) * (3*Rq^2 + (2*Rinner)^2);
JQ1AndCB = Jbar - Jaux;
Jring = pi*pAl*D*(1/12)*(3*(Router^4 - Rinner^4)+ D^2*(Router^2 - Rinner^2));
Jq0 = Q0(16);
SigJ = JQ1AndCB + Jring + Jq0;

% Determining B:
INoLoad = Q0(3);
WNoLoad = Q0(2);
B = TConst0*INoLoad/WNoLoad;        % Compute B from the no load parameters

% Determining K:
K = SpringConst;

% Mech Transfer Function:
K = 0;
SigJ =8*10^(-5);

Mech0n  = [1 0];               % Numerator
Mech0d  = [SigJ B K];        % Denominator
JntSat0 =  Big;

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
Elec1n  = [1];               % Numerator
Elec1d  = [Q1(10)];          % Denominator

% Torque Const & Back EMF
TConst1  = Q1(12);
BackEMF1 = 1/(Q1(13));

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
