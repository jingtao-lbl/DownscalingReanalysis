function SRB_TRA_SEUS_1kmhourly_UTM(iyear)
% Deriving transmittance from GCIP SRB (GSRB) solar radiation product,
% filling missing data both in space and time (check missing data first),
% then converting local standard time to UTC.
%--------------------------------------------------------------------------
% By Jing Tao, Duke University
% Last updated: 10/10/2013
%--------------------------------------------------------------------------

global cdem

startday=1; endday=yeardays(iyear);
data24hr=rand(610,716,24);cszn24hr=rand(610,716,24);data24hrSF=rand(610,716,24);
outdirST='/home/jt85/HMT-SEUS/Mat/SEUS_SRB_TRA_1hr1km_UTM_UTC_Fill_SpatialTemp/';
outdir='/home/jt85/HMT-SEUS/Mat/SEUS_SRB_TRA_1hr1km_UTM_UTC_Fill/';

trandir='/home/jt85/HMT-SEUS/Mat/SEUS_SRB_TRA_1hr1km_UTM_EST/';
szn_dir='/home/jt85/HMT-SEUS/Program/Albedo_Ancillary/SZN_1km1hr/';
topszn_dir='/home/jt85/HMT-SEUS/Program/Albedo_Ancillary/SZN_1km1hr_TopHourTemp/';
botszn_dir='/home/jt85/HMT-SEUS/Program/Albedo_Ancillary/SZN_1km1hr_BotHourTemp/';
geo_dir='/home/jt85/HMT-SEUS/Program/Geo/';
load([geo_dir,'DEM_SE_US_1000m_UTM.mat']);%cdem
load('/home/jt85/HMT-SEUS/Program/Geo/Coord_SE_US_1000m_UTM.mat');%clat,%clon
[ir,ic]=find(isnan(cdem)==0);

outST_dir=[outdirST,int2str(iyear),'/'];
if exist(outST_dir,'dir')==0;mkdir(outST_dir);end
out_dir=[outdir,int2str(iyear),'/'];
if exist(out_dir,'dir')==0;mkdir(out_dir);end

missingday=[];
dirtmp=dir(trandir);fnmls=[];
for i=3:length(dirtmp);fnmls(i-2,:)=dirtmp(i).name;end  
startstep=(sum(yeardays(2007:iyear-1))+startday-1)*24+1;
endstep=startstep+(endday-startday+1)*24-1;d=startday;k=0;
for ii=startstep:24:endstep
    data24hr(:,:,:)=NaN;cszn24hr(:,:,:)=NaN;data24hrSF(:,:,:)=NaN;
    for j=1:24 %local time,EST
        fnameii = [trandir,fnmls(ii+j-1,:)]; %2007010100.mat
        load(fnameii);transmi(isnan(cdem)==1)=NaN;
        fstr=fnmls(ii+j-1+5,:);%UTC
        load([szn_dir,fstr(1:4),'/',fstr]);tmpszn=szn;
        load([topszn_dir,fstr(1:4),'/',fstr]);topszn=szn;
        load([botszn_dir,fstr(1:4),'/',fstr]);botszn=szn;
        szn=tmpszn;cszn=cos(szn*pi/180);topcszn=cos(topszn*pi/180);botcszn=cos(botszn*pi/180);
        if j<12; cszn(botcszn<0)=0;%morning
        cszn(cszn<0&botcszn>=0)=botcszn(cszn<0&botcszn>=0)/2.0;    
        else cszn(topcszn<0)=0; %afternoon
        cszn(cszn<0&topcszn>=0)=topcszn(cszn<0&topcszn>=0)/2.0;     
        end
        cszn(isnan(cdem)==1)=NaN;
        transmi(cszn==0)=0;transmi(transmi>1)=1;
        data24hr(:,:,j)=transmi;% raw data, no spatial filling, no temporal filling
        cszn24hr(:,:,j)=cszn;
        %First, perform spatial filling, if there is existing partial data
        transmiSF=transmi;
        if numel(transmi(isnan(transmi)==0))/numel(transmi)>0.2 %existing partial data larger than 1/2 of the area
            transmiSF=fillmatrix_spatial(transmi,cszn);
        end
        transmiSF(cszn==0)=0;transmiSF(transmiSF>1)=1;
        data24hrSF(:,:,j)=transmiSF;%after spatial filling
        if numel(transmi(isnan(transmi)==0))/numel(transmi)>0.8;data24hr(:,:,j)=transmiSF;end % perform temporal filling later
            
        save([outST_dir,fnmls(ii+j-1+5,1:end-4),'_Spatial.mat'],'transmiSF','cszn');
    end
    if isnan(nanmean(data24hr(:)))==1 %missing a whole day
        k=k+1;missingday(k)=d;
    else
        %Perform temporal filling
        for m=1:length(ir)
        row=ir(m);col=ic(m);
        tmp=data24hr(row,col,:);datahr=tmp(:);
        tmp=cszn24hr(row,col,:);csznhr=tmp(:);
        datahr=fillmatrix_temporal(datahr,csznhr);
        data24hr(row,col,:)=datahr;
        end
    end
    for j=1:24
        transmiTF=data24hr(:,:,j);%after temporal filling
        transmiSF=data24hrSF(:,:,j);%after spatial filling
        transmi=matrixop(transmiTF,transmiSF,'mean');
        save([outST_dir,fnmls(ii+j-1+5,1:end-4),'_Temporal.mat'],'transmiTF');%convert to UTC
        save([out_dir,fnmls(ii+j-1+5,:)],'transmi');
    end
    d=d+1;
end
% fid=fopen([outdir,'missingday_',int2str(iyear),'.txt'],'at');
% for i=1:numel(missingday)
% fprintf(fid,'%d\n',missingday(i));
% end
% fclose(fid);

end

%% ----------------------------------------------
function data=fillmatrix_spatial(data,cszn)

global cdem

data(isnan(cdem)==1)=9999;data(cszn==0&isnan(data)==1)=9999;%cell that doesn't need to fill
data(isnan(data)==1)=-9999;% real missing data
[ir,ic]=find(data<-9990);%-9999
data(data==9999)=NaN;data(data<-9990)=NaN;
[irnomissing,icnomissing]=find(isnan(data)==0);%real data
idxmatrixtmp=[];idxmatrixtmp(:,1)=irnomissing(:);idxmatrixtmp(:,2)=icnomissing(:);
for i=1:length(ir)
    id=[ir(i),ic(i)];
    [D,ID]=pdist2(idxmatrixtmp,id,'euclidean','Smallest',1); %D-distance, I-index
    if ~isempty(ID) 
    for j=1:numel(ID)
        r=idxmatrixtmp(ID(j),1);c=idxmatrixtmp(ID(j),2);
        tmpdata=data(r,c);tmpcszn=cszn(r,c); %just one data
    end
    data(ir(i),ic(i))=tmpdata*cszn(ir(i),ic(i))/tmpcszn;
    end
end
end

%% ----------------------------------------------
function datahr=fillmatrix_temporal(datahr,csznhr)

%e.g.
% datahr=[0,0,0,0,0,0,0,NaN,NaN,NaN,0.2,0.3,0.4,0.5,0.4,0.3,NaN,NaN,NaN,NaN,0,0,0,0];
% csznhr=[0,0,0,0,0,0,0,0.01,0.05,0.1,0.2,0.3,0.4,0.5,0.4,0.3,0.2,0.1,0.05,0,0,0,0,0];
%------------------------------------------------------------------
missidx=find(isnan(datahr)==1);
nomissidx=find(isnan(datahr)==0&datahr>0);
datatmp=[];
for j=1:length(missidx)
ii=missidx(j);idnomiss = knnsearch(nomissidx,ii,'k',1);
ID=nomissidx(idnomiss);
if ~isempty(ID)
datatmp(j)=datahr(ID)*csznhr(ii)/csznhr(ID);
else
datatmp(j)=NaN;    
end
end
datahr(missidx)=datatmp;
end

%% Filling 20090101, a whole day missing
% using the average of 20081231 and 20090102
% already in UTC, thus the local day should be:
% 2008123105~2009010104 and 2009010205~2009010304
% to fill: 2009010105~2009010204
