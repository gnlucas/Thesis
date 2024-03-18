% Chen's Hyperchaotic System - 2

function out = chen2(t,in)
x = in(1);
y = in(2);
z = in(3);
w = in(4);

a = 36;
b = 3;
c = 28;
d = -16;
k = 0.2;

% Equations
xdot = a*y-a*x;
ydot = d*x-x*z+c*y-w;
zdot = x*y-b*z;
wdot = x+k;

out = [xdot ydot zdot wdot]';