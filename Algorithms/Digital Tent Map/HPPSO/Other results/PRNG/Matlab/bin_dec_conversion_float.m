function out=bin_dec_conversion_float(bin)
%==========================================================================
% Function for converting binary numbers to decimal.
% Input: bin ----> Binary number (String).
% Output: 27-bit floating point number:
% 1 Bit -------- Signal.
% 2-9 Bit's ---- Exponent.
% 10-27 Bit's --- Mantissa.
%==========================================================================
if bin(1)=='1'
    signal=-1;
else
    signal=1;
end
ex=bin(2:9);
num_dec=0;
for i=1:8
     num_dec=num_dec+str2num(ex(i))*2^(8-i);
end
exd=num_dec-127;
mantissa=bin(10:27);
if exd ~=-127 % Adding hidden bit
    bit=1;
else
    bit=0;
end
if exd==128
   if mantissa=='000000000000000000'
      if signal==-1
          out.num_dec='-Inf';
      else
          out.num_dec='Inf';
      end
   end
end
num_dec=bit*2^(0); % Bit escondido
for i=1:18
     num_dec=num_dec+str2num(mantissa(i))*2^(-i); % Rest of the mantissa
end
out.num_dec=(num_dec*2^(exd))*signal;
end