clear all;
close all;
clc;

% Open the data as string - x-orbit
FID = fopen('Data\2_64.txt');
data = textscan(FID,'%s');
fclose(FID);
x = string(data{:});

% Open the data as string - x-orbit 2
FID2 = fopen('Data\2_64_ulp.txt');
data2 = textscan(FID2,'%s');
fclose(FID2);
xulp = string(data2{:});

% Convert the binary data to decimal numbers
for i=1:size(x,1)
    aux=['.' x{i}];
    aux2=bin_dec_conversion(aux);
    h(i)=aux2.num_dec;
    aux3=['.' xulp{i}];
    aux4=bin_dec_conversion(aux3);
    h2(i)=aux4.num_dec;
end

figure(1)
plot(h(1:5000-1),h(2:5000),'.')
set(gca,'FontSize',25)
xlabel('$x_{n}$','Interpreter','latex','FontSize',40)
ylabel('$x_{n+1}$','Interpreter','latex','FontSize',40)

figure(2)
plot(h(1:100))
hold on
plot(h2(1:100))
set(gca,'FontSize',25)
xlabel('Iteration','Interpreter','latex','FontSize',40)
ylabel('$x_{n}$','Interpreter','latex','FontSize',40)

figure(3)
histogram(h,20)
set(gca,'FontSize',25)
xlabel('$x_{n}$','Interpreter','latex','FontSize',40)
ylabel('Frequency','Interpreter','latex','FontSize',40)

figure(4)
autocorr(h,'NumLags',10)
set(gca,'FontSize',25)
xlabel('Lag','Interpreter','latex','FontSize',40)
ylabel('Sample Autocorrelation','Interpreter','latex','FontSize',33)

%One-sample Kolmogorov-Smirnov test
disp('----------One-sample Kolmogorov-Smirnov test----------')
pd = makedist('uniform');
[j,p] = kstest(h,'cdf',pd,'Alpha',0.01)

%Run test for randomness
disp('---------------Run test for randomness----------------')
[k,p,stats] = runstest(h,0.5,'Alpha',0.01)

% Lyapunov exponent
disp('------------------Lyapunov exponent-------------------')
lambda = load('Data\64_bits_lyapmax.dat');
lambda = lambda(end,end)/log(2)

% Save decimal numbers in a file
% FID3 = fopen('10_64.dat','w');
% fprintf(FID3,'%f\n',h(1:end)');
% fclose(FID3);