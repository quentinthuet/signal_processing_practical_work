%%%%8.3%%%%

Nb = 30;
Fe = 1000;
f0 = 200;
Ns = 20;
Te = 1/Fe;
Ts = Ns*Te;

%1.
%(a)

bits = randi([0,1],1,Nb);

%(b)

m = kron(2*bits-1, ones(1,Ns));

%(c)

x = linspace(0,Nb*Ts,Nb*Ns);

%Figure 1
figure(1);
plot(x,m)
title('Message à transmettre')
xlabel('temps (s)')
ylabel('amplitude')
ylim([-1.5,1.5])

%(d)

t = linspace(0,(Ns*Nb-1)/Fe,Ns*Nb);

M = fftshift(fft(m));

Mabs = abs(M);

f = linspace(-Fe/2,Fe/2,Ns*Nb);

%Figure 2
figure(2);
semilogy(f,Mabs);
title('TFD du message')
xlabel('fréquence (Hz)')
ylabel('amplitude');

%2.

A = 1;

%(a)

mod = A*cos(2*pi*f0*t);
x = m.*mod;

%(b)

X = fftshift(fft(x));

Xabs = abs(X);

%Figure 3
figure(3);
semilogy(f,Xabs);
title('TFD du message modulé une fois')
xlabel('fréquence (Hz)')
ylabel('amplitude')
semilogy(f,Xabs);

%%%%8.4%%%%

%1.

y = x.*mod;

%2.

Y = fftshift(fft(y));

Yabs = abs(Y);

%Figure 4
figure(4);
semilogy(f,Yabs);
title('TFD du message modulé deux fois')
xlabel('fréquence (Hz)')
ylabel('amplitude')

%3.

N = 100;

%(a)

k = linspace(-N*Te, N*Te, 2*N+1);
h = sinc(f0*k);

%Figure 5
figure(5);
plot(k,h);
title('Réponse impulsionnelle du filtre passe-bas idéal')
xlabel('temps (s)')
ylabel('amplitude')
lg = legend('N = 100 (arbitraire)', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

%(b)

H = fftshift(fft(h));

Habs = abs(H);

f = linspace(-Fe,Fe,2*N+1);

%Figure 6
figure(6);
semilogy(f,Habs);
title('Réponse en fréquence du filtre passe-bas idéal')
xlabel('fréquence (Hz)')
ylabel('amplitude')
lg = legend('N = 100 (arbitraire)', ...
	'Location','Best');
set(lg,'Interpreter','Latex');

%(c)

N21 = 21;
k21 = linspace(-N21*Te, N21*Te, 2*N21+1);
h21 = sinc(f0*k21);
H21 = fftshift(fft(h21));
Habs21 = abs(H21);
f21 = linspace(-Fe,Fe,2*N21+1);

N61 = 61;
k61 = linspace(-N61*Te, N61*Te, 2*N61+1);
h61 = sinc(f0*k61);
H61 = fftshift(fft(h61));
Habs61 = abs(H61);
f61 = linspace(-Fe,Fe,2*N61+1);

%Figure 7
figure(7);
hold on;
plot(k21,h21);
plot(k61,h61);
title('Réponse impulsionnelle du filtre passe-bas idéal')
xlabel('temps (s)')
ylabel('amplitude')
lg = legend('N = 21', ...
	'N = 61', ...
	'Location','Best');
set(lg,'Interpreter','Latex');
hold off;

%Figure 8
figure(8);
hold on;
semilogy(f21,Habs21);
semilogy(f61,Habs61);
title('Réponse en fréquence du filtre passe-bas idéal')
xlabel('fréquence (Hz)')
ylabel('amplitude')
lg = legend('N = 21', ...
	'N = 61', ...
	'Location','Best');
set(lg,'Interpreter','Latex');
hold off;

%(d)













