%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%            Projet Traitement du signal S5           %%%%%%%%%%%
%%%%%%%%%%%       Ababacar Camara, Quentin Thuet, Groupe F      %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%       Chargement des donnees a transmettre
load donnees1.mat 
load donnees2.mat

%       Variables globales
[~,Nb] = size(bits_utilisateur1); % Taille du message
Fe     = 128000;                  % Frequence d'echantillonnage
Te     = 1/Fe;                    % Periode d'echantillonnage
fp1    = 0;                       % Frequence de la porteuse 1
fp2    = 46000;                   % Frequence de la porteuse 2
T      = 0.04;                    % Duree d'un timeslot
Ns     = T/Nb/Te;                 % Nombre d'echantillons pour un bit
Ts     = Ns*Te;                   % Duree d'un bit

%%%% 9.3.2 Implantation du signal MF-TDMA %%%%
%%% Modulation bande base %%%

% 2.

%       Generation des signaux NRZ
m1 = kron(2*bits_utilisateur1-1, ones(1,Ns));
m2 = kron(2*bits_utilisateur2-1, ones(1,Ns));

%       Affichage des signaux NRZ
t = linspace(0,Nb*Ts,Nb*Ns);

% Figure 1 %
figure(1)
plot(t,m1,t,m2);
title('Signaux NRZ a transmettre')
xlabel('temps (s)')
ylabel('amplitude')
ylim([-1.5,1.5])
lg = legend('$m_{1}$', ...
	'$m_{2}$', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

% 3. 

%       Calcul des modules des TFD des signaux
Mabs1 = abs(fft(m1));
Mabs2 = abs(fft(m2));

%       Calcul des DSP
DSP1 = 1/Nb/Ns * Mabs1.^2;
DSP2 = 1/Nb/Ns * Mabs2.^2;

f1 = linspace(0,Fe,Ns*Nb);

% Figure 2 %
figure(2)
plot(f1,DSP1,f1,DSP2);
title('DSP des signaux NRZ')
xlabel('frequence (Hz)')
ylabel('amplitude')
lg = legend('DSP de $m_{1}$', ...
	'DSP de $m_{2}$', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

%%% Construction du signal MF-TDMA %%%

% 1.
%   (a)

%       Generation des signaux a 5 slots
s1 = zeros(1,5*Ns*Nb);
s1(1*Ns*Nb+1:2*Ns*Nb) = m1;
s2 = zeros(1,5*Ns*Nb);
s2(4*Ns*Nb+1:5*Ns*Nb) = m2;

%       Affichage des signaux a 5 slots
t1 = linspace(0,5*Nb*Ts,5*Nb*Ns);

% Figure 3 %
figure(3)
plot(t1,s1,t1,s2);
title('Signaux a 5 slots à transmettre')
xlabel('temps (s)')
ylabel('amplitude')
ylim([-1.5,1.5])
lg = legend('Signal contenant $m_{1}$', ...
	'Signal contenant $m_{2}$', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

%   (b)

%       Modulation d'amplitude des signaux NRZ
t2 = linspace(0,5*T,5*Ns*Nb);

mod1 = cos(2*pi*fp1*t2);
mod2 = cos(2*pi*fp2*t2);

x1 = s1.*mod1;
x2 = s2.*mod2;

% 2.

x = x1 + x2;
puissance = mean(x.^2);
p_n = puissance * exp(-10);
variance = abs(p_n - mean(x)^2);
sb = x + sqrt(variance) * randn(1,5*Nb*Ns);

% Figure 4 %
figure(4);
plot(t2,sb);
title('TODO')
xlabel('temps (s)')
ylabel('amplitude')

% 3.

Sb = fftshift(fft(sb));
Sb_abs = abs(Sb);

f2 = linspace(-Fe/2,Fe/2,Nb*Ns*5);

% Figure 5 %
figure(5);
plot(f2,Sb_abs);
title('TODO')
xlabel('temps (s)')
ylabel('amplitude')

%%%% 9.4.1 Demultiplexage des porteuses %%%%fc1 = abs(fp2 - fp1)/2; % Frequence de coupure du passe-bas demultiplexeur


%%% Synthese du filtre passe-bas %%%

N   = 1500;   % Ordre du filtre passe-bas
fc1 = abs(fp2 - fp1)/2; % Frequence de coupure du passe-bas demultiplexeur

% 1.

%       Calcul et affichage de la reponse impulsionnelle du filtre passe-bas
k = linspace(-N*Te, N*Te, 2*N+1);
h_ipb1 = fc1/Fe*sinc(fc1*k);

% Figure 6 %
figure(6);
plot(k,h_ipb1);
title('Reponse impulsionnelle du filtre passe-bas ideal')
xlabel('temps (s)')
ylabel('amplitude')

%       Calcul et affichage de la reponse frequentielle du filtre passe-bas

H_ipb1 = fftshift(fft(h_ipb1));

H_ipb1_abs = abs(H_ipb1);

f3 = linspace(-Fe,Fe,2*N+1);

% Figure 7 %
figure(7);
semilogy(f3,H_ipb1_abs);
title('Reponse en frequence du filtre passe-bas ideal')
xlabel('frequence (Hz)')
ylabel('amplitude')

% 2.

% Figure 8 %
figure(8);
semilogy(f2,Sb_abs,f3,H_ipb1_abs);
title('TODO')
xlabel('frequence (Hz)')
ylabel('amplitude')

%%% Synthese du filtre passe-haut %%%

% 2.

%       Calcul et affichage de la réponse impulsionnelle du filtre passe-haut
d = zeros(1,2*N+1);
d(N+1) = 1;

h_iph = d - h_ipb1; 

% 3.

% Figure 9 %
figure(9);
plot(k,h_iph);
title('Reponse impulsionnelle du filtre passe-haut ideal')
xlabel('temps (s)')
ylabel('amplitude')

%       Calcul et affichage de la reponse frequentielle du filtre passe-haut

H_iph = fftshift(fft(h_iph));

H_iph_abs = abs(H_iph);

f = linspace(-Fe,Fe,2*N+1);

% Figure 10 %
figure(10);
semilogy(f,H_iph_abs);
title('Reponse en frequence du filtre passe-haut ideal')
xlabel('frequence (Hz)')
ylabel('amplitude')

% 4.

% Figure 11 %
figure(11);
semilogy(f2,Sb_abs,f3,H_iph_abs);
title('TODO')
xlabel('frequence (Hz)')
ylabel('amplitude')

% 4.1.3  Filtrage.

x1_filtre=conv(sb,h_ipb1,'same');
x2_filtre=conv(sb,h_iph,'same');

% Figure 12 %
figure(12)
plot(t2,x1_filtre);
title('Signaux démultiplexés')
xlabel('temps (s)')
ylabel('amplitude')
lg = legend('Signal contenant $m_{1}$', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

% Figure 13 %
figure(13)
plot(t2,x2_filtre);
title('Signaux démultiplexés')
xlabel('temps (s)')
ylabel('amplitude')
lg = legend('Signal contenant $m_{2}$', ...
	'Location','Best');
set(lg,'Interpreter','Latex');



%4.2 Retour en bande de base.
fc2 = fp2/2;
h_ipb2 = 2*fc2/Fe*sinc(2*fc2*k).*blackman(2*N+1)';

fc3 = fp2/2;
h_ipb3 = 2*fc3/Fe*sinc(2*fc3*k).*blackman(2*N+1)';

x1_base=x1_filtre.*cos(2*pi*fp1*t2);
x2_base=x2_filtre.*cos(2*pi*fp2*t2);
x1_base_filtre=conv(x1_base,h_ipb2,'same');
x2_base_filtre=conv(x2_base,h_ipb3,'same');

% Figure 14 %
figure(14)
plot(t2,x1_base_filtre,t2,x2_base_filtre);
 title('TODO')
xlabel('temps (s)')
ylabel('amplitude')
lg = legend('Signal contenant $m_{1}$', ...
	'Signal contenant $m_{2}$', ...
	'Location','Best');
set(lg,'Interpreter','Latex');




%4.3 Détection en bande base.

x1_utile = slot_utile(x1_base_filtre,Ns,Nb);
x2_utile = slot_utile(x2_base_filtre,Ns,Nb);

signal_filtre1 = conv(x1_utile,ones(1,Ns),'same');
signal_echantillonne1 = signal_filtre1(1:Ns:end);
bits_recuperes1 = (sign(signal_echantillonne1)+1)/2;
bin2str(bits_recuperes1)

signal_filtre2 = conv(x2_utile,ones(1,Ns),'same');
signal_echantillonne2 = signal_filtre2(1:Ns:end);
bits_recuperes2 = (sign(signal_echantillonne2)+1)/2;
bin2str(bits_recuperes2)












