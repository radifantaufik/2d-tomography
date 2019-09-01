function Model = model_checkerboard (Model)

Model.nama = 'Initial Model checkerboard';
v = [500 1000];
ms = ' m/s';
Model.keterangan = [num2str(v') repmat(ms,2,1)];
kecgrid = ones(Model.sz)*500;
for i=1:5;
    for j=1:5
        kecgrid(i,j)=1000;
        kecgrid(i,10+j)=1000;
        kecgrid(i,20+j)=1000;
        kecgrid(i,30+j)=1000;
        kecgrid(i,40+j)=1000;
        kecgrid(i,50+j)=1000;
        kecgrid(i,60+j)=1000;
        kecgrid(i,70+j)=1000;
        kecgrid(i,80+j)=1000;
    end   
end
for i=6:10;
    for j=6:10
        kecgrid(i,j)=1000;
        kecgrid(i,10+j)=1000;
        kecgrid(i,20+j)=1000;
        kecgrid(i,30+j)=1000;
        kecgrid(i,40+j)=1000;
        kecgrid(i,50+j)=1000;
        kecgrid(i,60+j)=1000;
        kecgrid(i,70+j)=1000;
        kecgrid(i,80+j)=1000;
    end
end
for i=11:15;
    for j=1:5
        kecgrid(i,j)=1000;
        kecgrid(i,10+j)=1000;
        kecgrid(i,20+j)=1000;
        kecgrid(i,30+j)=1000;
        kecgrid(i,40+j)=1000;
        kecgrid(i,50+j)=1000;
        kecgrid(i,60+j)=1000;
        kecgrid(i,70+j)=1000;
        kecgrid(i,80+j)=1000;
    end
end
for i=16:20;
    for j=6:10
        kecgrid(i,j)=1000;
        kecgrid(i,10+j)=1000;
        kecgrid(i,20+j)=1000;
        kecgrid(i,30+j)=1000;
        kecgrid(i,40+j)=1000;
        kecgrid(i,50+j)=1000;
        kecgrid(i,60+j)=1000;
        kecgrid(i,70+j)=1000;
        kecgrid(i,80+j)=1000;
    end
end
for i=21:25;
    for j=1:5;
        kecgrid(i,j)=1000;
        kecgrid(i,10+j)=1000;
        kecgrid(i,20+j)=1000;
        kecgrid(i,30+j)=1000;
        kecgrid(i,40+j)=1000;
        kecgrid(i,50+j)=1000;
        kecgrid(i,60+j)=1000;
        kecgrid(i,70+j)=1000;
        kecgrid(i,80+j)=1000;
    end
end
for i=26:30;
    for j=6:10
        kecgrid(i,j)=1000;
        kecgrid(i,10+j)=1000;
        kecgrid(i,20+j)=1000;
        kecgrid(i,30+j)=1000;
        kecgrid(i,40+j)=1000;
        kecgrid(i,50+j)=1000;
        kecgrid(i,60+j)=1000;
        kecgrid(i,70+j)=1000;
        kecgrid(i,80+j)=1000;
    end
end
for i=31:35;
    for j=1:5;
        kecgrid(i,j)=1000;
        kecgrid(i,10+j)=1000;
        kecgrid(i,20+j)=1000;
        kecgrid(i,30+j)=1000;
        kecgrid(i,40+j)=1000;
        kecgrid(i,50+j)=1000;
        kecgrid(i,60+j)=1000;
        kecgrid(i,70+j)=1000;
        kecgrid(i,80+j)=1000;
    end
end
for i=36:40;
    for j=6:10
        kecgrid(i,j)=1000;
        kecgrid(i,10+j)=1000;
        kecgrid(i,20+j)=1000;
        kecgrid(i,30+j)=1000;
        kecgrid(i,40+j)=1000;
        kecgrid(i,50+j)=1000;
        kecgrid(i,60+j)=1000;
        kecgrid(i,70+j)=1000;
        kecgrid(i,80+j)=1000;
    end
end
for i=41:45;
    for j=1:5;
        kecgrid(i,j)=1000;
        kecgrid(i,10+j)=1000;
        kecgrid(i,20+j)=1000;
        kecgrid(i,30+j)=1000;
        kecgrid(i,40+j)=1000;
        kecgrid(i,50+j)=1000;
        kecgrid(i,60+j)=1000;
        kecgrid(i,70+j)=1000;
        kecgrid(i,80+j)=1000;
    end
end
for i=46:50;
    for j=6:10
        kecgrid(i,j)=1000;
        kecgrid(i,10+j)=1000;
        kecgrid(i,20+j)=1000;
        kecgrid(i,30+j)=1000;
        kecgrid(i,40+j)=1000;
        kecgrid(i,50+j)=1000;
        kecgrid(i,60+j)=1000;
        kecgrid(i,70+j)=1000;
        kecgrid(i,80+j)=1000;
    end
end
for i=51:53;
    for j=1:5;
        kecgrid(i,j)=1000;
        kecgrid(i,10+j)=1000;
        kecgrid(i,20+j)=1000;
        kecgrid(i,30+j)=1000;
        kecgrid(i,40+j)=1000;
        kecgrid(i,50+j)=1000;
        kecgrid(i,60+j)=1000;
        kecgrid(i,70+j)=1000;
        kecgrid(i,80+j)=1000;
    end
end

kecgrid(:,88:90) = [];
Model.V = kecgrid;

