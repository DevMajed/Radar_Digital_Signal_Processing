clear all
clc

%  L Band Radar Frequency
f= 1*10^9

% Range
R = (10000*rand(5,1)+2000);

% Speed
u = 100 * ( rand(5,1) - 0.5 ); 

%Speed of Light
c=3*10^8;

% Doppler Frequency 
Fd= ((2*u)/c)*f


% Slow Time Bins
M = 1024;

% Fast Time Bins
L = 1000;

% Slow Time PRF 
PRF=1000;

% Slow Time Period
Tm = 1/PRF;



% Fast Time Sampling rate 
Fs=10*10^6;

% Fast time period
tl= 1/Fs;


% Target reflectivity
p = [ 1 0.5 0.25 0.25 0.1 ]';

% Barker code for 13 chips
barker = [1 1 1 1 1 -1 -1 1 1 -1 1 -1 1];

% Probigation Constant
Ko = ( (2*pi)/.30 );


% Filter Coefficients % conjugate
a = [1 -1 1 -1 1 1 -1 -1 1 1 1 1 1 ];


% Unambiguous range for doppler 
Run = c/(2*PRF);

% Time Delay Ranging for Monostatic Radar
to= round ( 2*R/(3*10^8)/tl);


% Signal to clutter ratio
SCR = 100

%clutter modeling
C=  sqrt ( -2* log(1-rand(1,1000)/SCR)) .* exp (2*pi.*rand(1,1000)*j);


for i = 1 : M
    % The Time Dependence
    t=i*Tm;
% Copying Clutter to the Signal
      S=C;
      
 
 % The Echo received for each Target +  Clutter
 for k = 1 : 5
     
Delay = to(k);

S(Delay:Delay+12) = S(Delay:Delay+12)+ p(k).* barker (1:13).* exp(j*2*Ko*u(k)*t);

 
 end

%Matched Filtering with inverse Barker code coefficients 

Sfilterd= filter(a,1,S)/13;

% Building the Matrix Cube
MatrixCube(i,1:L) = Sfilterd(1:L);


end

FFTMatrixCube = fftshift(fft(MatrixCube,[],1));

figure 
% Ploting the Doppler - Range Grapgh
image([-500 500],[-15 15],200*log10(abs(FFTMatrixCube')));
xlabel('Doppler')
ylabel('Range')

figure
X = 1:1:1000;
plot(X,abs(Sfilterd)) 
hold on 
plot(X,abs(S))
hold off
legend('Clutter','Filter output')

L1 = 1:1:1024;
M1 = -500:1:500;
figure
mesh(abs(MatrixCube))

