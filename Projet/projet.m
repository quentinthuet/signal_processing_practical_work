%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%            Projet Traitement du signal S5           %%%%%%%%%%%
%%%%%%%%%%%       Ababacar Camara, Quentin Thuet, Groupe F      %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Chargement des donnees à transmettre
load donnees1.mat 
load donnees2.mat

% Variables globales
[~,Nb] = size(bits_utilisateur1); % Taille du message
Fe     = 128000;                  % Frequence d'echantillonnage
Te     = 1/Fe;                    % Période d'echantillonnage
fp1    = 0;                       % Frequence de la porteuse 1
fp2    = 46000;                   % Frequence de la porteuse 2
T      = 0.04;                    % Duree d'un timeslot
Ns     = T/Nb/Te;                 % Nombre d'echantillons pour un bit
Ts     = Ns*Te;                   % Duree d'un bit

%%%% 9.3.2 %%%%
%%% Modulation bande base %%%

% 2.

% Generation des signaux NRZ
m1 = kron(2*bits_utilisateur1-1, ones(1,Ns));
m2 = kron(2*bits_utilisateur2-1, ones(1,Ns));

% Affichage des signaux NRZ
t = linspace(0,Nb*Ts,Nb*Ns);

% Figure 1
figure(1)
plot(t,m1,t,m2);
title('Signaux NRZ a transmettre')
xlabel('temps (s)')
ylabel('amplitude')
ylim([-1.5,1.5])
lg = legend('m1', ...
	'm2', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

% 3. 

% Calcul des modules des TFD des signaux
Mabs1 = abs(fft(m1));
Mabs2 = abs(fft(m2));

% Calcul des DSP
DSP1 = 1/Nb/Ns * Mabs1.^2;
DSP2 = 1/Nb/Ns * Mabs2.^2;

f = linspace(0,Fe,Ns*Nb);

% Figure 2
figure(2)
plot(f,DSP1,f,DSP2);
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

% Génération des signaux a 5 slots
s1 = zeros(1,5*Ns*Nb);
s1(1*Ns*Nb+1:2*Ns*Nb) = m1;
s2 = zeros(1,5*Ns*Nb);
s2(4*Ns*Nb+1:5*Ns*Nb) = m2;

% Affichage des signaux a 5 slots
t = linspace(0,5*Nb*Ts,5*Nb*Ns);

% Figure 3
figure(3)
plot(t,s1,t,s2);
title('Signaux a 5 slots à transmettre')
xlabel('temps (s)')
ylabel('amplitude')
ylim([-1.5,1.5])
lg = legend('Signal contenant $m_{1}$', ...
	'Signal contenant $m_{2}$', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

%   (b)

% Modulation d'amplitude des signaux NRZ
t = linspace(0,5*T,5*Ns*Nb);

mod1 = cos(2*pi*fp1*t);
mod2 = cos(2*pi*fp2*t);

x1 = s1.*mod1;
x2 = s2.*mod2;

% 2.



% 3.

% TODO

%%%% 9.4.1 %%%%

%%% Synthese du filtre passe-bas %%%

N   = 100;  % Ordre du filtre passe-bas
fc1 = fp2/2; % Frequence de coupure du passe-bas demultiplexeur

% 1.

% Calcul et affichage de la reponse impulsionnelle du filtre passe-bas
k = linspace(-N*Te, N*Te, 2*N+1);
h_ipb = sinc(fc1*k);

%Figure 5
figure(5);
plot(k,h_ipb);
title('Reponse impulsionnelle du filtre passe-bas ideal')
xlabel('temps (s)')
ylabel('amplitude')

% Calcul et affichage de la reponse frequentielle du filtre passe-bas

H_ipb = fftshift(fft(h_ipb));

H_ipb_abs = abs(H_ipb);

f = linspace(-Fe,Fe,2*N+1);

%Figure 6
figure(6);
semilogy(f,H_ipb_abs);
title('Reponse en frequence du filtre passe-bas ideal')
xlabel('frequence (Hz)')
ylabel('amplitude')

% 2.

% TODO

%%% Synthese du filtre passe-haut %%%

% 2. % A MODIFIER

% Calcul et affichage de la réponse impulsionnelle du filtre passe-haut
d = zeros(1,2*N+1);
d(N+1) = 1;

h_iph = d - h_ipb;

%Figure 7
figure(7);
plot(k,h_iph);
title('Reponse impulsionnelle du filtre passe-haut ideal')
xlabel('temps (s)')
ylabel('amplitude')

% Calcul et affichage de la reponse frequentielle du filtre passe-haut

H_iph = fftshift(fft(h_iph));

H_iph_abs = abs(H_iph);

f = linspace(-Fe,Fe,2*N+1);

%Figure 8
figure(8);
semilogy(f,H_iph_abs);
title('Reponse en frequence du filtre passe-haut ideal')
xlabel('frequence (Hz)')
ylabel('amplitude')



















