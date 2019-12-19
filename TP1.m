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








