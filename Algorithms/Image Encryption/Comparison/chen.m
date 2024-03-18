function out = chen(t,in)

x=in(1);
y=in(2);
z=in(3);

a=35;
b=3;
c=28;

%Chen's equations%
xdot=a*(y-x);
ydot=(c-a)*x-x*z+c*y;
zdot=x*y-b*z;

out=[xdot ydot zdot]';