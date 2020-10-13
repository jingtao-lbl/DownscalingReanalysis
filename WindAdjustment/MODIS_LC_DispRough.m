function MODIS_LC_DispRough(iyear)
% Generate landcover-dependent roughness length and displacement height,
% based on BATS table and yearly MODIS landcover data (MCD12Q1).
% -------------------------------------------------------------------------
% By Jing Tao, Duke University
% Last updated: 10/10/2013
% -------------------------------------------------------------------------

MODIS_dir='F:\HMT-SE\SEUS_Database5yr\Data\MODIS\';
%tabnm='ECMWF';
tabnm='BATS';
load([MODIS_dir,'LandCover-MCD12Q1\LCTP2_MCD12Q1_',int2str(iyear),'.mat']);%landcover_seus

roughness_lc=rand(size(landcover_seus));roughness_lc(:,:)=NaN;
displace_lc=rand(size(landcover_seus));displace_lc(:,:)=NaN;
ECMWF_table=[0.00024,2.00,4.00,2.00,2.00,2.00,0.10,0.10,0.25,0.10,0.02,0.05,0.15,2.50,0.15,0.05];
BATS_table=[0.00024,1.00,2.00,1.00,0.80,0.80,0.10,0.10,0.25,0.10,0.02,0.03,0.06,2.50,0.06,0.01];
BATS_rcmin_table=[200,200,150,200,200,200,200,200,200,200,200,200,120,200,200,200];
k=1;
for i=[0:14,16]%No calss 15 in table
   id=[];id=find(landcover_seus==i);
   eval(['roughness_lc(landcover_seus==i)=',tabnm,'_table(k)*ones(length(id),1);']);
   eval(['rcmin_lc(landcover_seus==i)=',tabnm,'_rcmin_table(k)*ones(length(id),1);']);
   k=k+1;
end
displace_lc=10*roughness_lc*2/3;
save([MODIS_dir,'LandCover-MCD12Q1\DispRough_',tabnm,'_LCTP2_',int2str(iyear),'.mat'],'landcover_seus','roughness_lc','displace_lc','rcmin_lc');

