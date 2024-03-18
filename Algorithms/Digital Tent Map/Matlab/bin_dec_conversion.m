function out=bin_dec_conversion(bin)
if find(bin=='-')==1
    bin(1)=[];
    sinal=-1;
else
    sinal=1;
end
tam=size(bin,2);
pp=(find(bin=='.'));
if pp==tam
    num_dec=0;
    for i=1:tam-1
        num_dec=num_dec+str2num(bin(i))*2^(tam-1-i);
    end
    out.num_dec=num_dec;
else
    num_dec=0;
    for i=1:pp-1
        num_dec=num_dec+str2num(bin(i))*2^(pp-1-i);
    end
    for k=1:tam-pp
        num_dec=num_dec+str2num(bin(pp+k))*2^(-k);
    end
end
    out.num_dec=sinal*num_dec;
end