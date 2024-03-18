% Chua's Circuit

function out = chua(t,in)
x = in(1);
y = in(2);
z = in(3);

alpha = 15.6;
beta = 28;
m0 = -1.143;
m1 = -0.714;

% Chua's Diode
f = m1*x+0.5*(m0-m1)*(abs(x+1)-abs(x-1));

% Equations
xdot = alpha*(y-x-f);
ydot = x-y+z;
zdot = -beta*y;

out = [xdot ydot zdot]';