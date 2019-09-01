function [xb,zb,d,x2,z2,kondisi2,ket]=raypath(x,z,xa,za,Temp,kondisi,size_model)
% Fungsi : 
% - Menentukan titik B (xb,zb)
% - Menentukan jarak di sel xz (d)
% - Menentukan sel selanjutnya (x2,z2) dan kondisi selanjutnya (kondisi2)
%
% **Next cell berdasarkan oldenburg
%
% Problem : klo di titik, penentuan kondisi kemana ?
% Kesimpulan : 'Error' ketika di grid, hasilnya akan berbeda ketika
% diasumsikan kondisi dari kiri atau dari bawah.
% Solusi : Buat kategori baru ('kiri atas', 'kanan bawah', dsb.)

teta = Temp.teta(z(1),x(1));

h = 1; %Lebar sel (px)
xb=[];

% a di sisi ('kanan','kiri ','bawah','atas ' atau tengah ('  -  ') )
while isempty(xb)==1
if teta>360
    teta=teta-360;
end

if length(kondisi)==5
    if kondisi=='atas '
        alfa1=atand((x(2)-xa)/h);
        alfa2=atand((xa-x(1))/h);
        if teta>270 && teta<=360
            ket = 'sudut 1';
            xb=x(2); 
            zb=z(1);
            x2=x+1;
            z2=z-1; % sebelumnya : z
            kondisi2='3';
        elseif teta>0 && teta<(90-alfa1)
            ket = 'sudut 2';
            xb=x(2); 
            zb=za+(x(2)-xa)*tand(teta);
            x2=x+1;
            z2=z;
            kondisi2='kiri ';
        elseif teta==90-alfa1
            ket = 'sudut 3';
            xb=x(2);
            zb=z(4);
            x2=x+1;
            z2=z+1;
            kondisi2='1';
        elseif teta>90-alfa1 && teta<90+alfa2
            ket = 'sudut 4';
            xb=xa+h*cotd(teta);
            zb=z(4);
            x2=x;
            z2=z+1;
            kondisi2='atas ';
        elseif teta==90+alfa2
            ket = 'sudut 5';
            xb=x(1) ;
            zb=z(4);
            x2=x-1;
            z2=z+1; %Sebelumnya : z=z+1
            kondisi2='2';
        elseif teta>90+alfa2 && teta<180 %sebelumnya : teta<=180
            ket = 'sudut 6';
            xb=x(1);
            zb=za-(xa-x(1))*tand(teta);
            x2=x-1;
            z2=z;
            kondisi2='kanan';
        elseif teta>=180 && teta <270 %sebelumnya : teta>180
            ket = 'sudut 7';
            xb=x(1);
            zb=z(1);
            x2=x-1;
            z2=z-1;
            kondisi2='4';
        end
    elseif kondisi=='bawah'
        alfa1=atand((xa-x(1))/h);
        alfa2=atand((x(2)-xa)/h);
        if teta>90 && teta<=180
            ket = 'sudut 1';
            xb=x(1);
            zb=z(4);
            x2=x-1;
            z2=z+1;
            kondisi2='2';
        elseif teta>180 && teta<270-alfa1
            ket = 'sudut 2';
            xb=x(1);
            zb=za-(xa-x(1))*tand(teta);
            x2=x-1;
            z2=z;
            kondisi2='kanan';
        elseif teta==270-alfa1
            ket = 'sudut 3';
            xb=x(1);
            zb=z(1);
            x2=x-1;
            z2=z-1;
            kondisi2='4';
        elseif teta>270-alfa1 && teta<270+alfa2
            ket = 'sudut 4';
            xb=xa-h*cotd(teta);
            zb=z(1);
            x2=x;
            z2=z-1;
            kondisi2='bawah';
        elseif teta==270+alfa2
            ket = 'sudut 5';
            xb=x(2);
            zb=z(1);
            x2=x+1;
            z2=z-1;
            kondisi2='3';
        elseif teta>270+alfa2 && teta<360 %Sebelumnya : teta<=360
            ket = 'sudut 6';
            xb=x(2);
            zb=za+(x(2)-xa)*tand(teta);
            x2=x+1;
            z2=z;
            kondisi2='kiri ';
        elseif teta>=0 && teta<90 %Sebelumnya : teta>0
            ket = 'sudut 7';
            xb=x(2);
            zb=z(4);
            x2=x+1;
            z2=z+1;
            kondisi2='1';
        end
    elseif kondisi=='kanan'
        alfa1=atand((z(4)-za)/h);
        alfa2=atand((za-z(1))/h);
        if teta>0 && teta<=90
            ket = 'sudut 1';
            xb=x(2);
            zb=z(4);
            x2=x+1;
            z2=z+1;
            kondisi2='1';
        elseif teta>90 && teta<180-alfa1
            ket = 'sudut 2';
            xb=xa+(z(4)-za)*cotd(teta);
            zb=z(4);
            x2=x;
            z2=z+1;
            kondisi2='atas ';
        elseif teta==180-alfa1
            ket = 'sudut 3';
            xb=x(1);
            zb=z(4);
            x2=x-1;
            z2=z+1;
            kondisi2='2';
        elseif teta>180-alfa1 && teta<180+alfa2
            ket = 'sudut 4';
            xb=x(1);
            zb=za-h*tand(teta);
            x2=x-1;
            z2=z;
            kondisi2='kanan';
        elseif teta==180+alfa2
            ket = 'sudut 5';
            xb=x(1);
            zb=z(1);
            x2=x-1;
            z2=z-1;
            kondisi2='4';
        elseif teta>180+alfa2 && teta<270 %Sebelumnya : teta<=270
            ket = 'sudut 6';
            xb=xa-(za-z(1))*cotd(teta); %Sebelumnya (sama aja sih sebenernya...): xa+(z(1)-za)*cotd(teta)
            zb=z(1);
            x2=x;
            z2=z-1;
            kondisi2='bawah';
        elseif teta>=270 && teta<360 %Sebelumnya : teta>270
            ket = 'sudut 7';
            xb=x(2);
            zb=z(1);
            x2=x+1;
            z2=z-1;
            kondisi2='3';
        end
    elseif kondisi=='kiri '
        alfa1=atand((za-z(1))/h);
        alfa2=atand((z(4)-za)/h);
        if teta>180 && teta<=270
            ket = 'sudut 1';
            xb=x(1);
            zb=z(1);
            x2=x-1;
            z2=z-1;
            kondisi2='4';
        elseif teta>270 && teta<360-alfa1
            ket = 'sudut 2';
            xb=xa-(za-z(1))*cotd(teta); %Sebelumnya : xb=xa+(za-z(1))*cotd(teta)
            zb=z(1);
            x2=x;
            z2=z-1;
            kondisi2='bawah';
        elseif teta==360-alfa1
            ket = 'sudut 3';
            xb=x(2);
            zb=z(1);
            x2=x+1;
            z2=z-1;
            kondisi2='3';
        elseif teta>360-alfa1 || teta<alfa2 %Sebelumnya : teta>360-alfa1 && teta+360<360+alfa2
            ket = 'sudut 4';
            xb=x(2);
            zb=za+h*tand(teta);
            x2=x+1;
            z2=z;
            kondisi2='kiri ';
        elseif teta==alfa2
            ket = 'sudut 5';
            xb=x(2);
            zb=z(4);
            x2=x+1;
            z2=z+1;
            kondisi2='1'; %Sebelumnya : kondisi2='2'
        elseif teta>alfa2 && teta<90 %Sebelumnya : teta<=90
            ket = 'sudut 6';
            xb=xa+(z(4)-za)*cotd(teta);
            zb=z(4);
            x2=x;
            z2=z+1;
            kondisi2='atas ';
        elseif teta>=90 && teta<=180 %Sebelumnya : teta>90
            ket = 'sudut 7';
            xb=x(1);
            zb=z(4);
            x2=x-1;
            z2=z+1;
            kondisi2='2';
        end
    elseif kondisi=='  -  ' %a di tengah sel
        teta1=atand((z(4)-za)/(x(2)-xa));
        teta2=90+atand((xa-x(1))/(z(4)-za));
        teta3=180+atand((za-z(1))/(xa-x(1)));
        teta4=270+atand((x(2)-xa)/(za-z(2)));    
        if teta<teta1 || teta>teta4
            ket = 'sudut 1';
            xb=x(4);
            zb=za+(x(4)-xa)*tand(teta);
            x2=x+1;
            z2=z;
            kondisi2='kiri ';
        elseif teta==teta1
            ket = 'tepat 1';
            xb=x(4);
            zb=z(4);
            x2=x+1;
            z2=z+1;
            kondisi2='1';
        elseif teta<teta2
            ket = 'sudut 2';
            zb=z(3);
            xb=xa+(z(4)-za)*cotd(teta); %Sebelumnya : tand
            x2=x;
            z2=z+1;
            kondisi2='atas ';
        elseif teta==teta2
            ket = 'tepat 2';
            xb=x(3);
            zb=z(3);
            x2=x-1;
            z2=z+1;
            kondisi2='2';
        elseif teta<teta3
            ket = 'sudut 3';
            xb=x(1);
            zb=za-(xa-x(1))*tand(teta); %Sebelumnya (sama aja sih...) : zb=za+(x(1)-xa)*tand(teta)
            x2=x-1;
            z2=z;
            kondisi2='kanan';
        elseif teta==teta3
            ket = 'tepat 3';
            xb=x(1);
            zb=z(1);
            x2=x-1;
            z2=z-1;
            kondisi2='4';
        elseif teta<teta4
            ket = 'sudut 4';
            zb=z(1);
            xb=xa-(za-z(1))*cotd(teta); %Sebelumnya : xb=xa+(x(2)-xa)*tand(teta);
            x2=x;
            z2=z-1;
            kondisi2='bawah';
        elseif teta==teta4
            ket = 'tepat 4';
            xb=x(2);
            zb=z(2);
            x2=x+1;
            z2=z-1;
            kondisi2='3';
        end

    end
end

% a di grid point
if length(kondisi)==1 
    if kondisi=='1' 
        if teta<=360 && teta>=270 %Sebelumnya : teta>270
            ket = 'kuadran 4';
            xb=x(2); 
            zb=z(1);
            x2=x+1; % Kanan atas
            z2=z-1;
            kondisi2='3';
        elseif teta>0 && teta<45
            ket = 'kuadran 1a';
            xb=x(2);
            zb=za+h*tand(teta);
            x2=x+1; % Kanan
            z2=z;
            kondisi2='kiri ';
        elseif teta==45
            ket = '45';
            xb=x(4); %Sebelumnya : xb=x(3)
            zb=z(4); %Sebelumnya : zb=z(3)
            x2=x+1;
            z2=z+1;
            kondisi2='1';
        elseif teta>45 && teta<90
            ket = 'kuadran 1b';
            xb=xa+h*cotd(teta);
            zb=z(4);
            x2=x; % Bawah
            z2=z+1;
            kondisi2='atas ';
        elseif teta>=90 && teta<=180 %Sebelumnya : teta<180
            ket = 'kuadran 2';
            xb=x(3);
            zb=z(3);
            x2=x-1; % Kiri bawah
            z2=z+1;
            kondisi2='2';
        end
    elseif kondisi=='2'
        if teta>=0 && teta<=90 %Sebelumnya teta>0
            ket = 'kuadran 1';
            xb=x(2); 
            zb=z(4);
            x2=x+1;
            z2=z+1;
            kondisi2='1';
        elseif teta>90 && teta<180-45
            ket = 'kuadran 2a';
            xb=xa+h*cotd(teta);
            zb=z(3);
            x2=x;
            z2=z+1;
            kondisi2='atas ';
        elseif teta==180-45
            ket = '45';
            xb=x(3);
            zb=z(3);
            x2=x-1;
            z2=z+1;
            kondisi2='2';
        elseif teta>180-45 && teta<180
            ket = 'sudut 2b';
            xb=x(1);
            zb=za-h*tand(teta);
            x2=x-1; %Sebelumnya : x2=x
            z2=z; %Sebelumnya : z2=z-1
            kondisi2='kanan'; %Sebelumnya : atas
        elseif teta>=180 && teta<=270
            ket = 'kuadran 3';
            xb=x(1);
            zb=z(1);
            x2=x-1;
            z2=z-1;
            kondisi2='4';
        end
    elseif kondisi=='3'
        if teta>=0 && teta<=90
            ket = 'kuadran 1';
            xb=x(4);
            zb=z(4);
            x2=x+1;
            z2=z+1;
            kondisi2='1';
        elseif teta>=180 && teta<=270
            ket = 'kuadran 3';
            xb=x(1);
            zb=z(1);
            x2=x-1;
            z2=z-1;
            kondisi2='4';
        elseif teta>270 && teta<360-45
            ket = 'kuadran 4a';
            xb=xa-h*cotd(teta); %Sebelumnya : tidak ada h
            zb=z(2);
            x2=x;
            z2=z-1;
            kondisi2='bawah';
        elseif teta==360-45
            ket = '45';
            xb=x(2);
            zb=z(2);
            x2=x+1;
            z2=z-1;
            kondisi2='3';
        elseif teta>360-45 && teta<360
            ket = 'kuadran 4b';
            xb=x(4);
            zb=za+h*tand(teta);
            x2=x+1;
            z2=z;
            kondisi2='kiri ';
        end
    elseif kondisi=='4'
        if teta>=90 && teta<=180
            ket = 'kuadran 2';
            xb=x(3);
            zb=z(3);
            x2=x-1;
            z2=z+1;
            kondisi2='2';
        elseif teta>180 && teta<180+45
            ket = 'kuadran 3a';
            xb=x(1);
            zb=za-h*tand(teta);
            x2=x-1;
            z2=z;
            kondisi2='kanan';
        elseif teta==180+45
            ket = '45';
            xb=x(1);
            zb=z(1);
            x2=x-1;
            z2=z-1;
            kondisi2='4';
        elseif teta>180+45 && teta<270
            ket = 'kuadran 3b';
            xb=xa-h*cotd(teta);
            zb=z(1);
            x2=x;
            z2=z-1;
            kondisi2='bawah';
        elseif teta>=270 && teta<=360
            ket = 'kuadran 4';
            xb=x(2);
            zb=z(2);
            x2=x+1; %Sebelumnya : x-1
            z2=z-1;
            kondisi2='3';
        end
    end
end

if isempty(xb)==1 %Jika teta tidak ada yang memenuhi kondisi di atas
    % Berarti ada efek error akibat pembagian model menjadi grid.
    % Jika dilihat polanya, dari percobaan sebelumnya, selalu nilai teta
    % berkebalikan dari yang seharusnya. Jadi .... solusinya menjadi...
    teta=teta+180;
end
end

xmin = 1; xmax = size_model(2); 
zmin = 1; zmax = size_model(1); 

% Pilih sel 2 ketika [x2 z2] di grid
% if (zb==za && xb~=xa) && (xb==xmin || xb==xmax) && ~(Temp.XS~=xb && Temp.ZS~=zb) %garis vertikal
%     teta1 = Temp.teta(zb,xb);
%     teta2 = Temp.teta(zb-1,xb);
%     if teta2<teta1
% %         z2 = z2-1;
%     else
% %         z2 = z2+1;
%     end
%     
%     if xb==xmin
% %         kondisi2 = 'kiri ';
% %         disp 'GANTI kiri';
%     elseif xb==xmax
% %         kondisi2 = 'kanan';
% %         disp 'GANTI kanan';        
%     end
% end
% 
% if (xb==xa && zb~=za) && (zb==zmin || zb==zmax) && (Temp.XS~=xb && Temp.ZS~=zb) %garis horizontal
%     teta1 = Temp.teta(zb,xb);
%     teta2 = Temp.teta(zb,xb-1);
%     if teta2<teta1
%         x2 = x2-1;
% %         kondisi2 = 'kiri ';
% %         disp 'GANTI kiri'
%     else
%         x2 = x2+1;
%         kondisi2 = 'kanan';
%         disp 'GANTI kanan';
%     end
    
%     if zb==zmin
%         kondisi2 = 'atas ';
%         disp 'GANTI kiri';
%     elseif zb==zmax
%         kondisi2 = 'bawah';
%         disp 'GANTI kanan';        
%     end
% end

% Titik B jika melewati boundary
if xb<xmin
    xb=xmin;
%     disp 'xb lewat bound kiri'
elseif xb>xmax
    xb=xmax; 
%     disp 'xb lewat bound kanan'
end
if zb<zmin
    zb=zmin;
%     disp 'zb lewat bound atas'
elseif zb>zmax
    zb=zmax; 
%     disp 'zb lewat bound bawah'
end
    
% Next cell ketika melewati boundary
%Pengondisian sel untuk [x2 z2] di sisi; mepet boundary
if x2(1)<xmin 
    x2=x2+1;
%     disp 'GANTI KANAN ; [xb zb] di sisi'
elseif x2(end)>xmax
    x2=x2-1;
%     disp 'GANTI KIRI ; [xb zb] di sisi'
end
if z2(1)<zmin
    z2=z2+1;
%     disp 'GANTI BAWAH ; [xb zb] di sisi'
elseif z2(end)>zmax
    z2=z2-1;
%     disp 'GANTI ATAS ; [xb zb] di sisi'
end

% if 

dx=xb-xa;
dz=zb-za;
d=sqrt(dx^2+dz^2);

