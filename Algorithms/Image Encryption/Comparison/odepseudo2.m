%Simulation - Chua's circuit%

format long
a=imread('baboon.jpg');
b=mean2(a)*10^-5+0.5;
h=1e-6;
y0=[b -0.2 0];
tf=0.35;
tspan = 0:h:tf;
x2=ode4(@chuapseudo2,tspan,y0);