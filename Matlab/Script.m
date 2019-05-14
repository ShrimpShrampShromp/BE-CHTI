clear all;
close all;

%variables :

T=1; 
M=32;
Te=T/M;
Fe=1/Te;
Tsim=T-Te;
Fsin=5;
Delta_f=1/T;

%récupération du modèle simulink
SimOut=sim('model');
%transformée de fourier de la sinusoïde
S=(1/M)*fft(Sin_Ech);

%plot temporel
hold on; 
xlabel("Temps (s)");
ylabel("Sin_{Ech}(vert), Sin_{Cont}(Rouge)");
plot(Tps_Cont, Sin_Cont,'r')
plot(Tps_Ech,Sin_Ech,'g*-')
hold off;
grid;
%plot fréquentiel
Fre=0:Delta_f:Delta_f*(M-1);
length(Fre)
length(abs(S))
stem(Fre,abs(S),'r+-')
xlabel("Freq (Hz)");
ylabel("Amp");
grid;

somme=0;
for n=0:31
    somme = somme + abs(sin(11*pi*n)*exp(-i*2*n*pi/n));
end
somme=somme/31
    
    