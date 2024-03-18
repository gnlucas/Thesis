clear all
close all
clc

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

% %Save random binary file
% h2 = uint8(Y(1:75000));
% FID = fopen('bit_cryptosystem.bin','w');
% count = fwrite(FID, h2)
% fclose(FID);

%Bit-XOR operation
i = bitxor(a,h,'uint8');

disp('-------------------- Entropy --------------------');
e = entropy(i)

% Histogram
figure(1)
imshow(a)
%print('fig1','-depsc')
figure(2)
set(0,'DefaultAxesFontSize',24,'DefaultAxesFontName', 'Times New Roman')
imhist(a)
box off
axis([0 255 0 3500])
%print('fig2','-depsc')

figure(3)
imshow(i)
%print('fig3','-depsc')
figure(4)
set(0,'DefaultAxesFontSize',24,'DefaultAxesFontName', 'Times New Roman')
imhist(i)
box off
axis([0 255 0 3500])
%print('fig4','-depsc')

disp('---------Correlation Coefficient Plain-Image---------');
A = im2double(a);
c_diag = corrcoef(A(1:end-1,1:end-1),A(2:end, 2:end))
c_vert = corrcoef(A(1:end-1,:),A(2:end,:))
c_horz = corrcoef(A(:,1:end-1),A(:,2:end))

disp('--------Correlation Coefficient Cipher-Image---------');
I = im2double(i);
c_diag = corrcoef(I(1:end-1,1:end-1),I(2:end,2:end))
c_vert = corrcoef(I(1:end-1,:),I(2:end,:))
c_horz = corrcoef(I(:,1:end-1),I(:,2:end))