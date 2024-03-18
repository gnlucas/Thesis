% Sprott's Jerk Circuit - 2

function out = sprott2(t,in)
x = in(1);
y = in(2);
z = in(3);

a = 0.5;

% Equations
xdot = y;
ydot = z;
zdot = (-a*z)+(-x-10^(-9)*(exp(y/0.026)-1));

out = [xdot ydot zdot]';