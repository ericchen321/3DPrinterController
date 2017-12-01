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
figure;
step(OurAmpXF0);
hold on;
step(RefAmpXF0);
title('Q0 Amplifier XFs');
legend();

figure;
step(OurAmpXF1);
hold on;
step(RefAmpXF1);
title('Q1 Amplifier XFs');
legend();

%Compare Elec Xfer Fctns
figure;
step(OurElecXF0);
hold on;
step(RefElecXF0);
title('Q0 Elec XFs');
legend();

figure;
step(OurElecXF1);
hold on;
step(RefElecXF1);
title('Q1 Elec XFs');
legend();

%Compare Mech Xfer Fctns
figure;
step(OurMechXF0);
hold on;
step(RefMechXF0);
title('Q0 Mech XFs');
legend();

figure;
step(OurMechXF1);
hold on;
step(RefMechXF1);
title('Q1 Mech XFs');
legend();