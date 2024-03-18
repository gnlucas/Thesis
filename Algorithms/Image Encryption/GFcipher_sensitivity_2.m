clear all
close all
clc

% Key Sensitivity Analysis - 2

a = imread('baboon.jpg');       %baboon.jpg, elaine.jpg, pepper.jpg

%Plain-image factor - Initial Condition 1
b1 = mean(a(1:end/2))/256;
b2 = mean(a(end/2+1:end))/256;
c1 = dec2bin(b1/eps);
c2 = dec2bin(b2/eps);
c = strcat(c1(1:32),c2(1:32));
x = char(num2cell(c));
x1 = reshape(str2num(x),1,[]);

%User input - Initial Condition 2
%0.1 => 00.00011001100110011001100110011001100110011001100110011001100110
x2 = [0 0 0 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 ...
  0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0 0 1 1 0];

N = 64;
%Companion matrix
P = zeros(N,N);
for k = 2:N
    P(k,k-1) = 1;
end

%Irreducible polynomial
%p(x) = x^64 + x^63 + x^8 + x^2 + 1
P([1 3 9 64],end) = -1;

%Corresponding matrix to vector x
X1 = zeros(N,N);
 for n = 1:N
     X1 = mod(X1+x1(65-n)*P^(n-1),2);
 end

X2 = zeros(N,N);
 for n = 1:N
     X2 = mod(X2+x2(65-n)*P^(n-1),2);
 end

%Merging user and image factors
X = mod(X1+X2,2);

%Parameter control of the logistic map
%3.99 => 11.11111101011100001010001111010111000010100011110101110000101000
r = [1 1 1 1 1 1 1 1 0 1 0 1 1 1 0 0 0 0 1 0 1 0 0 0 1 1 1 1 0 1 0 1 ...
   1 1 0 0 0 0 1 0 1 0 0 0 1 1 1 1 0 1 0 1 1 1 0 0 0 0 1 0 1 0 0 0];

%Corresponding matrix to vector r
R = zeros(N,N);
 for n = 1:N
     R = mod(R+r(65-n)*P^(n-1),2);
 end

%Corresponding matrix to vector 1
%1 => 01.00000000000000000000000000000000000000000000000000000000000000
u = [0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ...
   0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];

%Corresponding matrix to vector u
U = zeros(N,N);
for n = 1:N
    U = mod(U+u(65-n)*P^(n-1),2);
end

%Logistic map simulation
X(:,:,1) = X;

%Number of iteration for 512x512 images
it = (512*512/(64*8));

for m = 1:it
    X(:,:,m+1) = mod(R*X(:,:,m)*(U-X(:,:,m)),2);
end

Z = reshape(X(:,:,2:end),512*512,8);
bd = [1 2 4 8 16 32 64 128]';
Y = Z*bd;
h = uint8(reshape(Y,512,512));

%Bit-XOR operation
i = bitxor(a,h,'uint8');

% New encryption with different key

%Plain-image factor - Initial Condition 1
           %f_Baboon => 10.00001010100000001010010000000010000011011000011100001100000000
%         1*10^(-14) => 00.00000000000000000000000000000000000000000000001011010000100100
%f_Baboon+1*10^(-14) => 10.00001010100000001010010000000010000011011000100111011100100100
x3 = [1 0 0 0 0 0 1 0 1 0 1 0 0 0 0 0 0 0 1 0 1 0 0 1 0 0 0 0 0 0 0 0 ...
    1 0 0 0 0 0 1 1 0 1 1 0 0 0 1 0 0 1 1 1 0 1 1 1 0 0 1 0 0 1 0 0];

X3 = zeros(N,N);
 for n = 1:N
     X3 = mod(X3+x3(65-n)*P^(n-1),2);
 end

%Merging user and image factors
X4 = mod(X2+X3,2);

%Logistic map simulation
X4(:,:,1) = X4;

for m = 1:it
    X4(:,:,m+1) = mod(R*X4(:,:,m)*(U-X4(:,:,m)),2);
end

Z2 = reshape(X4(:,:,2:end),512*512,8);
Y2 = Z2*bd;
h2 = uint8(reshape(Y2,512,512));

%Bit-XOR operation
i2 = bitxor(a,h2,'uint8');

j = bitxor(i,h2,'uint8');

res = sensitivity(i,i2,1,255)
res2 = sensitivity(a,j,1,255)