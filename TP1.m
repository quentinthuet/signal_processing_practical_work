%%%%5.2%%%%

%1.
f0 = 1100;
Fe = 10000;
N = 90;
A = 1;

t = linspace(0,(N-1)/Fe,N);
x = A*cos(2*pi*f0*t);

%2.
%Figure 1
figure(1);
plot(t,x);
title('Cos de fréq 1100Hz et d''ampl 1 V échantil 90 fois à la fréq 10000Hz')
xlabel('temps (s)')
ylabel('amplitude (V)')

%3.
Fe = 1000;

t = linspace(0,(N-1)/Fe,N);
x = A*cos(2*pi*f0*t);

%4.
%Figure 2
figure(2);
plot(t,x);
title('Cos de fréq 1100Hz et d''ampl 1 V échant 90 fois à la fréq 1000Hz')
xlabel('temps (s)')
ylabel('amplitude (V)')


%%%%5.3%%%%

%2.
%(a)
Fe = 10000;

t = linspace(0,(N-1)/Fe,N);
x = A*cos(2*pi*f0*t);

X = fftshift(fft(x));

Xabs = abs(X);

f = linspace(-Fe/2,Fe/2,N);

%Figure 3
figure(3);
semilogy(f,Xabs);
title('TFD du cos de la Figure 1')
xlabel('fréquence (Hz)')
ylabel('amplitude (V)')

%(b)
Fe = 1000;

t = linspace(0,(N-1)/Fe,N);
x = A*cos(2*pi*f0*t);

X = fftshift(fft(x));

Xabs = abs(X);

f = linspace(-Fe/2,Fe/2,N);

%Figure 4
figure(4);
semilogy(f,Xabs);
title('TFD du cos de la Figure 2')
xlabel('fréquence (Hz)')
ylabel('amplitude (V)')

%4.

Fe = 10000;

t = linspace(0,(N-1)/Fe,N);
x = A*cos(2*pi*f0*t);

M  = 10;
Np = 2^nextpow2(M*N);

y = zeros(1,Np);
y(1,1:length(x)) = x;
Y = fftshift(fft(y,Np));

Yabs = abs(Y);

f = linspace(-Fe/2,Fe/2,Np);

%Figure 5
figure(5);
plot(f,Yabs);
title('TFD du cos de la figure 1 après Zero Padding')
xlabel('fréquence (Hz)')
ylabel('amplitude (V)')
lg = legend('$N_{p} = 1024$', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

%5.

M1 = 1;
M2 = 2;
M3 = 10;

Np1 = 2^nextpow2(M1*N);
Np2 = 2^nextpow2(M2*N);
Np3 = 2^nextpow2(M3*N);

y1 = zeros(1,M1*N);
y2 = zeros(1,M2*N);
y3 = zeros(1,M3*N);

y1(1,1:length(x)) = x;
y2(1,1:length(x)) = x;
y3(1,1:length(x)) = x;

Y1 = fftshift(fft(y,Np1));
Y2 = fftshift(fft(y,Np2));
Y3 = fftshift(fft(y,Np3));

Yabs1 = abs(Y1);
Yabs2 = abs(Y2);
Yabs3 = abs(Y3);

f1 = linspace(-Fe/2,Fe/2,Np1);
f2 = linspace(-Fe/2,Fe/2,Np2);
f3 = linspace(-Fe/2,Fe/2,Np3);

%Figure 6
figure(6);
semilogy(f1,Yabs1,f2,Yabs2,f3,Yabs3);
title('TFD du cos de la figure 1 après Zero Padding')
xlabel('fréquence (Hz)')
ylabel('amplitude (V)')
lg = legend('$N_{p} = 128$', ...
	'$N_{p} = 256$', ...
	'$N_{p} = 1024$', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

t = linspace(0,(N-1)/Fe,N);
x = ifft(Y3);

%%%%5.4%%%

%1.

k = linspace(0,(N-1),N);
x = A*cos(2*pi*f0*k/Fe+rand*2*pi);

%2.

S_x = 1/N*abs(fft(x)).^2;
f = linspace(0,Fe,N);

%Figure 7
figure(7);
plot(f,S_x);
title('Estimation par périodogramme de la DSP du cos numérique aléatoire généré')
xlabel('fréquence (Hz)')
ylabel('amplitude (V)')

%3.

S_x_hamming = 1/N*abs(fft(x.*hamming(length(x))')).^2;
S_x_blackman = 1/N*abs(fft(x.*blackman(length(x))')).^2;

%Figure 8
figure(8);
plot(f,S_x_hamming,f,S_x_blackman);
title('Estimation par périodogramme fenêtré')
xlabel('fréquence (Hz)')
ylabel('amplitude (V)')
lg = legend('Fenetre de Hamming', ...
	'Fenetre de Blackman', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

%4.

S_x_welch = pwelch(x,'','','','twosided')';

f_welch = linspace(0,Fe,length(S_x_welch));

%Figure 9
figure(9);
plot(f_welch,S_x_welch);
title('Estimation par périodogramme de Welch')
xlabel('fréquence (Hz)')
ylabel('amplitude (V)')

%5.

%Figure 10
figure(10);
plot(f,S_x,f,S_x_hamming,f,S_x_blackman,f_welch,S_x_welch);
title('Estimation par périodogramme')
xlabel('fréquence (Hz)')
ylabel('amplitude (V)')
lg = legend('Classique', ...
	'Hamming', ...
	'Blackman', ...
	'Welch', ...
	'Location','Best');
set(lg,'Interpreter','Latex');





