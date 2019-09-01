function [Eq,Temp,Ray,Indeks]=DefineAllRaypath(Model,Eq,SR,Indeks,Pilih,N)
% Function ini untuk menelusuri raypath untuk semua rec dan semua src.
% Looping penelusuran raypath per-rec per-src dilakukan dengan function
% TracingBack.m
%
% Output
%     - Eq.d_kal atau Eq.d_obs
%     - Eq.d_matriks 
%     - Eq.d_forward
%     - Eq.d_selisih
%     - Eq.G (Pilih.IF=1)

if Pilih.display_log == 0 
    if (Pilih.IF==2) %' ... Sedang menelusuri raypath ...'
        disp '---------------------------------------------'
        disp '... Forward modelling dan menelusuri raypath'
    elseif Pilih.I==1
        disp '---------------------------------------------'
        disp '... Menghitung d_obs'
    end
end

Temp.src_ke = 0;
Indeks.i = 0;
while Temp.src_ke < N.src % Forward (per-src) & Telusur raypath (per-rec)
    Temp.src_ke = Temp.src_ke + 1;
    Temp.XS = round(SR.src_x(Temp.src_ke));
    Temp.ZS = round(SR.src_z(Temp.src_ke));
    
    Temp.time = eikonal2D_edited(Model,Temp,Pilih);
    [Temp.teta,Temp.ket] = Cal_Teta(Temp.time,Model);
    
    Ray.time_2D {Temp.src_ke,1} = Temp.time;
    Ray.teta {Temp.src_ke,1} = Temp.teta;
    
    if Pilih.IF == 2 && Pilih.display_gambar ~=0 %Plot travel time (2D)
        Indeks.fig = Indeks.fig + 1;

        figure(Indeks.fig)
%         set(gcf,'Units','Normalized','OuterPosition',[0.01 0.04 0.67 0.96])
%         subplot(2,2,[1 3])
        plot_TimeForward(Model, Temp, Model.V0)
        hold on
%         plot_KonturWavefront(Model,Ray.time_2D{Temp.src_ke}, 150)
%         hold on
%         plot_GridSel (Model, 'k','w')
%         hold on
        plot_SR(SR, 1.5,0)
    end
    
    Temp.rec_ke = 0;
    while Temp.rec_ke < N.rec %Telusur raypath (per-rec)
        Indeks.i = Indeks.i + 1;
        
        Temp.rec_ke = Temp.rec_ke + 1;
        Temp.XR = SR.rec_x(Temp.rec_ke);
        Temp.ZR = SR.rec_z(Temp.rec_ke);
        if Pilih.IF == 2 && Pilih.display_log == 1 %Keterangan src dan rec ke berapa
            clc
            disp '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
            disp '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
            disp (['   [src rec] = ' num2str([Temp.src_ke Temp.rec_ke])])
            disp '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
            disp '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
        end
        disp('rec = '); disp(Temp.rec_ke)
        disp('src = '); disp(Temp.src_ke)
        [Temp] = TracingBack (Model,N,Temp,Pilih);
%         if Temp.gagal == 1
%             continue
%         end
        if Pilih.I ~= 2 %Namanya d_obs atau d_kal ?
            Eq.d_obs(Indeks.i) = Temp.d;
        else 
            Eq.d_kal(Indeks.i) = Temp.d; %Khusus Pilih.I==2 namanya d_kal
        end
        Eq.G(Indeks.i,:) = Temp.G;
        Ray.KoordRay{Temp.src_ke,Temp.rec_ke} = Temp.KoordRay;
       
        if Pilih.IF == 2 && Pilih.display_gambar == 1 %Plot ray per rec-src
            plot(Temp.KoordRay(:,1),Temp.KoordRay(:,2), 'LineWidth', 1.5,'color','black')
            pause(0.1)
        end
        
        if Pilih.IF == 2 && Pilih.display_gambar == 2 
            if Temp.src_ke==3 && Temp.rec_ke==10
                pause
            else
                pause(1)
            end
        end
    end
%     pause
end

if Pilih.IF == 2 %Hitung Selisih dan plot (if Pilih.display_gambar == 1)
    Eq.d_matriks = reshape(Eq.d_obs, [N.src,N.rec]);
    Eq.d_forward = reshape(Eq.G * Eq.m_asli,[N.src, N.rec]);
    Eq.d_selisih = 1000*abs(Eq.d_forward - Eq.d_matriks);
    if Pilih.display_gambar == 1
        Temp.src_ke = 0;
        while Temp.src_ke < N.src
            Temp.src_ke = Temp.src_ke + 1;
            figure(Temp.src_ke+1)
            subplot(2,2,2)
            plot_BandingForward(Model,Eq,Temp,N)
            subplot(2,2,4)
            plot_SelisihForward(Model,Eq,Temp,N,10)
            pause(0.01)
            
            if Pilih.SaveGambar == 1
                Temp.savenama = [Pilih.Tempat Model.nama '_source-' num2str(Temp.src_ke) '.jpg'];
                saveas(gca,Temp.savenama)
            end
        end
    end
end

if Pilih.I == 1 %Hapus structure Eq.G
    Eq = rmfield(Eq,{'G'}); %Remove field
end
if Pilih.I~=2 %Display selesai
    disp 'Selesai.'
end