% Dynamical Degradation - Tent Map

clear all;
close all;
clc;

k = fi(0.5,0,16,15);
u = fi(1,0,16,15);
N = 149;

mu1 = fi(1.5,0,16,15);
x1(1) = fi(0.3,0,16,15);
for i = 1:1:N
    if x1(i) < k
        x1(i+1) = mu1*x1(i);
    else
        x1(i+1) = mu1*(u-x1(i));
    end
end

first_half_x1 = x1(1:67);
second_half_x1 = x1(68:150);

figure(1)
plot(1:length(first_half_x1),first_half_x1,'b-o')
hold on
plot(length(first_half_x1)+(1:length(second_half_x1)),second_half_x1,'r-o')
set(0,'DefaultAxesFontSize',18,'DefaultAxesFontName', 'Times New Roman')
xlabel('Iteration','Interpreter','latex')
ylabel('$x_n$','Interpreter','latex')
legend({'Transient','Cycle'},'Interpreter','latex','Location','southwest')
xlim([1 150])

clear all;
clc;

k = fi(0.5,0,16,15);
u = fi(1,0,16,15);
N = 149;

mu2 = fi(1.55,0,16,15);
x2(1) = fi(0.3,0,16,15);
for i = 1:1:N
    if x2(i) < k
        x2(i+1) = mu2*x2(i);
    else
        x2(i+1) = mu2*(u-x2(i));
    end
end

first_half_x2 = x2(1:57);
second_half_x2 = x2(58:150);

figure(2)
plot(1:length(first_half_x2),first_half_x2,'b-o')
hold on
plot(length(first_half_x2)+(1:length(second_half_x2)),second_half_x2,'r-o')
set(0,'DefaultAxesFontSize',18,'DefaultAxesFontName', 'Times New Roman')
xlabel('Iteration','Interpreter','latex')
ylabel('$x_n$','Interpreter','latex')
legend({'Transient','Cycle'},'Interpreter','latex','Location','southwest')
xlim([1 150])

clear all;
clc;

k = fi(0.5,0,16,15);
u = fi(1,0,16,15);
N = 149;

mu3 = fi(1.7,0,16,15);
x3(1) = fi(0.3,0,16,15);
for i = 1:1:N
    if x3(i) < k
        x3(i+1) = mu3*x3(i);
    else
        x3(i+1) = mu3*(u-x3(i));
    end
end

first_half_x3 = x3(1:8);
second_half_x3 = x3(9:150);

figure(3)
plot(1:length(first_half_x3),first_half_x3,'b-o')
hold on
plot(length(first_half_x3)+(1:length(second_half_x3)),second_half_x3,'r-o')
set(0,'DefaultAxesFontSize',18,'DefaultAxesFontName', 'Times New Roman')
xlabel('Iteration','Interpreter','latex')
ylabel('$x_n$','Interpreter','latex')
legend({'Transient','Cycle'},'Interpreter','latex','Location','southwest')
xlim([1 150])
ylim([0 1])

clear all;
clc;

k = fi(0.5,0,16,15);
u = fi(1,0,16,15);
N = 199;

mu4 = fi(1.8,0,16,15);
x4(1) = fi(0.3,0,16,15);
for i = 1:1:N
    if x4(i) < k
        x4(i+1) = mu4*x4(i);
    else
        x4(i+1) = mu4*(u-x4(i));
    end
end

first_half_x4 = x4(1:40);
second_half_x4 = x4(41:200);

figure(4)
plot(1:length(first_half_x4),first_half_x4,'b-o')
hold on
plot(length(first_half_x4)+(1:length(second_half_x4)),second_half_x4,'r-o')
set(0,'DefaultAxesFontSize',18,'DefaultAxesFontName', 'Times New Roman')
xlabel('Iteration','Interpreter','latex')
ylabel('$x_n$','Interpreter','latex')
legend({'Transient','Cycle'},'Interpreter','latex','Location','southwest')
xlim([1 200])
ylim([0 1])

clear all;
clc;

k = fi(0.5,0,16,15);
u = fi(1,0,16,15);
N = 399;

mu5 = fi(1.95,0,16,15);
x5(1) = fi(0.3,0,16,15);
for i = 1:1:N
    if x5(i) < k
        x5(i+1) = mu5*x5(i);
    else
        x5(i+1) = mu5*(u-x5(i));
    end
end

first_half_x5 = x5(1:334);
second_half_x5 = x5(335:400);

figure(5)
plot(1:length(first_half_x5),first_half_x5,'b-o')
hold on
plot(length(first_half_x5)+(1:length(second_half_x5)),second_half_x5,'r-o')
set(0,'DefaultAxesFontSize',18,'DefaultAxesFontName', 'Times New Roman')
xlabel('Iteration','Interpreter','latex')
ylabel('$x_n$','Interpreter','latex')
legend({'Transient','Cycle'},'Interpreter','latex','Location','southwest')
xlim([1 400])
ylim([0 1])

clear all;
clc;

k = fi(0.5,0,16,15);
u = fi(1,0,16,15);
N = 39;

mu6 = fi(2,0,16,15);
x6(1) = fi(0.3,0,16,15);
for i = 1:1:N
    if x6(i) < k
        x6(i+1) = mu6*x6(i);
    else
        x6(i+1) = mu6*(u-x6(i));
    end
end

first_half_x6 = x6(1:16);
second_half_x6 = x6(17:40);

figure(6)
plot(1:length(first_half_x6),first_half_x6,'b-o')
hold on
plot(length(first_half_x6)+(1:length(second_half_x6)),second_half_x6,'r-o')
set(0,'DefaultAxesFontSize',18,'DefaultAxesFontName', 'Times New Roman')
xlabel('Iteration','Interpreter','latex')
ylabel('$x_n$','Interpreter','latex')
legend({'Transient','Cycle'},'Interpreter','latex','Location','southwest')
xlim([1 40])
ylim([0 1])