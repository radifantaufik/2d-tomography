function [Temp] = TracingBack (model,N,Temp,Pilih)
% Function ini untuk merunut atau menelusuri raypath dari 1 receiver ke
% 1 source. Penelusuran ini dilakukan dari posisi rec hingga ke src.
% 
% Output :
%     - Temp.d        : [1 x 1]
%     - Temp.G        : [1 x N.j]
%     - Temp.KoordRay : [tergantung melewati berapa banyak sel]
%
% Dibuat berdasarkan referensi 
% "Two-Dimensional Tomographic Inversion With Finite-Difference Traveltimes"
% Oldenburg (1993)

if Temp.XR == Temp.XS && Temp.ZR == Temp.ZS
    Temp.d = 0;
    Temp.G = zeros(1,N.j);
    Temp.KoordRay = [Temp.XR Temp.ZR];
else 
    xa = Temp.XR;
    za = Temp.ZR;

    %1. Penentuan sel dan kondisi awal di (XR,ZR)
    if (mod(xa,1)==0) && (mod(za,1)==0) %Tepat di grid point
        [x,z,T,kondisi] = sel_titik_a (xa,za,model.sz,Temp.time);
    elseif (mod(xa,1)~=0) && (mod(za,1)~=0) %Di tengah sel
        [x,z,T,kondisi] = sel_tengah(xa,za,model.sz,Temp.time);
    else %Di sisi sel kiri/kanan/atas/bawah
        [x,z,T,kondisi] = sel_sisi(xa,za,model.sz,Temp.time);
    end
    Temp.d = T; %d_obs

    %2. Perunutan ray
    ind_b = 1;
    X = xa; % X dan Z nantinya akan menjadi vektor yang berisi
    Z = za; % titik-titik raypath pada setiap sel.
    xb = xa; %xb dan zb adalah titik akhir raypath pada setiap sel. 
    zb = za; %Nilainya berubah2 setiap iterasi sel.
    Temp.G = zeros(1,N.j);
    while xb~=Temp.XS || zb~=Temp.ZS %Iterasi pencarian ray dilakukan hingga mencapai koordinat source
        ind_b = ind_b+1;
%         if ind_b > 5000;
%             disp(Temp.rec_ke)
%         end

        [xb,zb,~,x2,z2,kondisi2,ket] = raypath(x,z,xa,za,Temp,kondisi,model.sz);
        X(ind_b,1) = xb;
        Z(ind_b,1) = zb;
        
        if xa~=xb || za~=zb %rayline (Membuat matriks G)
            [pilih_sel,~,r] = rayline(xa,za,xb,zb);
            r = r*model.h;
            for i = 1:length(r)
                ind_G = sub2ind(model.sz,pilih_sel(i,2),pilih_sel(i,1));
                Temp.G(ind_G) = Temp.G(ind_G) + r(i);
            end
        end

        if Pilih.display_log==1 %&& Temp.src_ke==9 && Temp.rec_ke==1 %&& Pilih.IF==2
            ind_teta = sub2ind(model.sz-1,z(1),x(1));
            ind_teta2 = sub2ind(model.sz-1,z2(1),x2(1));
            disp '========================================'
            disp (['Kondisi : ' kondisi])
            disp (['teta = ' num2str(Temp.teta(ind_teta))])
            disp (['Keterangan teta = ' Temp.ket(ind_teta,:)])
            disp (ket)
            disp '----------------------------'
            disp 'Titik A dan B' 
            disp (num2str([xa xb;za zb]))
            disp '----------------------------'
            disp 'sel 1'
            disp (num2str([x';z']))
            disp '----------------------------'
            disp 'sel 2'
            disp (num2str([x2';z2']))
            disp '----------------------------'
            disp (['Kondisi 2 : ' kondisi2])
            disp (['Teta 2 : ' num2str(Temp.teta(ind_teta2))])
            disp (['Keterangan teta 2 = ' Temp.ket(ind_teta2,:)])
            disp '----------------------------'
            disp 'Pilih Sel'
            disp (num2str(pilih_sel))
            pause(0.1)
        end

        if Pilih.display_gambar == 2 %Plot ray per sel
            plot([xa xb],[za zb],'-','LineWidth',1.5)
            axis([min([xa xb])-2 max([xa xb])+2 min([za zb])-2 max([za zb])+2])
%             pause 
        end

        x = x2; z = z2; xa = xb; za = zb;
        kondisi = kondisi2;
    end
    Temp.KoordRay = [X Z];
end