function NARR_SEUS_SWRadiation_CloudCorr(iyear)
%Based on Extract_NARR_SW_RatioTopo_TMcorr.m

%--------------------------------------------------------------------------
data_dir='/home/jt85/HMT-SEUS/Mat/SEUS_NARR_1hr1km_UTM_CloudTopoCorrSW/';
out_dir='/home/jt85/HMT-SEUS/Mat/SEUS_NARR_1hr1km_UTM_CloudTopoCorrSW_Mat/';
if exist(out_dir,'dir')==0;mkdir(out_dir);end
site_dir='/home/jt85/HMT-SEUS/Mat/Verify_datasets/Tower_NARR/';
szn_dir='/home/jt85/HMT-SEUS/Program/Albedo_Ancillary/SZN_1km1hr/';
anci_dir='/home/jt85/HMT-SEUS/Mat/SEUS_NARR_1hr1km_UTM_SW_Anci/';

geo_dir='/home/jt85/HMT-SEUS/Program/Geo/';
home_dir='/home/jt85/HMT-SEUS/Program/';
load([geo_dir,'TowerSite_RC_1000m_UTM.mat']);%rc
Towerstr={'USAkn';'USChR';'USDk1';'USDk2';'USDk3';'USDBW';'PKTower'};
%-----------------------------------------------
%for iyear=2007:2010
for t=1:length(Towerstr)
    eval([Towerstr{t},'_',int2str(iyear),'=zeros(yeardays(iyear)*24,5);']);
end    
i=1;
for imon=1:12
if imon<10;imonstr=['0',int2str(imon)];else imonstr=int2str(imon);end;    
for iday=1:eomday(iyear,imon)
if iday<10;idaystr=['0',int2str(iday)];else idaystr=int2str(iday);end; 
doy=dayofyear(iyear,imon,iday);
if doy<10;doystr=['00',int2str(doy)];
elseif doy<100;doystr=['0',int2str(doy)];
else doystr=int2str(doy);
end
for ihour=0:23
    if ihour<10;ihrstr=['0',int2str(ihour)];else ihrstr=int2str(ihour);end;
    fstr=[int2str(iyear),imonstr,idaystr,ihrstr];
    load([szn_dir,int2str(iyear),'/',fstr,'.mat']);
    load([anci_dir,int2str(iyear),'/',fstr,'/shortwave_SZNInt_SQSW_NoSun_Final.mat']);%%'data','cszn'
    rawdata=data;
    cloudfnm=[anci_dir,int2str(iyear),'/',fstr,'/shortwave_Final_from1hrSpatialPdfCorr.mat'];
    if exist(cloudfnm,'file')>0
    load(cloudfnm);
    cloudcorrdata=NARRcorrSW; 
    else
    cloudcorrdata=rawdata;
    end
    fnm=[data_dir,int2str(iyear),'/TopoSW_',fstr,'.bin'];  
    fnmdiff=[data_dir,int2str(iyear),'/TopoSW_Diff_',fstr,'.bin'];
    if exist(fnm,'file')>0
    fid=fopen(fnm,'r');
    tmp=fread(fid,inf,'single');
    fclose(fid);
        if (length(tmp)>0)&&(isnan(nanmean(tmp(:)))==0)
        data=reshape(tmp,716,610);
        data=data';
        fid=fopen(fnmdiff,'r');
        datadiff=fread(fid,inf,'single');
        datadiff=reshape(datadiff,716,610);
        fclose(fid);
        datadiff=datadiff';
        else
        data=cloudcorrdata;
        datadiff=data;
        end
    else %2011
        data=cloudcorrdata;
        datadiff=data;
    end
    foudir=[out_dir,int2str(iyear),'/TopoSW/'];if exist(foudir,'dir')==0;mkdir(foudir);end;
    save([foudir,fstr,'.mat'],'data');%Topographically Corrected SW Radiat
    foudir=[out_dir,int2str(iyear),'/TopoSW_Diff/'];if exist(foudir,'dir')==0;mkdir(foudir);end;
    save([foudir,fstr,'.mat'],'datadiff');
    for t=1:length(Towerstr)
        eval([Towerstr{t},'_',int2str(iyear),'(i,1)=str2double(fstr(5:6));']);%month
        eval([Towerstr{t},'_',int2str(iyear),'(i,2)=str2double(fstr(7:8));']);%day
        eval([Towerstr{t},'_',int2str(iyear),'(i,3)=str2double(fstr(9:10));']);%hour
        eval([Towerstr{t},'_',int2str(iyear),'(i,4)=rawdata(rc(t,1),rc(t,2));']);
        eval([Towerstr{t},'_',int2str(iyear),'(i,5)=cloudcorrdata(rc(t,1),rc(t,2));']);
        eval([Towerstr{t},'_',int2str(iyear),'(i,6)=data(rc(t,1),rc(t,2));']);
        eval([Towerstr{t},'_',int2str(iyear),'(i,7)=datadiff(rc(t,1),rc(t,2));']);        
    end  
    
    i=i+1;
end
end
end
for t=1:length(Towerstr)
save([site_dir,'/',Towerstr{t},'_',int2str(iyear),'_CloudTopoSW.mat'],[Towerstr{t},'_',int2str(iyear)]);    
end
%end
cd(home_dir);

end
