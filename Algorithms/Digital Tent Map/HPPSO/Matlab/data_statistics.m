format long

for i=1:size(x,1)
    aux=[x{i}];
    aux2=bin_dec_conversion_float(aux);  % Rosenbrock function
    h(i)=aux2.num_dec;
    aux3=[y{i}];
    aux4=bin_dec_conversion_float(aux3); % Sphere function
    h2(i)=aux4.num_dec;
end

% Data Statistics - Rosenbrock Function
mn=min(h)
mu=mean(h)
md=median(h)
sd=std(h)

% Data Statistics - Sphere Function
mn2=min(h2)
mu2=mean(h2)
md2=median(h2)
sd2=std(h2)