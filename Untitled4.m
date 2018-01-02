
t=1:256;
tau=47;%equivalent to 
shift=50;

% urea625 is 400um 30 thorlabs


dec=15000*exp(-(t-shift)/tau);
dec(find(t<shift))=0;
conv_dec62=conv(dec,urea625);
conv_decthor=conv(dec,ureathor);%1m thorlabs

semilogy(conv_dec62)

hold on

len=1:length(conv_decthor);
semilogy(len+137,conv_decthor,'r')

%fwhm 49 for 62 fiber
%fwhm 46 for 1m fiber
%