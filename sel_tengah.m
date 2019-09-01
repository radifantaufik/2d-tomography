function [x,z,T,kondisi]=sel_tengah(xa,za,model_sz,t)
kiri=floor(xa);
kanan=ceil(xa);
atas=floor(za);
bawah=ceil(za);
x=[kiri kanan kiri kanan]';
z=[atas atas bawah bawah]';
indsel=sub2ind(model_sz,z,x);
kondisi='  -  '; 

if (mod(xa,1)==0) && (mod(za,1)~=0) %sisi kiri/kanan
    xt=xa-1:xa+1;
    zt=[floor(za) ceil(za)];
else %sisi atas/bawah
    xt=[floor(xa) ceil(xa)];
    zt=za-1:za+1;
end

if xt(end)>model_sz(2) %Jika melebihi maximum pixel x
    xt(end)=[]; end %Mengeliminasi titik yang melebihi px max
if zt(end)>model_sz(1) %Jika melebihi maximum pixel z
    zt(end)=[]; end
if xt(1)<1 %Jika kurang dari minimum pixel z
    xt(1)=[];end
if zt(1)<1 %Jika kurang dari minimum pixel 
    zt(1)=[];end

[Xt,Zt]=meshgrid(xt,zt);
Xt=reshape(Xt,[numel(Xt),1]); 
Zt=reshape(Zt,[numel(Zt),1]);
XZt_ind=sub2ind(model_sz,Zt,Xt);
T_sur = t(XZt_ind); %Time at the grid point surrounding point a

%Interpolasi t di titik a
F=scatteredInterpolant(Xt,Zt,T_sur);
T=F(xa,za);
