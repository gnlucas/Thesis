%Chen's system%

format long
h=0.001;                   %Time-step
ic=[-10.058 0.368 37.368]; %Initial conditions
tf=87.381;
tspan = 0:h:tf;
x=ode4(@chen,tspan,ic);