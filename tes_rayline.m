clc, clear all, close all
%% Titik dan Garis
xz = [4 5 4.3 5];

xa = xz(1);
xb = xz(2);
za = xz(3);
zb = xz(4);

tic
[pilih_sel,titik,d]=rayline(xa,za,xb,zb)
t1=toc;

% tic
% [Coords]=brlinexya(xa,za,xb,zb);
% t2=toc;

garis = [xa za xb zb]
%% Gambar
if xa>xb
    buffer_xa=xa;
    xa=xb;
    xb=buffer_xa;
end
if za>zb
    buffer_za=za;
    za=zb;
    zb=buffer_za;
end

XA = round(xa);
ZA = round(za);
XB = round(xb);
ZB = round(zb);

if XA==XB
    XB=XB+1;
end
if ZA==ZB
    ZB=ZB+1;
end

gambar_x = [XA (XA+XB)/2 XB];
gambar_z = [ZA (ZA+ZB)/2 ZB];
gambar = ones(2);

figure, imagesc(gambar_x,gambar_z,gambar)
colormap(parula(2)), axis image
hold on

for i = [1 3]
    plot([gambar_x(1) gambar_x(3)],[gambar_z(i) gambar_z(i)],'g');
    plot([gambar_x(i) gambar_x(i)],[gambar_z(1) gambar_z(3)],'g');
end
plot([gambar_x(1)-0.5 gambar_x(3)+0.5],[gambar_z(2) gambar_z(2)],'k');
p1=plot([gambar_x(2) gambar_x(2)],[gambar_z(1)-0.5 gambar_z(3)+0.5],'k');
% set(gcf, 'units','normalized','OuterPosition',[0.2 0.2 0.4 0.65])
p2=plot(garis([1 3]),garis([2 4]),'r');
legend([p1 p2],'Batas sel','Garis')
%% Membandingkan distance
d_fun = sum(d);
d_asli = sqrt((xa-xb)^2+(za-zb)^2);
disp(num2str([d_asli d_fun]))
