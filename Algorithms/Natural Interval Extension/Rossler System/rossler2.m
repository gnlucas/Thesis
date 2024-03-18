% Rössler System - 2

function out = rossler2(t,in)
x = in(1);
y = in(2);
z = in(3);

a = 0.2;
b = 0.2;
c = 5.7;

% Equations
xdot = -y-z;
ydot = x+a*y;
zdot = b+x*z-c*z;

out = [xdot ydot zdot]';