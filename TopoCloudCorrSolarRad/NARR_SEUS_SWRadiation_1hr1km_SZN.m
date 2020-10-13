function NARR_SEUS_SWRadiation_1hr1km_SZN(iyear)
% Temporarily interpolate 3hour NARR data into hourly, based on cosine of solar zenith angle.
%--------------------------------------------------------------------------
% By Jing Tao, Duke University
% Last updated: 10/10/2013
%--------------------------------------------------------------------------

out_dir='/home/jt85/HMT-SEUS/Mat/SEUS_NARR_1hr1km_UTM_SW_Anci/';
data_dir='/home/jt85/HMT-SEUS/Mat/SEUS_NARR_3hr1km_UTM/';
anci_dir='/home/jt85/HMT-SEUS/Mat/SEUS_NARR_1hr1km_UTM_SW_Anci/';
szn_dir='/home/jt85/HMT-SEUS/Program/Albedo_Ancillary/SZN_1km1hr/';
topszn_dir='/home/jt85/HMT-SEUS/Program/Albedo_Ancillary/SZN_1km1hr_TopHourTemp/';
botszn_dir='/home/jt85/HMT-SEUS/Program/Albedo_Ancillary/SZN_1km1hr_BotHourTemp/';
home_dir='/home/jt85/HMT-SEUS/Program/';
row=610;col=716;

%-----------------------------------------------
oudir=[data_dir,'/',int2str(iyear),'/'];cd(oudir);
dirdata=dir;nrec=length(dirdata)-2; 
for i=4:8:nrec % start from 09 
    fnmmi=dirdata(i+2).name;%merged_AWIP32.2008010100_SE_US
    fstr=fnmmi(15:24);%YYYYMMDDHH,00,03,06,09,12,15,18,21
    %load([anci_dir,int2str(iyear),'/',fstr,'/sunrisesunset.mat']);%'sunrise','sunset'
    %load([anci_dir,int2str(iyear),'/',fstr(1:6),'15',fstr(9:10),'/sunrisesunset.mat']);%'sunrise','sunset'
    %sunset(sunset<2)=sunset(sunset<2)+24;%UTC, for 00, 01
    %sunrise=sunrise-5;sunset=sunset-5;%LST
    if i<(nrec-4); N=6; else N=5;end %09,12,15,18,21,00
    
    cszn_sum=zeros(row,col);SW_sum=zeros(row,col);hh=4;%UTC09=LST04
    for j=1:N %09,12,15,18,21,00
    fnmm=dirdata(i+j-1+2).name;%merged_AWIP32.2008010100_SE_US
    load([oudir,fnmm,'/LocalgridVar_sfc_New.mat']);%longwave,shortwave,3hr
    eval(['SW',int2str(j),'=shortwave;']);
    eval(['SW_sum=SW_sum+3*SW',int2str(j),';']);
    for k=1:3
        fstr=int2str(str2double(fnmm(15:24))+k-1);
        load([szn_dir,int2str(iyear),'/',fstr,'.mat']);tmpszn=szn;
        load([topszn_dir,int2str(iyear),'/',fstr,'.mat']);topszn=szn;
        load([botszn_dir,int2str(iyear),'/',fstr,'.mat']);botszn=szn;
        szn=tmpszn;cszn=cos(szn*pi/180);topcszn=cos(topszn*pi/180);botcszn=cos(botszn*pi/180);
        if hh<12; cszn(botcszn<0)=0;%morning
        cszn(cszn<0&botcszn>=0)=botcszn(cszn<0&botcszn>=0)/2.0;    
        else cszn(topcszn<0)=0; %afternoon
        cszn(cszn<0&topcszn>=0)=topcszn(cszn<0&topcszn>=0)/2.0;     
        end;hh=hh+1;
        %cszn(hh<round(sunrise)|hh>fix(sunset))=0;hh=hh+1;
        %cszn=cszn+abs(nanmin(cszn(:)));%get rid of negative values
        eval(['cszn',int2str(j),int2str(k),'=cszn;']);
    end
    eval(['denom',int2str(j),'=cszn',int2str(j),'1+cszn',int2str(j),'2+cszn',int2str(j),'3;']);
    eval(['cszn_ave',int2str(j),'=denom',int2str(j),'/3.0;']);  
    eval(['cszn_sum=cszn_sum+sqrt(SW',int2str(j),'.*cszn_ave',int2str(j),');']);
    end
    
    for j=1:N
        fnmm=dirdata(i+j-1+2).name;    
        for k=1:3
        fstr=int2str(str2double(fnmm(15:24))+k-1);
        data=zeros(row,col);
        eval(['SW=SW',int2str(j),';']);
        eval(['denom=denom',int2str(j),';']);
        eval(['cszn_ave=cszn_ave',int2str(j),';']);
        eval(['cszn=cszn',int2str(j),int2str(k),';']);
        data(denom>0)=SW_sum(denom>0).*(sqrt(SW(denom>0).*cszn_ave(denom>0))./cszn_sum(denom>0)).*cszn(denom>0)./denom(denom>0);
        save([out_dir,'/',int2str(iyear),'/',fstr,'/shortwave_SZNInt_SQSW_NoSun_Final.mat'],'data','cszn');
        end
    end 
    
    if i<(nrec-4)
    for j=N+1:N+2 %for 03,06
        fnmm=dirdata(i+j-1+2).name;    
        for k=1:3
        fstr=int2str(str2double(fnmm(15:24))+k-1);data=zeros(row,col);
        save([out_dir,'/',int2str(iyear),'/',fstr,'/shortwave_SZNInt_SQSW_NoSun_Final.mat'],'data','cszn');
        end
    end
    end
end
cd(home_dir);

end
