% Rössler System

function out = rossler(t,in)
x = in(1);
y = in(2);
z = in(3);

a = 0.2;
b = 0.2;
c = 5.7;

% Equations
xdot = -y-z;
ydot = x+a*y;
zdot = b+z*(x-c);

out = [xdot ydot zdot]';