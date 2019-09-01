function [x,z,T,kondisi]=sel_sisi(xa,za,model_sz,t)
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
% disp(['ta = ' num2str(T)])

dt=T-T_sur;
% disp ([Xt Zt T_sur dt])
inddtmin=find(rem(dt,1)>0);
inddtmin=find(dt==min(dt(inddtmin)));

if numel(inddtmin)>1
    inddtmin=inddtmin(1);
end

% dtmin=min(dt);
Tmin=T_sur(inddtmin);
Xmin=Xt(inddtmin);
Zmin=Zt(inddtmin);
dxdz=[Xmin Zmin]-[xa za];
% disp(['tmin : ' num2str([Xmin Zmin dtmin])])
if numel(Xt)>4     
    
    if dxdz(1)==0 %sisi kiri/kanan
        tmin=min(T_sur([1 2 5 6]))
        xmin=Xt(find(T_sur==tmin))
        if xmin<xa %Ke kiri 
            pilih=[1 3 2 4];
            kondisi='kanan';
        else %Ke kanan
            pilih=[3 5 4 6];
            kondisi='kiri ';
        end
    elseif dxdz(1)==-1
        pilih=[1 3 2 4];
        kondisi='kanan';
    elseif dxdz(1)==1
        pilih=[3 5 4 6];
        kondisi='kiri ';
    elseif dxdz(2)==0 %sisi atas/bawah
        tmin=min(T_sur([1 3 4 6]));
        zmin=Zt(find(T_sur==tmin))
        if zmin<za %Ke atas 
            pilih=[1 4 2 5];
            kondisi='bawah';
        else %Ke bawah
            pilih=[2 5 3 6];
            kondisi='atas ';
        end
    elseif dxdz(2)==-1
        pilih=[1 4 2 5];
        kondisi='bawah';
    elseif dxdz(2)==1
        pilih=[2 5 3 6];
        kondisi='atas ';
    end
end

if numel(Xt)==4
    pilih=[1 3 2 4];
    if numel(find(Xt==1))>0 %Mepet batas kiri
        kondisi='kiri ';
    elseif numel(find(Xt==model_sz(2)))>0 %Mepet batas kanan
        kondisi='kanan';
    elseif numel(find(Zt==1))>0 %Mepet batas atas
        kondisi='atas ';
    elseif numel(find(Zt==model_sz(1)))>0 %Mepet batas bawah
        kondisi='bawah';
    end
end
    
x=Xt(pilih);
z=Zt(pilih);