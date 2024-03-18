for i = 1:10000
    aux = [x{i}];
    aux2 = bin_dec_conversion_float(aux);
    h(i) = aux2.num_dec;
end

figure(1)
plot(h(1:10000-1),h(2:10000),'.')
set(gca,'FontSize',10)
xlabel('$x_{n}$','Interpreter','latex','FontSize',20)
ylabel('$x_{n+1}$','Interpreter','latex','FontSize',20)

figure(2)
plot(h(1:100))
set(gca,'FontSize',10)
xlabel('Iteration','Interpreter','latex','FontSize',20)
ylabel('$x_{n}$','Interpreter','latex','FontSize',20)

figure(3)
histogram(h,20)
set(gca,'FontSize',10)
xlabel('$x_{n}$','Interpreter','latex','FontSize',20)
ylabel('Frequency','Interpreter','latex','FontSize',20)

figure(4)
autocorr(h,'NumLags',10)
set(gca,'FontSize',10)
xlabel('Lag','Interpreter','latex','FontSize',20)
ylabel('Sample Autocorrelation','Interpreter','latex','FontSize',20)

%One-sample Kolmogorov-Smirnov test
disp('----------One-sample Kolmogorov-Smirnov test----------')
pd = makedist('uniform');
[j,p] = kstest(h(1:10000),'cdf',pd,'Alpha',0.01)

%Run test for randomness
disp('---------------Run test for randomness----------------')
[k,p,stats] = runstest(h(1:10000),0.5,'Alpha',0.01)