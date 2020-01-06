%%%% 8.3 Implantation du modulateur %%%%

Fe = 1000;  % Fréquence d'échantillonage
f0 = 200;   % Fréquence du cosinus porteur
A  = 1;     % Amplitude du cosinus porteur
Nb = 30;    % Nombre d'éléments binaires à générer
Ns = 20;    % Nombre d'échantillons par niveau
Te = 1/Fe;  % Période d'échantillonage
Ts = Ns*Te; % Durée d'un niveau

% 1.
%   (a)

%       Génération de l'information binaire à transmettre
bits = randi([0,1],1,Nb);

%   (b)

%       Création du message à transmettre contenant l'information binaire
m = kron(2*bits-1, ones(1,Ns));

%   (c)

%       Echelle temporelle du message
t = linspace(0,Nb*Ts,Nb*Ns);

% Figure 1 %
figure(1);
plot(t,m)
title('Message à transmettre')
xlabel('temps (s)')
ylabel('amplitude')
ylim([-1.5,1.5])

%   (d)

%       Calcul du module de la TFD du message
M = fftshift(fft(m));
Mabs = abs(M);

%       Echelle fréquentielle de la TFD
f = linspace(-Fe/2,Fe/2,Ns*Nb);

% Figure 2 %
figure(2);
semilogy(f,Mabs);
title('TFD du message')
xlabel('fréquence (Hz)')
ylabel('amplitude');

% 2.


%   (a)

%       Echelle temporelle du cosinus porteur
t = linspace(0,(Ns*Nb-1)/Fe,Ns*Nb);

%       Modulation d'amplitude du message par le cosinus porteur
%       permettant la transposition de fréquence en f0
mod = A*cos(2*pi*f0*t);
x = m.*mod;

%   (b)

%       Calcul du module de la TFD du message modulé
X = fftshift(fft(x));
Xabs = abs(X);

% Figure 3 %
figure(3);
semilogy(f,Xabs);
title('TFD du message modulé une fois')
xlabel('fréquence (Hz)')
ylabel('amplitude')

%%%% 8.4 Implantation du retour à basse fréquence %%%%

% 1.

%       Seconde modulation d'amplitude par le même cosinus que précédemment
%       permettant le retour à basse fréquence
y = x.*mod;

% 2.

%       Calcul du module de la TFD du message modulé deux fois
Y = fftshift(fft(y));
Yabs = abs(Y);

% Figure 4 %
figure(4);
semilogy(f,Yabs);
title('TFD du message modulé deux fois')
xlabel('fréquence (Hz)')
ylabel('amplitude')

% 3.

N = 100; % Nombre entier arbitraire

%   (a)

%       Echelle temporelle du morceau de réponse impulsionnelle idéale
%       du filtre passe-bas
t = linspace(-N*Te, N*Te, 2*N+1);

%       Calcul d'un morceau de la réponse impulsionelle idéale du filtre
%       passe-bas
h = sinc(f0*t);

% Figure 5 %
figure(5);
plot(t,h);
title('Réponse impulsionnelle du filtre passe-bas idéal')
xlabel('temps (s)')
ylabel('amplitude')
lg = legend('N = 100 (arbitraire)', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

%   (b)

%       Calcul du module de la réponse en fréquence correspondant à la 
%       réponse impulsionnelle calculée précédemment
H = fftshift(fft(h));
Habs = abs(H);

%       Echelle fréquentielle de la réponse en fréquence
f = linspace(-Fe,Fe,2*N+1);

% Figure 6 %
figure(6);
semilogy(f,Habs);
title('Réponse en fréquence du filtre passe-bas idéal')
xlabel('fréquence (Hz)')
ylabel('amplitude')
lg = legend('N = 100 (arbitraire)', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

%   (c)

%       Calcul des réponses impulsionnelle et en fréquence (en module) du 
%       filtre d'ordre 21 (avec échelles temporelle et fréquentielle
%       correspondante)
N1 = 21;
t1 = linspace(-N1*Te, N1*Te, 2*N1+1);
h1 = sinc(f0*t1);
H1 = fftshift(fft(h1));
Habs1 = abs(H1);
f1 = linspace(-Fe,Fe,2*N1+1);

%       Calcul des réponses impulsionnelle et en fréquence (en module) du 
%       filtre d'ordre 61 (avec échelles temporelle et fréquentielle
%       correspondante)
N2 = 61;
t2 = linspace(-N2*Te, N2*Te, 2*N2+1);
h2 = sinc(f0*t2);
H2 = fftshift(fft(h2));
Habs2 = abs(H2);
f2 = linspace(-Fe,Fe,2*N2+1);

% Figure 7 %
figure(7);
plot(t2,h2,t1,h1);
title('Réponse impulsionnelle du filtre passe-bas idéal')
xlabel('temps (s)')
ylabel('amplitude')
lg = legend('N = 21', ...
	'N = 61', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

% Figure 8 %
figure(8);
semilogy(f1,Habs1,f2,Habs2);
title('Réponse en fréquence du filtre passe-bas idéal')
xlabel('fréquence (Hz)')
ylabel('amplitude')
lg = legend('N = 21', ...
	'N = 61', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

%   (d)

%       Calcul des réponses impulsionnelle et fréquentielle du filtre
%       passe-bas d'ordre 61 avec fenêtre de blackman
w = blackman(2*N2+1)';
hf = h2.*w;
Hf = fftshift(fft(hf));
Hfabs = abs(Hf);

% Figure 9 %
figure(9);
plot(t2,h2,t2,hf);
title('Réponse impulsionnelle du filtre passe-bas idéal fenêtré, N = 61')
xlabel('temps (s)')
ylabel('amplitude')
lg = legend('Fenetre rectangulaire', ...
	'Fenetre de Blackman', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

% Figure 10 %
figure(10);
semilogy(f2,Habs2,f2,Hfabs);
title('Réponse en fréquence du filtre passe-bas idéal fenêtré')
xlabel('fréquence (Hz)')
ylabel('amplitude')
lg = legend('Fenetre rectangulaire', ...
	'Fenetre de Blackman', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

%   (e)

%       Echelle fréquentielle de la TFD du message modulé deux fois
f = linspace(-Fe/2,Fe/2,Ns*Nb);

% Figure 11 %
figure(11);
semilogy(f,Yabs,f2,Hfabs);
title('Spectre du signal à filtrer et filtre')
xlabel('fréquence (Hz)')
ylabel('amplitude')
lg = legend('Spectre du signal a filtrer', ...
	'Reponse en frequence du filtre', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

%   (f)

%        Application du filtre sur le message modulé deux fois
mf = conv(y,hf,'same');

%       Echelle temporelle du message
t = linspace(0,Nb*Ts,Nb*Ns);

% Figure 12 %
figure(12);
plot(t,m,t,mf);
title('Message transmis et signal en sortie de filtre')
xlabel('temps (s)')
ylabel('amplitude')
lg = legend('Message transmis', ...
	'Signal en sortie de filtre', ...
	'Location','Best');
set(lg,'Interpreter','Latex');


