clc, clear all,close all
% Rekomendasi : Atur preferences agar bisa fold section
% Shortcut fold all : Ctrl + =
% Shortcut unfold all : Ctrl + Shift + =
% model tesseral

dobs = load('Zsortedfinal.txt');
dobs = reshape(dobs,[],1);

utm = load('UTM70.txt');
statx = round(utm(:,2),-3);
statx(15) = [];
statx1 = statx./1000;
statx2 = statx1 - 199;
% statx2(17) = 49;
% statx2(18) = 52;
% statx2(8) = 58;
% statx2(51) = 52;  
% statx2(68) = 2;
% statx2(45) = 30;
% statx2(44) = 24;
% statx2(31) = 60;
% statx2(15) = 40;
% statx2(26) = 37;
% statx2(10) = 18;
% statx2(28) = 43;
staty = round(utm(:,3),-3);
staty(15) = [];
staty1 = staty./1000;
staty2 = staty1 - 9360;
% staty2(6) = 35;
% staty2(25) = 25;
% staty2(8) = 34;
% staty2(57) = 15;
% staty2(13) = 32;
% staty2(68) = 19;
% staty2(44) = 19;
% staty2(15) = 31;
% staty2(26) = 29;
% staty2(31) = 27;
% staty2(10) = 30;
%% Pilihan
set(0,'DefaultFigureWindowStyle','normal')
Pilih.SaveGambar = 0;   % 1=saveas gambar ; 0=tidak saveas gambar
Pilih.Tempat = 'E:\TA\radifan taufik(terakhir)\FIX TA\ss\perturbasi\initial model ray lurus versi 2\'; %Lokasi penyimpanan gambar
Pilih.IF = 1;   % 1=Inversi ; 2=Forward
Pilih.display_log = 0;
Pilih.display_gambar = 1; % 0=Tidak ; 1=per-rec ; 2=per-sel

Indeks.fig = 0;
%% True Model, m0, dan Inv
Model.truelength = 10; %Dimensi Model (dalam m)
Model.trueint = 2; %Interval src dan rec (dalam m)
Model.sz = [53 87]; %Dimensi Model (dalam px)
Model.konv = Model.trueint/Model.truelength*max(Model.sz);
Model.h = 1000;
Model = model_checkerboard3(Model);

N.j = numel(Model.V); %Jumlah kolom pada kernel

% if Pilih.IF == 1 %Model.V0 & Eq.m0
    Inv.E = 10^-3; %Erms toleransi (Selisih data)
    Inv.iter = 12; %Iterasi maksimum
    Inv.konv = 10^-5; %Konvergensi model (Sementara belum dipake; Kalo model udah mendekati bener dicoba parameter ini)
    Inv.smoothing = 8; %Untuk velsmooth
    Inv.eps = 5*10^-2; %Faktor damping
    
    Pilih.display_logIter = 1; 
    Pilih.TipeInversi = 2; % 1=pinv ; 2=lsqr

%     [Model,Eq] = ModelAwal(Model, 500, 1000,N); 
    
      Model.V0 = load('v0fix.txt');
      Temp.savenama = 'Model Inversi';
%     Model.V0 = Model.V;
%     Model.V0(Model.V0==1000) = 1100;
%     Model.V0(Model.V0==500) = 600;
%     Model.V0(Model.V0==3000) = 3100;
    
%     Model.V0 = Model.V0';
    Eq.m0 = reshape(1./Model.V0,N.j,1);
    
    Eq_2D.m0 = reshape(Eq.m0,Model.sz);
% end
%% Source dan Receiver

SR.src_x = statx2;
% SR.src_x(9:68)=[];
SR.src_z = staty2;
% SR.src_z(9:68)=[];
SR.rec_x = statx2;
% SR.rec_x(17) = [];
SR.rec_z = staty2;
% SR.rec_z(17) = [];
Indeks.fig = Indeks.fig + 1;
figure (Indeks.fig)
set(gcf,'Units','Normalized','OuterPosition',[0.05 0.25 0.4217 0.6680])
if Pilih.IF==1 && Pilih.display_gambar==1
    set(gcf,'Units','Normalized','OuterPosition',[0.01 0.01 0.93 0.95])
    subplot(1,2,1)
end
plot_Model(Model)
set(gca,'ydir','reverse')
hold on
plot_SR(SR, 1.5, 1)
hold off
pause(0.01)

N.src = length(SR.src_x);
N.rec = length(SR.rec_x);
N.i = N.src*N.rec; %Jumlah baris atau jumlah data

if Pilih.IF~=1 && Pilih.SaveGambar == 1
    saveas(gca,[Pilih.Tempat Model.nama '_MODEL.jpg'])
end

%% Looping
Eq.m_asli = reshape(1./Model.V,[N.j,1]);
Eq.d_obs = zeros(N.i,1);
Eq.G = zeros(N.i,N.j);

if Pilih.IF == 2 %Forward
    Pilih.I = 0;
    [Eq,Temp,Ray]=DefineAllRaypath(Model, Eq, SR,Indeks, Pilih, N);


    disp '---------------------------------------------'
    disp ' ... Menghitung perbandingan hasil forward'
    
    Eq.d_matriks = reshape(Eq.d_obs, [N.src,N.rec]);
    Eq.d_forward = reshape(Eq.G * Eq.m_asli,[N.src, N.rec]);
    Eq.d_selisih = abs(Eq.d_forward - Eq.d_matriks);

end

if Pilih.IF == 1 %Forward ; Inversi dan Perturbasi
    Temp.E = 1;
    Temp.iter = 0;
    Temp.konv = 1;
    
%     Pilih.I = 1; %Mendapatkan d_obs
%     [Eq,~,~]=DefineAllRaypath(Model, Eq, SR,Indeks, Pilih, N); %Getting d_obs
    Eq.d_obs = dobs;
    Pilih.I = 2; %Mendapatkan d_kal dan G
    Eq.d_kal = zeros(N.i,1);
    
    if Pilih.display_gambar == 1 %Setting Figure Position and Size
        figure(2)
        set(gcf,'Units','Normalized','OuterPosition',[0.012 0.02 0.928 0.96])
    end

    while Temp.E>Inv.E && Temp.iter<Inv.iter %|| Temp.konv>Inv.konv
        Temp.iter = Temp.iter + 1;
        if Pilih.display_logIter == 1
            disp '---------------------------------------------'
            disp (['Iterasi ke-' num2str(Temp.iter)])
        end
        [Eq,~,Ray]=DefineAllRaypath(Model, Eq, SR,Indeks, Pilih, N);
        Indeks.TdkDilalui = find((sum(Eq.G))==0); %Yang tidak dilalui ray --> m tidak diperbarui --> ekstra-/intra- polasi dgn inpaintn
        Eq.delta_d = Eq.d_obs - Eq.d_kal ;
        Temp.E = sqrt(mean((Eq.delta_d).^2))*100; %Dalam persen ms
        Eq_2D.d_obs = reshape(Eq.d_obs,N.src,N.rec);
        Eq_2D.d_kal = reshape(Eq.d_kal,N.src,N.rec);

        if Pilih.display_gambar == 1 %Plot ray dan d_obs&d_kal
            figure(1), subplot (1,2,2)
            imagesc(Model.V0), title(['Model Inversi Iterasi ke-' num2str(Temp.iter)])
            axis image; colormap(gca,parula),colorbar, set(get(colorbar,'Title'),'String','Velocity (m/s)')
            figure(1), pause(0.01)
            if Pilih.SaveGambar == 1
                Temp.savenama = [Pilih.Tempat Model.nama '_iter-' num2str(Temp.iter) ' [1].jpg'];
                saveas(gca,Temp.savenama)
            end
            
            figure(2)
            subplot(1,2,1)
            imagesc(Model.V0), title(['Iterasi ke-' num2str(Temp.iter)])
            axis image; colorbar, set(get(colorbar,'Title'),'String','Velocity (m/s)')
            hold on, plot_SR(SR, 1.5, 0)
            
            Temp.src_ke = 0;
            Temp.warna = 1;
            while Temp.src_ke < N.src %Plot ray 
                Temp.src_ke = Temp.src_ke + 1;
                Indeks.fig = Indeks.fig + 1;
                Temp.rec_ke = 0;
                while Temp.rec_ke < N.rec 
                    Temp.rec_ke = Temp.rec_ke + 1;
                    Temp.KoordRay = Ray.KoordRay{Temp.src_ke,Temp.rec_ke};
                    subplot(1,2,1)
                    plot(Temp.KoordRay(:,1),Temp.KoordRay(:,2),'k', 'LineWidth', 1.5)
                end
            end
            subplot('Position',[0.57,0.41,0.38,0.33]) %Plot d_obs&d_kal
            plot(Eq.d_obs,'-ob','MarkerFaceColor','b','MarkerSize',3), hold on
            plot(Eq.d_kal,'-ok','MarkerFaceColor','k','MarkerSize',3)
            axis tight
            xlabel('Data ke-'),ylabel('Time (s)'), title(['Iterasi ke-' num2str(Temp.iter)])
            a=legend({'d obs','d kal'});
            set(a,'Position',[0.88, 0.64, 0.063, 0.0535])
            suptitle (['Iterasi ke-' num2str(Temp.iter) ' [Erms = ' num2str(Temp.E) '%]'])
            pause(0.01) %Biar gambar ke display dulu, baru iterasi lagi
            
            if Pilih.SaveGambar == 1
                Temp.savenama = [Pilih.Tempat Model.nama '_iter-' num2str(Temp.iter) ' [2].jpg'];
                saveas(gca,Temp.savenama)
            end
        end
        if Pilih.display_logIter == 1
            disp (['E_rms : ' num2str(Temp.E) '%'])
        end
        error(Temp.iter) = Temp.E;
        if Pilih.TipeInversi == 1 %Menghitung Eq.delta_m dengan metode inversi pinv atau lsqr
            Eq.delta_m = pinv(Eq.G) * Eq.delta_d; %Gimana cara tambahin faktor damping ?
        elseif Pilih.TipeInversi == 2
            Eq.A = (Eq.G'*Eq.G);
            Eq.A = Eq.A + (Inv.eps^2*eye(size(Eq.A)));
            Eq.b = Eq.G'*Eq.delta_d;
            Eq.delta_m = lsqr(Eq.A, Eq.b);
        end
        Eq_2D.delta_m = reshape(Eq.delta_m,Model.sz);
        Eq_2D.delta_m = 1./velsmooth(1./Eq_2D.delta_m, 1, 1, 1*Inv.smoothing);
        Eq_2D.m_baru = Eq_2D.m0 + Eq_2D.delta_m;
        Eq_2D.m_baru(Indeks.TdkDilalui) = nan;
        Eq_2D.m_baru = inpaintn(Eq_2D.m_baru);
%         Eq_2D.m_baru(Eq_2D.m_baru>0.002) = 0.002;
%         Eq_2D.m_baru(Eq_2D.m_baru<0) = 1;
        Eq_2D.m0 = Eq_2D.m_baru;
        Eq.m0 = reshape(Eq_2D.m0,N.j,1);
        Model.V0 = 1./Eq_2D.m_baru;
        
        velcrop{Temp.iter} = Model.V0(12:40, 12:60);
        dray = Eq.G~=0;
        raycov = sum(dray);
        raycov = reshape(raycov,53,87);
        saveray = raycov;
        pathdir = fileparts('E:\TA\radifan taufik(terakhir)\FIX TA\ss\perturbasi\initial model ray lurus versi 2\raycov\');
        filename = strcat('raypath coverage iterasi ke ', num2str(Temp.iter), '.txt');
        txtfile = fullfile(pathdir,filename);
        save(txtfile, 'saveray', '-ASCII');
        %         Model.V0(Model.V0<500) = 500;
    end
end
%%
for i=1:12
     saveray = velcrop{i};
        pathdir = fileparts('E:\TA\radifan taufik(terakhir)\FIX TA\ss\perturbasi\initial model ray lurus versi 2\velcrop\');
        filename = strcat('velocity crop iterasi ke ', num2str(i), '.txt');
        txtfile = fullfile(pathdir,filename);
        save(txtfile, 'saveray', '-ASCII');
end
