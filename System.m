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
AMAX22_6W_SB;                % Motor for Q1
Q0 = MotorParam;
AMAX12_p75W_SB;                % Motor for Q1
Q1 = MotorParam;

% Motor Unit Conversions
ConversionArray = ...
...             
[1                      % NomV          (V)
 RadPSecPerRPM          % NoLoadSpd     (rpm)
 0.001                  % NoLoadCurr    (mA)
 RadPSecPerRPM          % NomSpd        (rpm)
 0.001                  % NomTorque     (mNm)
 1                      % NomCurr       (A)
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
Router = LinkR2 * 0.001;            % outer radius of the ring
Rinner = LinkR1 * 0.001;            % inner radius of the ring
LinkOffset = LinkOff * 0.001;       % Link offset
D = LinkD * 0.001;                  % depth of the ring
Mq = Q1(31);                        % mass of q1
Rq = Q1(32)/2;                      % outer radius of q1
Hq = Q1(33);                % height of q1
pAl = RhoAl;                % density of Al
uStatFric = uSF * 10^(-6);  % static friction constant
R1  = R1*10^6;              % R1 from Mohm to Ohm
R2  = R2;                   % R2
C   = C*10^(-6);            % C from uF to F
L   = L*0.001;              % L from mH to H

% Convert temperatures from Celsius to Kelvin
Q0(21) = Q0(21)+273; 
Q1(21) = Q1(21)+273;
Q0(22) = Q0(22)+273;
Q1(22) = Q1(22)+273;


% ==========================
% Motor Parameters
% ==========================

% Maximum Current
% These values are all taken from the Datasheet
NomI0   = Q0(6);                 % Max average current
StallI0 = Q0(8);                 % Max peak current
NomI1   = Q1(6);                 % Max average current
StallI1 = Q1(8);                 % Max peak current

% =============================
% Q0 : Rotation about y-axis
% =============================

% Amplifier Dynamics
% We've used nodal analysis to analyze the Op-amp circuit
s = tf('s');
AmpXF = -1*(1/(R1*C*s)) + 1/(R1*C*s)*((1/(L*s))/(1/(L*s)+1/R2)) + ((1/(L*s))/(1/(L*s)+1/R2));   % The transfer function of the Op-amp, derived by hand
[Amp0n, Amp0d] = tfdata(AmpXF, 'v');    % Convert the transfer function to the standard form
AmpSat0 = Q0(1);    % Set the saturation voltage to be the maximum allowed input voltage to Q0

% Electrical Motor Dynamics
Elec0n  = [1];                      % Numerator
Elec0d  = [Q0(11) Q0(10)];          % Denominator, (sL + R), so the numerators are terminal inductance and terminal resistance of Q0's rotor, respectively

% Torque Const & Back EMF
TConst0  = Q0(12);                  % The torque constant given by the Datasheet
BackEMF0 = 1/(Q0(13));              % The inverse of the speed costant in 
                                    % the Datasheet - we take the inverse 
                                    % because the speed constant is the rate 
                                    % of change ofspeed versus backward emf, 
                                    % while we need the rate of change of
                                    % back emf versus speed
                                    

% Mechanical Motor Dynamics
% Determining J (Moment of Inertia):
% A graphical illustration for our procedure to derive the total moment of inertia on Q0 has
% been illustrated in our slides.
Maux = (LinkOffset/Hq)*Mq*2;        % Here I'm using superposition to compute
                                    % the moment of inertia due to Q1 and
                                    % its counterbalance. Maux is the mass
                                    % of a fictious "motor and its
                                    % counterweight" between the Q0's supporting 
                                    % bar and Q0's face 
SigH = LinkOffset + Hq;
SigM = ((LinkOffset/Hq)*2 + 2)*Mq;                  % Total mass of Q1, Q1's couterweight, and
                                                    % Maux
JBar = SigM * (1/12) * (3*Rq^2 + (2*SigH)^2);       % Total moment of inertia of Q1, Q1's counterweight,
                                                    % and the moment of
                                                    % inertia due to MAux
JAux = Maux * (1/12) * (3*Rq^2 + (2*LinkOffset)^2); 
JQ1AndCB = JBar - JAux;                             % Subtract the moment of inertia due to
                                                    % MAux from the total
                                                    % moment of inertia, we
                                                    % get the moment of
                                                    % inertia due to Q1 and
                                                    % its counterweight
JRing = pi*pAl*D*(1/12)*(3*(Router^4 - Rinner^4)+ D^2*(Router^2 - Rinner^2));       % Moment of inertia due to the rotation of the circular ring
Jq0 = Q0(16);                       % Moment of inertia due to the rotation of Q0 itself
SigJ0 = JQ1AndCB + JRing + Jq0;     % SigJ0 is the total moment of inertia applied on Q0

% Determining B (Damping Constant):
INoLoad0 = Q0(3);
WNoLoad0 = Q0(2);
B0 = 2*TConst0*INoLoad0/WNoLoad0;      % Compute B from the no load parameters.
                                       % No load current multiplied by
                                       % torque constant yields no load
                                       % torque required to overcome friction, 
                                       % divided by no load speed
                                       % gives us the mechanical friction
                                       % parameter.

% Determining K (Spring Constant):
% The spring constant doesn't originate from the motor Q0 itself,
% instead it's due to the spring connected to the bearings
K = SpringConst;                 % Value taken from the Datasheet

% Mech Transfer Function:
% The transfer function in the standard form s/(Js^2 + Bs + K)
Mech0n  = [1 0];                 % Numerator
Mech0d  = [SigJ0 B0 K];          % Denominator
JntSat0 =  Big;                  % Q0 has unlimited motion range, as stated in the Datasheet

% Sensor Dynamics
SensSat0 =  SensV;                          % sensor saturation voltage
Sens0    =  SensSat0/(SensAng*RadPerDeg);    % The sensor delivers max voltage output when the input
                                            % angle reaches max, also
                                            % assume the output voltage is
                                            % 0 when the input angle is 0.
                                            % Also we know the output voltage
                                            % changes linearly with respect
                                            % to the input angle.
% Static Friction
MRing = pAl * pi * (Router^2 - Rinner^2) * D;   % Mass of the ring
FOnQ0 = (1/2)*(2*Mq + MRing)*G;    % Total force applied on q0 when q0 is stationary
StFric0 = uStatFric * FOnQ0;       % Total static frictional torque


% =============================
% Q1 : Rotation about x-axis
% =============================

% WE'VE USED THE SAME PROCEDURE AS WE USED FOR Q0 TO COMPUTE MOST OF THE PARAMETERS
% OF Q1.

% Amplifier Dynamics
% The Power Amplifiers are identical, so same transfer function
Amp1n = Amp0n;
Amp1d = Amp0d;
AmpSat1 = Q1(1);

% Electrical Motor Dynamics
Elec1n  = [1];                      % Numerator
Elec1d  = [Q1(11) Q1(10)];          % Denominator

% Torque Const & Back EMF
TConst1  = Q1(12);
BackEMF1 = 1/(Q1(13));

% Mechanical Motor Dynamics
% Determining J:
Jq1 = Q1(16);
SigJ1 = Jq1;

% Determining B:
INoLoad1 = Q1(3);
WNoLoad1 = Q1(2);
B1 = TConst1*INoLoad1/WNoLoad1;        % Compute B from the no load parameters
                                       % using the same procedures as for
                                       % q0

% Mech Transfer Function:
Mech1n  = [1];                         % Numerator
Mech1d  = [SigJ1 B1];                  % Denominator
JntSat1 =  JntLim * RadPerDeg;         % Q1's limit of motion range, given by the Datasheet

% Sensor Dynamics
SensSat1 =  SensV;                          % sensor saturation voltage
Sens1    =  SensSat1/(SensAng*RadPerDeg);    % identical sensors used for q0 and q1,
                                            % so the sensor gains are the
                                            % same

% Static Friction
StFric1 = 0;                % static friction on q1 is negligible, since only the laser is loaded on q1's rotor

% ==================
% TRANSFER FUNCTIONS
% ==================
% Compute transfer functions from above values and perform system analysis
% You may prefer to put this section in a separate .m file

% Amplifier Transfer Functions
AmpXF0 = tf(Amp0n,Amp0d);
AmpXF1 = tf(Amp1n, Amp1d);

% Electrical Transfer Functions
ElecXF0 = tf(Elec0n, Elec0d);
ElecXF1 = tf(Elec1n, Elec1d);

% Mechanical Transfer Functions
MechXF0 = tf(Mech0n, Mech0d);
MechXF1 = tf(Mech1n, Mech1d);

% Motor Transfer Functions: linearized transfer functions of the motors
ElecMechXF0 = ElecXF0 * TConst0 * MechXF0;
ElecMechXF1 = ElecXF1 * TConst1 * MechXF1;

MotorXF0 = AmpXF0*(ElecMechXF0/(1 + ElecMechXF0 * BackEMF0))*(1/s);
MotorXF1 = AmpXF1*(ElecMechXF1/(1 + ElecMechXF1 * BackEMF1))*(1/s);