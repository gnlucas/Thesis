% Main

format long

h = 1e-2;
x0 = [0.5 -0.2 0];
tf = 999.999;
tspan = 0:h:tf;

x = ode4(@sprott,tspan,x0);
y = ode4(@sprott2,tspan,x0);

figure(1)
plot(tspan,x(:,1),'-b')
hold on
plot(tspan,y(:,1),'--r')
set(0,'DefaultAxesFontSize',18,'DefaultAxesFontName', 'Times New Roman')
xlabel('Time (s)','Interpreter','latex')
ylabel('$x$','Interpreter','latex')
legend({'NIE 1','NIE 2'},'Interpreter','latex','Location','southwest')
xlim([10000*1e-2 40000*1e-2])