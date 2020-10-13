function NARR_SEUS_Adj_3hr1km(iyear)
% 1. Read and extract NARR original data;
% 2. Calculating dynamic lapse rate to correct air temperature given 
% the elevation differences between NARR terrain and 1km DEM; 
% 3. Adjusting other NARR fields for elevation correction; 
% 4. Generating datasets at 3hr1km.
% -------------------------------------------------------------------------
% By Jing Tao, Duke University
% Last updated: 10/10/2013
% -------------------------------------------------------------------------

basinstr='SE_US';
Sres=1000;%Spatial Resolution
%Specify r1,r2,c1,c2 for the study domain;
r1=160;r2=190;c1=230;c2=260;

%gamma=-6.5/1000; %K/m
g=9.80665; %m/s^2
R=287.04; %J/kg-K

%--------------------------------------------------------------------------
% Specify NARR fields:

data_src_3D = '3D';
N3D = [167,168,176,177,185,186,195,196,204,205,213,214,222,223,231,232,240,241];
parastrs = {'gpheight800','airtemperature800','gpheight825','airtemperature825','gpheight850','airtemperature850','gpheight875','airtemperature875','gpheight900','airtemperature900','gpheight925','airtemperature925','gpheight950','airtemperature950','gpheight975','airtemperature975','gpheight1000','airtemperature1000'};
N3D_wind = [171,172,180,181,190,191,199,200,208,209,217,218,226,227,235,236,244,245];
windstr={'windU800','windV800','windU825','windV825','windU850','windV850','windU875','windV875','windU900','windV900','windU925','windV925','windU950','windV950','windU975','windV975','windU1000','windV1000'};

data_src_flx = 'flx';
flxN = [35,36,38,39,40,41,42];%should be increasing!
flx_strs = {'windEW10m','windNS10m','airtemperature','airpressure','spechumi','windEW30m','windNS30m'};
%U-EW,V-NS

data_src_sfc = 'sfc';
sfcN = [41,42];
% sfcN = [50,51]; %Forecast
sfc_strs = {'shortwave','longwave'};

%--------------------------------------------------------------------------
% Customized path:
home_dir='/home3/jt85/HMT-SEUS/Program/';
algo='/home/jt85/HMT-SEUS/Program/read_grib/';addpath(algo);
data_dir='/home/jt85/HMT-SEUS/Data/NARR/';
out_dir='/home3/jt85/HMT-SEUS/Mat/SEUS_NARR_3hr1km_UTM/';
if exist(out_dir,'dir')==0;mkdir(out_dir);end

% All data have to be in the same projection, i.e., UTM17N here.
geo_dir='/home/jt85/HMT-SEUS/Program/Geo/';
load([geo_dir,'DEM_',basinstr,'_',num2str(Sres),'m_UTM.mat']);%cdem
load([geo_dir,'NARR_SGMH_Bilin.mat']);%NARR Terrain Geometric Height, elev          
load([geo_dir,'NARR_Coord_UTM.mat']);%bouxc,bouyc
narr_xc=bouxc;narr_yc=bouyc;interpol_type = 'linear';
load([geo_dir,'Coord_',basinstr,'_',num2str(Sres),'m_UTM.mat']);%bouxc,bouyc

%--------------------------------------------------------------------------
cd([data_dir,data_src_3D,'/',int2str(iyear),'/']);
dirdata=dir;nrec=length(dirdata)-2; 
for i=1:nrec

    %flx	merged_AWIP32.2007010100.RS.flx
    %sfc    merged_AWIP32.2007010100.RS.sfc
    %3D 	merged_AWIP32.2007010100.3D
    fnmm=dirdata(i+2).name; %'i+2' excludes '.' and '..' on unix; 
    fnm=[data_dir,data_src_3D,'/',int2str(iyear),'/',fnmm];extention=strfind(fnmm,'.');
    grib_struct=read_grib(fnm,N3D,'ScreenDiag',0,'ParamTable','NCEPREAN');

    % ddata properly oriented to LAT,LON after strip_struct, and at correct basin size/orientation
    [gpheight800,NARRgrid_gpheight800] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,1);   [airtemperature800,NARRgrid_airtemperature800] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,2);
    [gpheight825,NARRgrid_gpheight825] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,3);   [airtemperature825,NARRgrid_airtemperature825] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,4);
    [gpheight850,NARRgrid_gpheight850] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,5);   [airtemperature850,NARRgrid_airtemperature850] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,6);
    [gpheight875,NARRgrid_gpheight875] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,7);   [airtemperature875,NARRgrid_airtemperature875] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,8);
    [gpheight900,NARRgrid_gpheight900] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,9);   [airtemperature900,NARRgrid_airtemperature900] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,10);
    [gpheight925,NARRgrid_gpheight925] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,11);  [airtemperature925,NARRgrid_airtemperature925] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,12);
    [gpheight950,NARRgrid_gpheight950] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,13);  [airtemperature950,NARRgrid_airtemperature950] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,14);
    [gpheight975,NARRgrid_gpheight975] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,15);  [airtemperature975,NARRgrid_airtemperature975] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,16);
    [gpheight1000,NARRgrid_gpheight1000] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,17);[airtemperature1000,NARRgrid_airtemperature1000] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,18);

    % extract wind data
    grib_struct=read_grib(fnm,N3D_wind,'ScreenDiag',0,'ParamTable','NCEPREAN');
    [windU800,NARRgrid_windU800] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,1);   [windV800,NARRgrid_windV800] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,2);
    [windU825,NARRgrid_windU825] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,3);   [windV825,NARRgrid_windV825] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,4);
    [windU850,NARRgrid_windU850] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,5);   [windV850,NARRgrid_windV850] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,6);
    [windU875,NARRgrid_windU875] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,7);   [windV875,NARRgrid_windV875] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,8);
    [windU900,NARRgrid_windU900] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,9);   [windV900,NARRgrid_windV900] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,10);
    [windU925,NARRgrid_windU925] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,11);   [windV925,NARRgrid_windV925] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,12);
    [windU950,NARRgrid_windU950] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,13);   [windV950,NARRgrid_windV950] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,14);
    [windU975,NARRgrid_windU975] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,15);   [windV975,NARRgrid_windV975] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,16);
    [windU1000,NARRgrid_windU1000] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,17); [windV1000,NARRgrid_windV1000] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,18);

    % extract flux data 
    fnmm_flx=[fnmm(1:extention(2)-1),'.RS.flx'];
    fnm_flx=[data_dir,data_src_flx,'/',int2str(iyear),'/',fnmm_flx];
    grib_struct_flx=read_grib(fnm_flx,flxN,'ScreenDiag',0,'ParamTable','NCEPREAN'); 
    [windEW10m,NARRgrid_windEW10m] = strip_struct(grib_struct_flx,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,1);
    [windNS10m,NARRgrid_windNS10m] = strip_struct(grib_struct_flx,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,2);
    [windEW30m,NARRgrid_windEW30m] = strip_struct(grib_struct_flx,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,6);
    [windNS30m,NARRgrid_windNS30m] = strip_struct(grib_struct_flx,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,7);
    [spechumi,NARRgrid_spechumi] = strip_struct(grib_struct_flx,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,5);
    [airpressure,NARRgrid_airpressure] = strip_struct(grib_struct_flx,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,4);     
    [airtemperature,NARRgrid_airtemperature] = strip_struct(grib_struct_flx,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,3);%10m above ground
    
    % extract sfc data
    fnmm_sfc=[fnmm(1:extention(2)-1),'.RS.sfc'];
    fnm_sfc=[data_dir,data_src_sfc,'/',int2str(iyear),'/',fnmm_sfc];
    grib_struct_sfc=read_grib(fnm_sfc,sfcN,'ScreenDiag',0,'ParamTable','NCEPREAN'); 
    [shortwave,NARRgrid_shortwave] = strip_struct(grib_struct_sfc,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,1);
    [longwave,NARRgrid_longwave] = strip_struct(grib_struct_sfc,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,2);
    %-----------------------------------------
 
    gmheight800=GHz_convert(gpheight800,clat*pi/180);
    gmheight825=GHz_convert(gpheight825,clat*pi/180);
    gmheight850=GHz_convert(gpheight850,clat*pi/180);
    gmheight875=GHz_convert(gpheight875,clat*pi/180);
    gmheight900=GHz_convert(gpheight900,clat*pi/180);
    gmheight925=GHz_convert(gpheight925,clat*pi/180);
    gmheight950=GHz_convert(gpheight950,clat*pi/180);
    gmheight975=GHz_convert(gpheight975,clat*pi/180);
    gmheight1000=GHz_convert(gpheight1000,clat*pi/180);
    
    lapserate=getlapserate(cdem,elev,gmheight1000,gmheight975,gmheight950,gmheight925,gmheight900,gmheight875,gmheight850,gmheight825,gmheight800,...
    airtemperature1000,airtemperature975,airtemperature950,airtemperature925,airtemperature900,airtemperature875,airtemperature850,airtemperature825,airtemperature800);

    %---Adjust elevation effects---
    delt_topo=cdem-elev;
    adj_airtemperature=airtemperature+lapserate.*delt_topo;
    adj_airpressure=airpressure./exp(g*delt_topo./(R*(adj_airtemperature+airtemperature)/2)); %Eq. (6)
    adj_esat=6.112.*exp(17.67*(adj_airtemperature-273.15)./(adj_airtemperature-273.15+243.5)); %correct Cos. (9)
    esat=6.112.*exp(17.67*(airtemperature-273.15)./(airtemperature-273.15+243.5));
    adj_qsat=0.622*adj_esat./((adj_airpressure*0.01)-0.378*adj_esat);%correct Cos. (8)
    qsat=0.622*esat./((airpressure*0.01)-0.378*esat); %Eq. (7)
    adj_spechumi=spechumi.*adj_qsat./qsat; 
    
    %---Adjusting longwaver radiation---
    vaporPre=spechumi.*airpressure*0.01/0.622;
    adj_vaporPre=adj_spechumi.*adj_airpressure*0.01/0.622;
    emiss=1.08*(1-exp(-1*vaporPre.^(airtemperature/2016)));
    adj_emiss=1.08*(1-exp(-1*adj_vaporPre.^(adj_airtemperature/2016)));
    adj_longwave=(adj_emiss./emiss).*((adj_airtemperature./airtemperature).^4).*longwave;
    
    %-----------------------------------------
    oudir=[out_dir,'/',int2str(iyear),'/',fnmm(1:end-3),'_',basinstr];
    if exist(oudir,'dir')<=0 
        mkdir(oudir);
    end
    
    save([oudir,'/ThreeDimDatasets.mat'],parastrs{1:end},windstr{1:end});
    save([oudir,'/GeoMetricHeight.mat'],'gmheight*');
    save([oudir,'/lapserate.mat'],'lapserate');
    save([oudir,'/NARRgridVar.mat'],'NARRgrid_*'); %Original Data at 32km grids, global
    save([oudir,'/LocalgridVar_flx.mat'],flx_strs{1:end});%after interpolated into 1km grids
    save([oudir,'/LocalgridVar_sfc.mat'],sfc_strs{1:end});%after interpolated into 1km grids
    save([oudir,'/LocaladjustedVar.mat'],'adj_airtemperature','adj_airpressure','adj_spechumi','adj_longwave'); %after interpolation and elevation effects correction
      
end


cd(home_dir);
end

%% grib to matrix converter
function [tmpdata,ddata] = strip_struct(grib_struct,interpol_type,narr_xc,narr_yc,bouxc,bouyc,r1,r2,c1,c2,i)

data=grib_struct(i).fltarray; tmp=reshape(data,349,277);
tmp(tmp>9e+20)=NaN; ddata=flipud(tmp'); ddatat=ddata(r1:r2,c1:c2); 
tmpdata=griddata(narr_xc,narr_yc,ddatat,bouxc,bouyc,interpol_type);%interpolate to basin grid;

end

%% Generate Lapse Rate
function lapserate=getlapserate(cdem,elev,gmheight1000,gmheight975,gmheight950,gmheight925,gmheight900,gmheight875,gmheight850,gmheight825,gmheight800,...
    airtemperature1000,airtemperature975,airtemperature950,airtemperature925,airtemperature900,airtemperature875,airtemperature850,airtemperature825,airtemperature800)
  
nrow = size(cdem,1); ncol = size(cdem,2);
lapserate=rand(nrow,ncol);lapserate(:,:)=NaN;

for ii=1:nrow
    for jj=1:ncol
        Y=[cdem(ii,jj)+10,elev(ii,jj)+10]';
        X=[gmheight1000(ii,jj),gmheight975(ii,jj),gmheight950(ii,jj),gmheight925(ii,jj),gmheight900(ii,jj),gmheight875(ii,jj),gmheight850(ii,jj),gmheight825(ii,jj),gmheight800(ii,jj)]';
        XA=[airtemperature1000(ii,jj),airtemperature975(ii,jj),airtemperature950(ii,jj),airtemperature925(ii,jj),airtemperature900(ii,jj),airtemperature875(ii,jj),airtemperature850(ii,jj),airtemperature825(ii,jj),airtemperature800(ii,jj)];
        [IDX,D]= knnsearch(X,Y); 
        if IDX(1)==IDX(2)
            if IDX(1)==1;
                IDX(2)=IDX(2)+1; 
            elseif IDX(1)==length(X);
                IDX(2)=IDX(2)-1;
            else
                if Y(1)-X(IDX(1))<=0  
                    IDX(1)=IDX(1)-1;    %both cdem&narr are under the geopotential height
                else
                    IDX(2)=IDX(2)+1;    %both cdem&narr are above the geopotential height
                end
            end
        end
        lapserate(ii,jj)=(XA(IDX(1))-XA(IDX(2)))/(X(IDX(1))-X(IDX(2)));
    end
end

end
