function delayVal=DelaytoWavelength30mCorning(t1,t2)


% Coefficients (with 95% confidence bounds):
p1 =      -1.725; % (-2.124, -1.325)
p2 =       45.82;  %(37.64, 54)
p3 =      -447.2;  %(-501.4, -393.1)
p4 =        2306;  %(2190, 2422)


x=t1;

Wavelength1 = (p1*x.^3 + p2*x.^2 + p3.*x + p4)/2;

x=t2;
Wavelength2 = (p1*x.^3 + p2*x.^2 + p3.*x + p4)/2;

delayVal=Wavelength1-Wavelength2;