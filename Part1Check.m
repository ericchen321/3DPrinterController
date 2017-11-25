% Amplifier Transfer Functions
RefAmpXF0 = tf(Amp0n,Amp0d);
RefAmpXF1 = tf(Amp1n, Amp1d);

% Electrical Transfer Functions
RefElecXF0 = tf(Elec0n, Elec0d);
RefElecXF1 = tf(Elec1n, Elec1d);

% Mechanical Transfer Functions
RefMechXF0 = tf(Mech0n, Mech0d);
RefMechXF1 = tf(Mech1n, Mech1d);

%Compare Amplifier Xfer Fctns
step(AmpXF0);
hold on;
step(RefAmpXF0);
title('Q0 Amplifier XFs');
legend();
figure;

step(AmpXF1);
hold on;
step(RefAmpXF1);
title('Q1 Amplifier XFs');
legend();
figure;

%Compare Elec Xfer Fctns
step(ElecXF0);
hold on;
step(RefElecXF0);
title('Q0 Elec XFs');
legend();
figure;

step(ElecXF1);
hold on;
step(ElecXF1);
title('Q1 Elec XFs');
legend();
figure;

%Compare Mech Xfer Fctns
step(MechXF0);
hold on;
step(RefMechXF0);
title('Q0 Mech XFs');
legend();
figure;

step(MechXF1);
hold on;
step(RefMechXF1);
title('Q1 Mech XFs');
legend();