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
subplot(211);
plot(t,m1);
title('Signaux NRZ a transmettre')
xlabel('temps (s)')
ylabel('m_1(t)')
ylim([-1.5,1.5])
subplot(212);
plot(t,m2,'r');
xlabel('temps (s)')
ylabel('m_2(t)')
ylim([-1.5,1.5])

% 3. 

%       Calcul des modules des TFD des signaux
M1_abs = abs(fft(m1));
M2_abs = abs(fft(m2));

%       Calcul des DSP
DSP_m1 = 1/Nb/Ns * M1_abs.^2;
DSP_m2 = 1/Nb/Ns * M2_abs.^2;

f1 = linspace(-Fe/2,Fe/2,Ns*Nb);

% Figure 2 %
figure(2)
subplot(211);
plot(f1,fftshift(DSP_m1));
title('DSP des signaux NRZ')
xlabel('frequence (Hz)')
ylabel('DSP_{m_1}(f)')
subplot(212);
plot(f1,fftshift(DSP_m2),'r');
xlabel('frequence (Hz)')
ylabel('DSP_{m_2}(f)')

%%% Construction du signal MF-TDMA %%%

% 1.
%   (a)

%       Generation des signaux a 5 slots
m1_slot = zeros(1,5*Ns*Nb);
m1_slot(1*Ns*Nb+1:2*Ns*Nb) = m1;
m2_slot = zeros(1,5*Ns*Nb);
m2_slot(4*Ns*Nb+1:5*Ns*Nb) = m2;

%       Affichage des signaux a 5 slots
t1 = linspace(0,5*Nb*Ts,5*Nb*Ns);

% Figure 3 %
figure(3)
subplot(211);
plot(t1,m1_slot);
title('Signaux a 5 slots a transmettre')
xlabel('temps (s)')
ylabel('m_1*(t)')
ylim([-1.5,1.5])
subplot(212);
plot(t1,m2_slot,'r');
xlabel('temps (s)')
ylabel('m_2*(t)')
ylim([-1.5,1.5])

%   (b)

%       Modulation d'amplitude des signaux NRZ
t2 = linspace(0,5*T,5*Ns*Nb);

mod1 = cos(2*pi*fp1*t2);
mod2 = cos(2*pi*fp2*t2);

m1_mod = m1_slot.*mod1;
m2_mod = m2_slot.*mod2;

% 2.

RSB = 100; % Rapport signal sur bruit du signal MF-TDMA généré (en dB)

%       Génération du signal MF-TDMA
x_non_bruite = m1_mod + m2_mod;
puissance = mean(x_non_bruite.^2);
p_n = puissance * exp(-RSB/10);
variance = abs(p_n - mean(x_non_bruite)^2);
x = x_non_bruite + sqrt(variance) * randn(1,5*Nb*Ns);

% Figure 4 %
figure(4);
plot(t2,x);
title('Signal MF-TDMA reçu par la station d''interconnexion')
xlabel('temps (s)')
ylabel('x(t)')

% 3.

%       Calcul de la DSP de x
X = fftshift(fft(x));
X_abs = abs(X);
DSP_x = 1/5/Nb/Ns * X_abs.^2;

f2 = linspace(-Fe/2,Fe/2,Nb*Ns*5);

% Figure 5 %
figure(5);
plot(f2,DSP_x);
title('DSP du signal MF-TDMA')
xlabel('fréquence (Hz)')
ylabel('DSP_{x}(f)')

%%%% 9.4.1 Demultiplexage des porteuses %%%%

%%% Synthese du filtre passe-bas %%%

N   = 1500;             % Ordre du filtre passe-bas
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
ylabel('h_{I_{PB}}(t)')

%       Calcul et affichage de la reponse frequentielle du filtre passe-bas
H_ipb1 = fftshift(fft(h_ipb1));
H_ipb1_abs = abs(H_ipb1);

f3 = linspace(-Fe,Fe,2*N+1);

% Figure 7 %
figure(7);
semilogy(f3,H_ipb1_abs);
title('Reponse en frequence du filtre passe-bas ideal')
xlabel('frequence (Hz)')
ylabel({'H_{I_{PB}}(f)';'Echelle logarithmique'})

% 2.

% Figure 8 %
figure(8);
semilogy(f2,DSP_x,f3,H_ipb1_abs);
title('DSP du signal MF-TDMA et reponse en frequence du filtre passe-bas')
xlabel('frequence (Hz)')
ylabel({'amplitude';'Echelle logarithmique'})
lg = legend('$DSP_{x}(f)$', ...
    '$H_{I_{PB}}(f)$', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

%%% Synthese du filtre passe-haut %%%

% 2.

%       Calcul et affichage de la reponse impulsionnelle du filtre passe-haut
d = zeros(1,2*N+1);
d(N+1) = 1;

h_iph = d - h_ipb1; 

% 3.

% Figure 9 %
figure(9);
plot(k,h_iph);
title('Reponse impulsionnelle du filtre passe-haut ideal')
xlabel('temps (s)')
ylabel('h_{I_{PH}}(t)')

%       Calcul et affichage de la reponse frequentielle du filtre passe-haut

H_iph = fftshift(fft(h_iph));
H_iph_abs = abs(H_iph);

% Figure 10 %
figure(10);
semilogy(f3,H_iph_abs);
title('Reponse en frequence du filtre passe-haut ideal')
xlabel('frequence (Hz)')
ylabel('H_{I_{PH}}(f)')

% 4.

% Figure 11 %
figure(11);
semilogy(f2,DSP_x,f3,H_iph_abs);
title('DSP du signal MF-TDMA et reponse en frequence du filtre passe-haut')
xlabel('frequence (Hz)')
ylabel({'amplitude';'Echelle logarithmique'})
lg = legend('$DSP_{x}(f)$', ...
    '$H_{I_{PH}}(f)$', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

%%% Filtrage %%%

%       Demultiplexage
x1_filtre=conv(x,h_ipb1,'same');
x2_filtre=conv(x,h_iph,'same');

% Figure 12 %
figure(12);
subplot(211);
plot(t2,x1_filtre);
title('Signaux demultiplexes')
xlabel('temps (s)')
ylabelprop = ylabel('$\tilde{x_{1}}\left(t\right)$');
set(ylabelprop,'Interpreter','latex');
subplot(212);
plot(t2,x2_filtre,'r');
xlabel('temps (s)')
ylabelprop = ylabel('$\tilde{x_{2}}\left(t\right)$');
set(ylabelprop,'Interpreter','latex');

%%%% 9.4.2 Retour en bande de base %%%%

%       Synthese des filtres permettant le retour en bande de base
fc2 = fp2/2;
h_ipb2 = 2*fc2/Fe*sinc(2*fc2*k).*blackman(2*N+1)';

fc3 = fp2/2;
h_ipb3 = 2*fc3/Fe*sinc(2*fc3*k).*blackman(2*N+1)';

%       Démodulation et application des filtres
x1_base=x1_filtre.*cos(2*pi*fp1*t2);
x2_base=x2_filtre.*cos(2*pi*fp2*t2);
x1_base_filtre=conv(x1_base,h_ipb2,'same');
x2_base_filtre=conv(x2_base,h_ipb3,'same');

%%%% 9.4.3 Detection du slot utile %%%%

x1_utile = slot_utile(x1_base_filtre,Ns,Nb);
x2_utile = slot_utile(x2_base_filtre,Ns,Nb);

%%%% 9.4.4 Demodulation bande de basse %%%%
signal_filtre1 = conv(x1_utile,ones(1,Ns),'same');
signal_echantillonne1 = signal_filtre1(1:Ns:end);
bits_recuperes1 = (sign(signal_echantillonne1)+1)/2;
bin2str(bits_recuperes1)

signal_filtre2 = conv(x2_utile,ones(1,Ns),'same');
signal_echantillonne2 = signal_filtre2(1:Ns:end);
bits_recuperes2 = (sign(signal_echantillonne2)+1)/2;
bin2str(bits_recuperes2)

