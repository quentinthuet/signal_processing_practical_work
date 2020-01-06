%%%% 8.3 Implantation du modulateur %%%%

Fe = 1000;  % Fr�quence d'�chantillonage
f0 = 200;   % Fr�quence du cosinus porteur
A  = 1;     % Amplitude du cosinus porteur
Nb = 30;    % Nombre d'�l�ments binaires � g�n�rer
Ns = 20;    % Nombre d'�chantillons par niveau
Te = 1/Fe;  % P�riode d'�chantillonage
Ts = Ns*Te; % Dur�e d'un niveau

% 1.
%   (a)

%       G�n�ration de l'information binaire � transmettre
bits = randi([0,1],1,Nb);

%   (b)

%       Cr�ation du message � transmettre contenant l'information binaire
m = kron(2*bits-1, ones(1,Ns));

%   (c)

%       Echelle temporelle du message
t = linspace(0,Nb*Ts,Nb*Ns);

% Figure 1 %
figure(1);
plot(t,m)
title('Message � transmettre')
xlabel('temps (s)')
ylabel('amplitude')
ylim([-1.5,1.5])

%   (d)

%       Calcul du module de la TFD du message
M = fftshift(fft(m));
Mabs = abs(M);

%       Echelle fr�quentielle de la TFD
f = linspace(-Fe/2,Fe/2,Ns*Nb);

% Figure 2 %
figure(2);
semilogy(f,Mabs);
title('TFD du message')
xlabel('fr�quence (Hz)')
ylabel('amplitude');

% 2.


%   (a)

%       Echelle temporelle du cosinus porteur
t = linspace(0,(Ns*Nb-1)/Fe,Ns*Nb);

%       Modulation d'amplitude du message par le cosinus porteur
%       permettant la transposition de fr�quence en f0
mod = A*cos(2*pi*f0*t);
x = m.*mod;

%   (b)

%       Calcul du module de la TFD du message modul�
X = fftshift(fft(x));
Xabs = abs(X);

% Figure 3 %
figure(3);
semilogy(f,Xabs);
title('TFD du message modul� une fois')
xlabel('fr�quence (Hz)')
ylabel('amplitude')

%%%% 8.4 Implantation du retour � basse fr�quence %%%%

% 1.

%       Seconde modulation d'amplitude par le m�me cosinus que pr�c�demment
%       permettant le retour � basse fr�quence
y = x.*mod;

% 2.

%       Calcul du module de la TFD du message modul� deux fois
Y = fftshift(fft(y));
Yabs = abs(Y);

% Figure 4 %
figure(4);
semilogy(f,Yabs);
title('TFD du message modul� deux fois')
xlabel('fr�quence (Hz)')
ylabel('amplitude')

% 3.

N = 100; % Nombre entier arbitraire

%   (a)

%       Echelle temporelle du morceau de r�ponse impulsionnelle id�ale
%       du filtre passe-bas
t = linspace(-N*Te, N*Te, 2*N+1);

%       Calcul d'un morceau de la r�ponse impulsionelle id�ale du filtre
%       passe-bas
h = sinc(f0*t);

% Figure 5 %
figure(5);
plot(t,h);
title('R�ponse impulsionnelle du filtre passe-bas id�al')
xlabel('temps (s)')
ylabel('amplitude')
lg = legend('N = 100 (arbitraire)', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

%   (b)

%       Calcul du module de la r�ponse en fr�quence correspondant � la 
%       r�ponse impulsionnelle calcul�e pr�c�demment
H = fftshift(fft(h));
Habs = abs(H);

%       Echelle fr�quentielle de la r�ponse en fr�quence
f = linspace(-Fe,Fe,2*N+1);

% Figure 6 %
figure(6);
semilogy(f,Habs);
title('R�ponse en fr�quence du filtre passe-bas id�al')
xlabel('fr�quence (Hz)')
ylabel('amplitude')
lg = legend('N = 100 (arbitraire)', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

%   (c)

%       Calcul des r�ponses impulsionnelle et en fr�quence (en module) du 
%       filtre d'ordre 21 (avec �chelles temporelle et fr�quentielle
%       correspondante)
N1 = 21;
t1 = linspace(-N1*Te, N1*Te, 2*N1+1);
h1 = sinc(f0*t1);
H1 = fftshift(fft(h1));
Habs1 = abs(H1);
f1 = linspace(-Fe,Fe,2*N1+1);

%       Calcul des r�ponses impulsionnelle et en fr�quence (en module) du 
%       filtre d'ordre 61 (avec �chelles temporelle et fr�quentielle
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
title('R�ponse impulsionnelle du filtre passe-bas id�al')
xlabel('temps (s)')
ylabel('amplitude')
lg = legend('N = 21', ...
	'N = 61', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

% Figure 8 %
figure(8);
semilogy(f1,Habs1,f2,Habs2);
title('R�ponse en fr�quence du filtre passe-bas id�al')
xlabel('fr�quence (Hz)')
ylabel('amplitude')
lg = legend('N = 21', ...
	'N = 61', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

%   (d)

%       Calcul des r�ponses impulsionnelle et fr�quentielle du filtre
%       passe-bas d'ordre 61 avec fen�tre de blackman
w = blackman(2*N2+1)';
hf = h2.*w;
Hf = fftshift(fft(hf));
Hfabs = abs(Hf);

% Figure 9 %
figure(9);
plot(t2,h2,t2,hf);
title('R�ponse impulsionnelle du filtre passe-bas id�al fen�tr�, N = 61')
xlabel('temps (s)')
ylabel('amplitude')
lg = legend('Fenetre rectangulaire', ...
	'Fenetre de Blackman', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

% Figure 10 %
figure(10);
semilogy(f2,Habs2,f2,Hfabs);
title('R�ponse en fr�quence du filtre passe-bas id�al fen�tr�')
xlabel('fr�quence (Hz)')
ylabel('amplitude')
lg = legend('Fenetre rectangulaire', ...
	'Fenetre de Blackman', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

%   (e)

%       Echelle fr�quentielle de la TFD du message modul� deux fois
f = linspace(-Fe/2,Fe/2,Ns*Nb);

% Figure 11 %
figure(11);
semilogy(f,Yabs,f2,Hfabs);
title('Spectre du signal � filtrer et filtre')
xlabel('fr�quence (Hz)')
ylabel('amplitude')
lg = legend('Spectre du signal a filtrer', ...
	'Reponse en frequence du filtre', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

%   (f)

%        Application du filtre sur le message modul� deux fois
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


