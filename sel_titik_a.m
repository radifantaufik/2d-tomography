function [x,z,T,kondisi]=sel_titik_a (xa,za,model_sz,t)
% Kegunaan : Memilih sel dengan kondisi titik a (datang nya ray) tepat 
% di titik grid point.
 
% Output : Koordinat dan time sel

%Butuh function : sel_titik_b.m

% xa dan za = titik lokasi receiver (harus bilangan bulat positif)
% xt dan za = koordinat di kiri, kanan, atas, bawah dari receiver titik a
% Xt dan Zt = Subscript semua titik di sekeliling a
% XZt_ind = Index semua titik di sekeliling a
% T_sur = Time di titik sekeliling a (T surrounding)
% x,z,T = koordinat dan time grid point di sekeliling sel
% kondisi = titik a merepresentasikan datangnya ray dari arah mana relatif
% thd sel. Pada kondisi a tepat di titik, diasumsikan kondisi hanya 'kiri'
% atau 'kanan'

xmax=model_sz(2); 
zmax=model_sz(1);

xt=xa-1:xa+1; % titik di kiri dan kanan xa
zt=za-1:za+1; % titik di atas dan bawah za
if xt(end)>xmax %Jika melebihi maximum pixel x
    xt(end)=[]; end %Mengeliminasi titik yang melebihi px max
if zt(end)>zmax %Jika melebihi maximum pixel z
    zt(end)=[]; end
if xt(1)<1 %Jika kurang dari minimum pixel z
    xt(1)=[];end
if zt(1)<1 %Jika kurang dari minimum pixel 
    zt(1)=[];end

[Zt,Xt]=meshgrid(zt,xt); %Semua titik di sekeliling a dan a itu sendiri
Xt=reshape(Xt,[numel(Xt),1]); 
Zt=reshape(Zt,[numel(Zt),1]);
cari=find((Xt==xa).*(Zt==za)); %Mengeliminasi titik a
XZt_ind=sub2ind(model_sz,Zt,Xt);
T_sur = t(XZt_ind); %Time at the grid point surrounding point a

if numel(Xt)>4
%     Xt(cari)=[];
%     Zt(cari)=[]; %Sehingga didapatkan titik di sekeliling a saja
%     T_sur(cari)=[];
    
    dt=t(za,xa)-T_sur; %Selisih time positif dan kecil -> kesitu dulu
    inddtmin=find(rem(dt,1)>0); %Yang lebih dulu dari a
    inddtmin=find(dt==min(dt(inddtmin))); %Yang paling dekat dengan a
    inddtmin=inddtmin(1);
    dxdz=[Xt(inddtmin) Zt(inddtmin)]-[xa za];
%     [xa za t(za,xa)]
    [Xt Zt T_sur dt];

    if dxdz==[0 -1] %XZT_ind ada di atas titik a
        dtx1=dt(find((Xt==Xt(inddtmin)-1).*(Zt==Zt(inddtmin))));
        dtx3=dt(find((Xt==Xt(inddtmin)+1).*(Zt==Zt(inddtmin))));
        
        if dtx1<=0
            dtx1=[];end
        if dtx3<=0
            dtx3=[];end
        
        if (isempty(dtx1)==0)&&(isempty(dtx3)==0)
            if dtx1<dtx3
                a_di=4;
            else a_di=3; end
        elseif (isempty(dtx1)==0)&&(isempty(dtx3)==1) %Pasti ke kiri
            a_di=4;
        elseif (isempty(dtx1)==1)&&(isempty(dtx3)==0) %Pasti ke kanan
            a_di=3;
        end
    elseif dxdz==[0 1] %XZT_ind ada di bawah titik a
        dtx1=dt(find((Xt==Xt(inddtmin)-1).*(Zt==Zt(inddtmin))));
        dtx3=dt(find((Xt==Xt(inddtmin)+1).*(Zt==Zt(inddtmin))));
        
        if dtx1<=0
            dtx1=[];end
        if dtx3<=0
            dtx3=[];end
        
        if (isempty(dtx1)==0)&&(isempty(dtx3)==0)
            if dtx1<dtx3
                a_di=2;
            else
                a_di=1;
            end
        elseif (isempty(dtx1)==0)&&(isempty(dtx3)==1) %Pasti ke kiri
            a_di=2;
        elseif (isempty(dtx1)==1)&&(isempty(dtx3)==0) %Pasti ke kanan
            a_di=1;
        end
    elseif dxdz==[1 -1]
        a_di=3;
    elseif dxdz==[1 1]
        a_di=1;
    elseif dxdz==[-1 -1]
        a_di=4;
    elseif dxdz==[-1 1]
        a_di=2;
    elseif dxdz==[-1 0]
        dtz1=dt(find((Zt==Zt(inddtmin)-1).*(Xt==Xt(inddtmin))));
        dtz3=dt(find((Zt==Zt(inddtmin)+1).*(Xt==Xt(inddtmin))));
        
        if dtz1<=0
            dtz1=[];end
        if dtz3<=0
            dtz3=[];end
        
        if (isempty(dtz1)==0)&&(isempty(dtz3)==0)
            if dtz1<dtz3
                a_di=4;
            else a_di=2; 
            end
        elseif (isempty(dtz1)==0)&&(isempty(dtz3)==1) %Pasti ke atas
            a_di=4;
        elseif (isempty(dtz1)==1)&&(isempty(dtz3)==0) %Pasti ke bawah
            a_di=2;
        end
    elseif dxdz==[1 0]
        dtz1=dt(find((Zt==Zt(inddtmin)-1).*(Xt==Xt(inddtmin))));
        dtz3=dt(find((Zt==Zt(inddtmin)+1).*(Xt==Xt(inddtmin))));
        
        if dtz1<=0
            dtz1=[];end
        if dtz3<=0
            dtz3=[];end
        
        if (isempty(dtz1)==0)&&(isempty(dtz3)==0)
            if dtz1<dtz3
                a_di=3;
            else
                a_di=1;
            end
        elseif (isempty(dtz1)==0)&&(isempty(dtz3)==1) %Pasti ke atas
            a_di=3;
        elseif (isempty(dtz1)==1)&&(isempty(dtz3)==0) %Pasti ke bawah
            a_di=1;
        end
    end
%     Xt(end+1)=xa; Zt(end+1)=za; T_sur(end+1)=t(xa,za);
end

if numel(Xt)==4
    a_di=find((Xt==xa).*(Zt==za));
end
% disp(['a_di : ' num2str(a_di)])
% disp(['koord a : ' num2str([xa za])])

[x,z,kondisi]=sel_titik_b(a_di,xa,za); % Klo pake raypath_02.m
T = t(za,xa);