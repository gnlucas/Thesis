%Main file%
%Pseudo-orbits%

%Tradicional simulation
odepseudo

%Tradicional simulation
odepseudo2

%Lower-Bound Error
Xeq=(x(:,1)-x2(:,1))/2;
er=(x(:,1)-x2(:,1))./(x(:,1)+x2(:,1));
aux=[find(log10(er)>-10)];
aux1=aux(1,1);

%Image read
a=imread('baboon.jpg');

%Show the image
figure(1)
imshow(a)
a=a(:,:,1);
t=size(a);
ta1=t(:,1);
ta2=t(:,2);

%Study of chaos in image encryption
b=log10(abs(Xeq));

%Transform d-values ??into positive integers [0;255]
c=b*10^(15);
d=mod(c,256);
e=uint8(d);
f=e(aux1:aux1+262143);
g=f';
h=reshape(g,512,512);
i=bitxor(a,h,'uint8');

%Cipher image
figure(2)
imshow(i)