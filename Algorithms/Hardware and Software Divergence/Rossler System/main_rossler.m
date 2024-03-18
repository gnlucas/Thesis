% Main

format long

h = 1e-2;
x0 = [0.5 -0.2 0];
tf = 1099.999;
tspan = 0:h:tf;

x = ode4(@rossler,tspan,x0);
y = load('rossler_server.txt');

figure(1)
plot(tspan,x(:,1),'-b')
hold on
plot(tspan,y(:,1),'--r')
set(0,'DefaultAxesFontSize',18,'DefaultAxesFontName', 'Times New Roman')
xlabel('Time (s)','Interpreter','latex')
ylabel('$x$','Interpreter','latex')
legend({'Device 1','Device 2'},'Interpreter','latex','Location','southwest')
xlim([90000*1e-2 110000*1e-2])