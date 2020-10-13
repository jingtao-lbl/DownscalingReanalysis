function NARR_SEUS_1hr1km
% Temporally interpolate 3hr to hourly, the 3hr data is assumed at the 
% beginning hour of the 3-hr period. The final procedure for wind
% adjustment is also included here.
% -------------------------------------------------------------------------
% By Jing Tao, Duke University
% Last updated: 10/10/2013
% -------------------------------------------------------------------------

out_dir='/home3/jt85/HMT-SEUS/Mat/SEUS_NARR_1hr1km_UTM/';
data_dir='/home3/jt85/HMT-SEUS/Mat/SEUS_NARR_3hr1km_UTM/';
home_dir='/home/jt85/HMT-SEUS/Program/';
ounm='Radiation_Linear.mat';tabnm='BATS';
load('/home/jt85/HMT-SEUS/Program/Geo/LandCover-MCD12Q1/NARR_Roughness.mat');%roughnessL1km

%-----------------------------------------------
oudir=[data_dir];cd(oudir);
dirdata=dir;nrec=length(dirdata)-2; 
for i=1:nrec
    
    fnmm=dirdata(i+2).name;%merged_AWIP32.2008010100_SE_US
    load([oudir,fnmm,'/WindRetrivals_NN.mat']);%'wind10m1km','wind10m1kmNN','Ustar1km','Ustar1kmNN','Ustar_adj1km','Ustar_adj1kmNN'
    load([oudir,fnmm,'/LocalgridVar_flx.mat']);%'airtemperature','airpressure','spechumi'
    load([oudir,fnmm,'/LocaladjustedVar.mat']);%'adj_airtemperature','adj_airpressure','adj_spechumi','adj_longwave'
    load([oudir,fnmm,'/LocalgridVar_sfc.mat']);%longwave,shortwave
    
    iyear=str2double(fnmm(15:18));
    if exist([out_dir,int2str(iyear)],'dir')<=0 
        mkdir([out_dir,int2str(iyear)]);
    end
    %Landcover-dependent displacement height and roughness length
    load(['/home/jt85/HMT-SEUS/Program/Geo/LandCover-MCD12Q1/DispRough_',tabnm,'_LCTP2_',int2str(iyear),'.mat']);%displace_lc,landcover_seus,roughness_lc    
    measH=10.0*ones(size(Ustar1km));%Note here is 10m ABG!
    dispH=displace_lc;
    roughL=roughness_lc;z0=roughnessL1km;%NARR roughness length
    dispH(dispH>=measH)=measH(dispH>=measH)-1.01;
    
    if i>1 
        
        %------------------------------------------------------------------------
        [airtemperatured2,airtemperatured3]=inter(airtemperature,airtemperaturePre);
        [airpressured2,airpressured3]=inter(airpressure,airpressurePre);
        [spechumid2,spechumid3]=inter(spechumi,spechumiPre);
        [wind10m1kmd2,wind10m1kmd3]=inter(wind10m1km,wind10m1kmPre);
        [wind10m1kmNNd2,wind10m1kmNNd3]=inter(wind10m1kmNN,wind10m1kmNNPre);
        [Ustar1kmd2,Ustar1kmd3]=inter(Ustar1km,Ustar1kmPre);
        [Ustar1kmNNd2,Ustar1kmNNd3]=inter(Ustar1kmNN,Ustar1kmNNPre);
        [longwaved2,longwaved3]=inter(longwave,longwavePre);
        [shortwaved2,shortwaved3]=inter(shortwave,shortwavePre);
        
        [adj_longwaved2,adj_longwaved3]=inter(adj_longwave,adj_longwavePre);
        [adj_airtemperatured2,adj_airtemperatured3]=inter(adj_airtemperature,adj_airtemperaturePre);
        [adj_airpressured2,adj_airpressured3]=inter(adj_airpressure,adj_airpressurePre);
        [adj_spechumid2,adj_spechumid3]=inter(adj_spechumi,adj_spechumiPre);
        
        %save current data temporarily
        airtemperaturetmp=airtemperature;airpressuretmp=airpressure;spechumitmp=spechumi;
        adj_airtemperaturetmp=adj_airtemperature;adj_airpressuretmp=adj_airpressure;adj_spechumitmp=adj_spechumi;
        wind10m1kmtmp=wind10m1km;wind10m1kmNNtmp=wind10m1kmNN;
        Ustar1kmtmp=Ustar1km;Ustar1kmNNtmp=Ustar1kmNN;
        longwavetmp=longwave;shortwavetmp=shortwave;adj_longwavetmp=adj_longwave;
        
        %--------------------------------------------------------------------------------------------------------
        airtemperature=airtemperatured3;airpressure=airpressured3;spechumi=spechumid3;
        adj_airtemperature=adj_airtemperatured3;adj_airpressure=adj_airpressured3;adj_spechumi=adj_spechumid3;
        wind10m1km=wind10m1kmd3;wind10m1kmNN=wind10m1kmNNd3;
        Ustar1km=Ustar1kmd3;Ustar1kmNN=Ustar1kmNNd3;
        longwave=longwaved3;shortwave=shortwaved3;adj_longwave=adj_longwaved3;
        
        adj_Ustar1km=Ustar1km.*(z0./roughL).^(-0.09);
        adj_wind10m1km=log((measH-dispH)./roughL).*adj_Ustar1km/0.4;
        adj_wind10m1km(adj_wind10m1km<=0)=0.01;
    
        fnmm=dirdata(i-1+2).name;iyear=str2double(fnmm(15:18));%previous name
        save([out_dir,int2str(iyear),'/',int2str(str2double(fnmm(15:24))+2),'.mat'],'airtemperature','airpressure','spechumi',...
        'adj_airtemperature','adj_airpressure','adj_spechumi','wind10m1km','wind10m1kmNN','Ustar1km','Ustar1kmNN','adj_Ustar1km','adj_wind10m1km');
        save([out_dir,int2str(iyear),'/',int2str(str2double(fnmm(15:24))+2),'_',ounm],'longwave','shortwave','adj_longwave');   
        
        airtemperature=airtemperatured2;airpressure=airpressured2;spechumi=spechumid2;
        adj_airtemperature=adj_airtemperatured2;adj_airpressure=adj_airpressured2;adj_spechumi=adj_spechumid2;
        wind10m1km=wind10m1kmd2;wind10m1kmNN=wind10m1kmNNd2;
        Ustar1km=Ustar1kmd2;Ustar1kmNN=Ustar1kmNNd2;
        longwave=longwaved2;shortwave=shortwaved2;adj_longwave=adj_longwaved2;
        
        adj_Ustar1km=Ustar1km.*(z0./roughL).^(-0.09);
        adj_wind10m1km=log((measH-dispH)./roughL).*adj_Ustar1km/0.4;
        adj_wind10m1km(adj_wind10m1km<=0)=0.01;
    
        save([out_dir,int2str(iyear),'/',int2str(str2double(fnmm(15:24))+1),'.mat'],'airtemperature','airpressure','spechumi',...
        'adj_airtemperature','adj_airpressure','adj_spechumi','wind10m1km','wind10m1kmNN','Ustar1km','Ustar1kmNN','adj_Ustar1km','adj_wind10m1km');
        save([out_dir,int2str(iyear),'/',int2str(str2double(fnmm(15:24))+1),'_',ounm],'longwave','shortwave','adj_longwave');
    
        airtemperature=airtemperaturePre;airpressure=airpressurePre;spechumi=spechumiPre;
        adj_airtemperature=adj_airtemperaturePre;adj_airpressure=adj_airpressurePre;adj_spechumi=adj_spechumiPre;
        wind10m1km=wind10m1kmPre;wind10m1kmNN=wind10m1kmNNPre;
        Ustar1km=Ustar1kmPre;Ustar1kmNN=Ustar1kmNNPre;
        longwave=longwavePre;shortwave=shortwavePre;adj_longwave=adj_longwavePre;
        
        adj_Ustar1km=Ustar1km.*(z0./roughL).^(-0.09);
        adj_wind10m1km=log((measH-dispH)./roughL).*adj_Ustar1km/0.4;
        adj_wind10m1km(adj_wind10m1km<=0)=0.01;
    
        save([out_dir,int2str(iyear),'/',fnmm(15:24),'.mat'],'airtemperature','airpressure','spechumi',...
        'adj_airtemperature','adj_airpressure','adj_spechumi','wind10m1km','wind10m1kmNN','Ustar1km','Ustar1kmNN','adj_Ustar1km','adj_wind10m1km');
        save([out_dir,int2str(iyear),'/',fnmm(15:24),'_',ounm],'longwave','shortwave','adj_longwave');
        
        airtemperature=airtemperaturetmp;airpressure=airpressuretmp;spechumi=spechumitmp;
        adj_airtemperature=adj_airtemperaturetmp;adj_airpressure=adj_airpressuretmp;adj_spechumi=adj_spechumitmp;
        wind10m1km=wind10m1kmtmp;wind10m1kmNN=wind10m1kmNNtmp;
        Ustar1km=Ustar1kmtmp;Ustar1kmNN=Ustar1kmNNtmp;
        longwave=longwavetmp;shortwave=shortwavetmp;adj_longwave=adj_longwavetmp;
        
    end

    airtemperaturePre=airtemperature;airpressurePre=airpressure;spechumiPre=spechumi;
    adj_airtemperaturePre=adj_airtemperature;adj_airpressurePre=adj_airpressure;adj_spechumiPre=adj_spechumi;
    wind10m1kmPre=wind10m1km;wind10m1kmNNPre=wind10m1kmNN;
    Ustar1kmPre=Ustar1km;Ustar1kmNNPre=Ustar1kmNN;
    longwavePre=longwave;shortwavePre=shortwave;adj_longwavePre=adj_longwave;
    
end
fnmm=dirdata(end).name;iyear=str2double(fnmm(15:18));
adj_Ustar1km=Ustar1km.*(z0./roughL).^(-0.09);
adj_wind10m1km=log((measH-dispH)./roughL).*adj_Ustar1km/0.4;
adj_wind10m1km(adj_wind10m1km<=0)=0.01;
    
save([out_dir,int2str(iyear),'/',fnmm(15:24),'.mat'],'airtemperature','airpressure','spechumi',...
        'adj_airtemperature','adj_airpressure','adj_spechumi','wind10m1km','wind10m1kmNN','Ustar1km','Ustar1kmNN','adj_Ustar1km','adj_wind10m1km'); 
save([out_dir,int2str(iyear),'/',int2str(str2double(fnmm(15:24))+1),'.mat'],'airtemperature','airpressure','spechumi',...
        'adj_airtemperature','adj_airpressure','adj_spechumi','wind10m1km','wind10m1kmNN','Ustar1km','Ustar1kmNN','adj_Ustar1km','adj_wind10m1km');    
save([out_dir,int2str(iyear),'/',int2str(str2double(fnmm(15:24))+2),'.mat'],'airtemperature','airpressure','spechumi',...
        'adj_airtemperature','adj_airpressure','adj_spechumi','wind10m1km','wind10m1kmNN','Ustar1km','Ustar1kmNN','adj_Ustar1km','adj_wind10m1km');
fnmm=dirdata(end).name;iyear=str2double(fnmm(15:18));
save([out_dir,int2str(iyear),'/',fnmm(15:24),'_',ounm],'longwave','shortwave','adj_longwave');  
save([out_dir,int2str(iyear),'/',int2str(str2double(fnmm(15:24))+1),'_',ounm],'longwave','shortwave','adj_longwave');    
save([out_dir,int2str(iyear),'/',int2str(str2double(fnmm(15:24))+2),'_',ounm],'longwave','shortwave','adj_longwave');

cd(home_dir);

end

%% ----------------------------------------
function [d2,d3]=inter(nowdata,predata)
    d1=predata;d4=nowdata;
    d1tmp=d1;d4tmp=d4;
    d1tmp(isnan(d1)==1&isnan(d4)==0)=d4tmp(isnan(d1)==1&isnan(d4)==0);
    d4tmp(isnan(d1)==0&isnan(d4)==1)=d1tmp(isnan(d1)==0&isnan(d4)==1);
    d1=d1tmp;d4=d4tmp;
    itv=(d4-d1)/3;
    d2=d1+itv;
    d3=d2+itv;
end
