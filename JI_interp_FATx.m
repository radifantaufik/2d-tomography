function [model]=JI_interp_FATx(x,z,model,dm,Ray,inv_param)
    dm=reshape(dm,size(model.initial));
    dm=1./velsmooth(1./dm,x.coor_m,z.coor_m,((x.dx+z.dz)/2)*(inv_param.interp_smoothing));
    deltam=nan(size(model.initial));
    model_temp=deltam;
    model_temp(Ray.idx_boundary)=model.initial(Ray.idx_boundary)+dm(Ray.idx_boundary);

    model.initial=reshape(model_temp,size(model.initial));
    model.initial=inpaintn(model.initial);
end