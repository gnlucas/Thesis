clear all
close all
clc

%Cryptosystem based on the article "Chaos-based image encryption
%algorithm"

%Read the image
a=imread('baboon.jpg');
figure(1)
imshow(a)

%Image N x N
N=512;

%Arnold cat map simulation / Shuffle operation
M=5;
for i=1:1:M
    for j=1:1:N
        for k=1:1:N
        b=mod([(j+k),(j+2*k)],[N N]);
        c(j,k)=a(b(1)+1,b(2)+1);
        end
    end
    a=c;
end

%Show the shuffled image
figure(2)
imshow(c)

%Chen's chaotic system simulation
odechen

x_c=x(:,1);
y_c=x(:,2);
z_c=x(:,3);

%Encryption Algorithm
b_x=uint8(mod((abs(x_c)-floor(abs(x_c)))*10^(14),256));
b_y=uint8(mod((abs(y_c)-floor(abs(y_c)))*10^(14),256));
b_z=uint8(mod((abs(z_c)-floor(abs(z_c)))*10^(14),256));

B=[b_x,b_y,b_z]';
K=reshape(B,[],1);
K=K(1:end-2,:);
K=reshape(K,512,512);

%Bit-xor operation
C=bitxor(a,K,'uint8');
figure(3)
imshow(C)

%Decryption Algorithm
%Bit-xor operation
a2=bitxor(C,K,'uint8');
figure(4)
imshow(a2)

%Arnold cat map simulation / Shuffle operation
for i=1:1:M
    for j=1:1:N
        for k=1:1:N
        b1 = mod([(j+k),(j+2*k)],[N N]);
        d(b1(1)+1,b1(2)+1)=a2(j,k);
        end
    end
    a2=d;
end
figure(5)
imshow(d)