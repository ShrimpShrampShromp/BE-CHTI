clear all;
close all;

%variables :

T=1/5000; 
M=64;
Te=T/M;
Fe=1/Te;
Tsim=T-Te;
f1=85000;
f2=90000;
f3=94986.6;
f4=100000;
f5=115015.9;
f6=120000;
Delta_f=1/T;

%récupération du modèle simulink
SimOut=sim('sixpistolets');
%transformée de fourier de la sinusoïde

%simulation d'un signal tronqué au début
% for n=1:M/2
%     Sin_Ech(n)=0;
% end

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
%stem(Fre,abs(S),'r+-')
%semilogy(Fre,abs(S),'r+')
xlabel("Freq (Hz)");
ylabel("Amp");
grid;

fp = tf(1, [1.7486e-23 7.6663e-18 1.162e-11 3.0332e-6 1]);


%bode(fp,{1e4,1e7})
somme=0;
for n=0:31
    somme = somme + abs(sin(11*pi*n)*exp(-i*2*n*pi/n));
end
somme=somme/31
    
    