function [pilih_sel,titik,d]=rayline(x1,z1,x2,z2)
% pilih_sel = subscript sel yang dilewati garis (kolom 1 x, kolom 2 z)
% titik = titik yang dilalui garis pada setiap sel
% d = jarak ray pada setiap sel slowness
% x1, z1 = koordinat titik awal garis
% x2, z2 = koordinat titik akhir garis
%
% CATATAN : |x1-x2| dan |z1-z2| harus <= 2
%
% Pemilihan sel berdasarkan kaidah imagesc
%   >>> misal sel (10,12) berarti batas-batasnya adalah 
%       x = 9.5 sd 10.5
%       z = 11.5 sd 12.5
%
% Dibuat oleh : Erdyanti Rinta Bi Tari (Dept. Teknik Geofisika ITS)
% @2019

if z1==z2 && x1>x2 %horizontal
    balik = 1;
elseif x1==x2 && z1>z2 %vertikal
    balik = 1;
elseif z1>z2 && x1>x2 %m>0
    balik = 1;
elseif z1<z2 && x1>x2 %m<0
    balik = 1; 
else
   balik = 0;
end
if balik==0
    za=z1; zb=z2; xa=x1; xb=x2;
elseif balik==1
    za=z2; zb=z1; xa=x2; xb=x1;
end

m = (zb-za)/(xb-xa);
XA = round(xa);
XB = round(xb);
ZA = round(za);
ZB = round(zb);

x_tgh = (XA + XB)/2;
zt = za + (x_tgh-xa)*m;
z_tgh = (ZA + ZB)/2;
xt = xa + (z_tgh-za)/m;

[x_tgh zt z_tgh xt];

if m==Inf || m==0
    xt = x_tgh;
    zt = z_tgh;
end

if x_tgh == xt || z_tgh == zt
    points = [xa xt xb; za zt zb]';
elseif x_tgh < xt
    points = [xa x_tgh xt xb; za zt z_tgh zb]';
elseif x_tgh > xt
    points = [xa xt x_tgh xb; za z_tgh zt zb]';
end

points = unique(points,'rows');
for i = [1 length(points)]
    if (points(i,1)<xa) || (points(i,1)>xb) %Menghilangkan titik yang tidak termasuk di garis
        points(i,:)=[];
        break
    end
end
n = length(points)-1;
titik = zeros(n,4);
d = zeros(n,1);

for i = 1:n
    titik(i,1) = points(i,1);
    titik(i,2) = points(i,2);
    titik(i,3) = points(i+1,1);
    titik(i,4) = points(i+1,2);
    
    rata(i,1) = mean(titik(i,[1 3]));
    rata(i,2) = mean(titik(i,[2 4]));
    pilih_sel(i,:) = round(rata(i,:));
    
    d(i) = sqrt((titik(i,1)-titik(i,3))^2 + (titik(i,2)-titik(i,4))^2);
end
    
if balik==1
    pilih_sel = flipud(pilih_sel);
    titik = flipud(titik);
    buffer_titik = titik(:,1:2);
    titik(:,1:2) = titik(:,3:4);
    titik(:,3:4) = buffer_titik;
    d = flipud(d);
end



    

