function NARR_SEUS_WindAdj_3hr1km_NN(iyear)
% Based on known wind profile, retrieving friction velocity at the original
% 32km resolution; Then, adjusting friction velocity to 1km. 
%--------------------------------------------------------------------------
% By Jing Tao, Duke University
% Last updated: 10/10/2013
%--------------------------------------------------------------------------

global clat clon

basinstr='SE_US';Sres=1000;%Spatial Resolution
r1=160;r2=190;c1=230;c2=260;

%--------------------------------------------------------------------------
data_dir='/home3/jt85/HMT-SEUS/Mat/SEUS_NARR_3hr1km_UTM/';
geo_dir='/home/jt85/HMT-SEUS/Program/Geo/';
home_dir='/home/jt85/HMT-SEUS/Program/';

load([geo_dir,'NARR_SFCR.mat']);SFCR=NARR_SFCR(r1:r2,c1:c2);
load([geo_dir,'NARR_SGH_Bilin_Z.mat']);elev=topo(r1:r2,c1:c2);

load([geo_dir,'NARR_Coord_UTM.mat']);%bouxc,bouyc
LON=bouxc;LAT=bouyc;
load([geo_dir,'Coord_',basinstr,'_',num2str(Sres),'m_UTM.mat']);%bouxc,bouyc
clon=bouxc;clat=bouyc;

s=size(LAT);
displacementH=rand(s);roughnessL=rand(s); Ustar=rand(s);
   
oudir=[data_dir,'/',int2str(iyear),'/'];cd(oudir);
dirdata=dir;nrec=length(dirdata)-2; %length(dirdata) includes '.' and '..'
for i=1:nrec
    displacementH(:,:)=NaN; roughnessL(:,:)=NaN; Ustar(:,:)=NaN;
    fnmm=dirdata(i+2).name;load([oudir,fnmm,'/NARRgridVar.mat']);
    
    wind10m=sqrt(NARRgrid_windEW10m(r1:r2,c1:c2).^2+NARRgrid_windNS10m(r1:r2,c1:c2).^2);
    wind30m=sqrt(NARRgrid_windEW30m(r1:r2,c1:c2).^2+NARRgrid_windNS30m(r1:r2,c1:c2).^2);
    wind800mb=sqrt(NARRgrid_windU800(r1:r2,c1:c2).^2+NARRgrid_windV800(r1:r2,c1:c2).^2);
    wind825mb=sqrt(NARRgrid_windU825(r1:r2,c1:c2).^2+NARRgrid_windV825(r1:r2,c1:c2).^2);
    wind850mb=sqrt(NARRgrid_windU850(r1:r2,c1:c2).^2+NARRgrid_windV850(r1:r2,c1:c2).^2);
    wind875mb=sqrt(NARRgrid_windU875(r1:r2,c1:c2).^2+NARRgrid_windV875(r1:r2,c1:c2).^2);
    wind900mb=sqrt(NARRgrid_windU900(r1:r2,c1:c2).^2+NARRgrid_windV900(r1:r2,c1:c2).^2);
    wind925mb=sqrt(NARRgrid_windU925(r1:r2,c1:c2).^2+NARRgrid_windV925(r1:r2,c1:c2).^2);
    wind950mb=sqrt(NARRgrid_windU950(r1:r2,c1:c2).^2+NARRgrid_windV950(r1:r2,c1:c2).^2);
    wind975mb=sqrt(NARRgrid_windU975(r1:r2,c1:c2).^2+NARRgrid_windV975(r1:r2,c1:c2).^2);
    wind1000mb=sqrt(NARRgrid_windU1000(r1:r2,c1:c2).^2+NARRgrid_windV1000(r1:r2,c1:c2).^2);
 
    %GHz_convert.m is included in ../ElevationCorrection/
    gmheight800=GHz_convert(NARRgrid_gpheight800(r1:r2,c1:c2),LAT*pi/180);
    gmheight825=GHz_convert(NARRgrid_gpheight825(r1:r2,c1:c2),LAT*pi/180);
    gmheight850=GHz_convert(NARRgrid_gpheight850(r1:r2,c1:c2),LAT*pi/180);
    gmheight875=GHz_convert(NARRgrid_gpheight875(r1:r2,c1:c2),LAT*pi/180);
    gmheight900=GHz_convert(NARRgrid_gpheight900(r1:r2,c1:c2),LAT*pi/180);
    gmheight925=GHz_convert(NARRgrid_gpheight925(r1:r2,c1:c2),LAT*pi/180);
    gmheight950=GHz_convert(NARRgrid_gpheight950(r1:r2,c1:c2),LAT*pi/180);
    gmheight975=GHz_convert(NARRgrid_gpheight975(r1:r2,c1:c2),LAT*pi/180);
    gmheight1000=GHz_convert(NARRgrid_gpheight1000(r1:r2,c1:c2),LAT*pi/180);

    for ii=1:s(1)
    for jj=1:s(2)
        if ~isnan(LAT(ii,jj))
        height=[elev(ii,jj)+10,elev(ii,jj)+30,gmheight1000(ii,jj),gmheight975(ii,jj),gmheight950(ii,jj),gmheight925(ii,jj),gmheight900(ii,jj),gmheight875(ii,jj),gmheight850(ii,jj),gmheight825(ii,jj),gmheight800(ii,jj)];
        Wind=[wind10m(ii,jj),wind30m(ii,jj),wind1000mb(ii,jj),wind975mb(ii,jj),wind950mb(ii,jj),wind925mb(ii,jj),wind900mb(ii,jj),wind875mb(ii,jj),wind850mb(ii,jj),wind825mb(ii,jj),wind800mb(ii,jj)];
        tmp=height(3:end)-height(2);idx=find(tmp>=20);
        if ~isempty(idx)
            lis=[1,2,(idx(1)+2):length(height)];
            z0=SFCR(ii,jj);roughnessL(ii,jj)=z0;
            Upro=Wind(lis);Hpro=height(lis)-elev(ii,jj);
            [h,ustarKap,status]=retrievalwindprofile_2levels_LM_linux(Upro,Hpro,z0);%WindProfile32km_retrieval2_10m30m_LM_h
            if status>0
            displacementH(ii,jj)=h;Ustar(ii,jj)=ustarKap*0.4;
            end
        end
        end
    end
    end
    Ustar(isnan(Ustar)==1)=-9999;Ustar=fillmatrix(Ustar);
    displacementH(isnan(displacementH)==1)=-9999;displacementH=fillmatrix(displacementH);
    kl=2*pi/1000;kL=2*pi/32000; 
    Ustar_adj=Ustar*(kl/kL)^(1/3);
    [wind10m1kmNN,wind10m1km]=inter1km(wind10m,LAT,LON);%raw wind speed at 1km
    [roughnessL1kmNN,roughnessL1km]=inter1km(roughnessL,LAT,LON);
    [displacementH1kmNN,displacementH1km]=inter1km(displacementH,LAT,LON); %retrieved displacement height
    [Ustar1kmNN,Ustar1km]=inter1km(Ustar,LAT,LON);
    [Ustar_adj1kmNN,Ustar_adj1km]=inter1km(Ustar_adj,LAT,LON);
    
    save([oudir,fnmm,'/WindRetrivals_NN.mat'],'wind10m','wind10m1km','wind10m1kmNN',...
        'displacementH','displacementH1km','displacementH1kmNN','roughnessL','roughnessL1km','roughnessL1kmNN','Ustar','Ustar1km','Ustar1kmNN','Ustar_adj','Ustar_adj1km','Ustar_adj1kmNN');
    
end

% end

cd(home_dir);

end

%% ---------------------------------------
function [dataNN,data]=inter1km(indata,LAT,LON)

global clat clon

load('/home/jt85/HMT-SEUS/Program/Geo/DEM_SE_US_1000m_UTM.mat');
%from NARR to 1km,nearest interpolation
interpol_type='nearest'; 
F=TriScatteredInterp(LON(:),LAT(:),indata(:),interpol_type);
dataNN=F(clon,clat);dataNN(isnan(cdem)==1)=NaN;

interpol_type='linear';
data=griddata(LON,LAT,indata,clon,clat,interpol_type);
data(isnan(cdem)==1)=NaN;

end

%% ---------------------------------------
function data=fillmatrix(data)

nrow=size(data,1);ncol=size(data,2);k=1;
for i=1:nrow
for j=1:ncol
idxmatrix(k,1)=i;idxmatrix(k,2)=j;k=k+1;
end
end

[ir,ic]=find(data<0);%-9999
idxmatrixtmp=idxmatrix;
for i=1:length(ir)
    idxmatrixtmp(idxmatrixtmp(:,1)==ir(i)&idxmatrixtmp(:,2)==ic(i),:)=[]; %get rid of all invalid values
end
for i=1:length(ir)
    id=[ir(i),ic(i)];
    [D,ID]=pdist2(idxmatrixtmp,id,'euclidean','Smallest',5);%D-distance, I-index
    for j=1:5
        r=idxmatrixtmp(ID(j),1);c=idxmatrixtmp(ID(j),2);
        tmp(j)=data(r,c);
    end
    data(ir(i),ic(i))=nanmean(tmp);
end
end
