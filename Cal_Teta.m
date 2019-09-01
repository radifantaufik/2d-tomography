function [teta,ket] = Cal_Teta (t, model)

n=0;
dtdx=zeros(size(t,1)-1,size(t,2)-1);
dtdz=dtdx; teta=dtdx;
ket = '          ';
for i=1:size(t,2)-1 %Menghitung teta
    for j=1:size(t,1)-1
        n=n+1;
        dtdx(n)=((t(j,i+1)+t(j+1,i+1))-(t(j,i)+t(j+1,i)))/(2*model.h); % kanan-kiri
        dtdz(n)=((t(j+1,i)+t(j+1,i+1))-(t(j,i)+t(j,i+1)))/(2*model.h); % bawah-atas

        teta(n)=atand(dtdz(n)/dtdx(n));
        if (dtdx(n)<0 && dtdz(n)>0) % teta=(90,180)
            teta(n)=teta(n)+180; 
            ket(n,:)='K2 -> +180';
        elseif (dtdx(n)>0 && dtdz(n)<0) %teta=(270,360)
            teta(n)=360+teta(n);  
            ket(n,:)='K4 -> 360+';
        elseif (dtdx(n)<0 && dtdz(n)<0) %teta={180,270)
            teta(n) = teta(n)+180;
            ket(n,:) = 'K3 -> +180';
        else
            ket(n,:)='K1 -> none';
        end
        
        teta(n)=teta(n)+180;
        if teta(n)>=360 %Menyesuaikan nilai teta untuk teta>360
            teta(n)=teta(n)-360; 
        end
    end
end 