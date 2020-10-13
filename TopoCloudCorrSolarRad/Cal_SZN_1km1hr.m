function Cal_SZN_1km1hr(iyear,day1,day2)
% Calculate solar zenith angle at top, center and bottom of each hour.
% e.g. Cal_SZN_1km1hr_linux(2012,dayofyear(2012,1,6),dayofyear(2012,3,31))
%--------------------------------------------------------------------------
% By Jing Tao, Duke University
% Last updated: 10/10/2013
%--------------------------------------------------------------------------

addpath('/home/jt85/HMT-SEUS/Program/Albedo_Ancillary/');
geo_dir='/home/jt85/HMT-SEUS/Program/Geo/';
ancillary_dir='/home3/jt85/HMT-SEUS/Program/Albedo_Ancillary/';

load([geo_dir,'Coord_SE_US_1000m_UTM.mat']);%bouxc,bouyc
load([geo_dir,'DEM_SE_US_1000m_UTM.mat']);%cdem

time.UTC = -5; %Time Zone
s=size(cdem);

% for iyear=2012:2013
    
oudir=[ancillary_dir,'SZN_1km1hr/',int2str(iyear),'/'];
if exist(oudir,'dir')==0;mkdir(oudir);end  

for ii=day1:day2
    
    %[str1,str2]=dateofyear(iyear,str2double(datestr{ii}));
    [str1,str2]=dateofyear(iyear,ii);
    
    for h=0:23
    szn=rand(s);szn(:,:)=NaN;szn_top=szn;szn_bottom=szn;
    %time.hour should be local time,0~23
    date=fromUTC([iyear,str2double(str2(1:2)),str2double(str2(3:4)),h],time.UTC);%to local time
    time.year=date(1);time.month=date(2);time.day=date(3);time.hour=date(4);
    if time.hour>=5&&time.hour<=20 %Day Time
    for ir=1:s(1)
    for ic=1:s(2)
        location.longitude = clon(ir,ic);
        location.latitude = clat(ir,ic);
        location.altitude = cdem(ir,ic);
        if ~isnan(location.altitude) 
            %middle/center of the hour
            time.min = 30; time.sec = 30;
            sun = sun_position(time, location);
            szntmp=sun.zenith;%in degree
            szn(ir,ic)=szntmp;
            %top of the hour
            time.min = 0; time.sec = 0;
            sun = sun_position(time, location);
            szntmp=sun.zenith;%in degree
            szn_top(ir,ic)=szntmp;
            %bottom of the hour
            time.min = 59; time.sec = 59;
            sun = sun_position(time, location);
            szntmp=sun.zenith;%in degree
            szn_bottom(ir,ic)=szntmp;
        end
    end
    end
    end
    if h<10;hstr=['0',int2str(h)];
    else hstr=int2str(h);
    end
    save([oudir,int2str(iyear),str2,hstr,'.mat'],'szn','szn_top','szn_bottom');
    end
end
% end

end
