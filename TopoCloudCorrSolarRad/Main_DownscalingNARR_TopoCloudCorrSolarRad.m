%% Procedures to downscale NARR downward shortwave radiation, accounting for cloudiness and topographic corrections.
% By Jing Tao, Duke University
% Last updated: 10/10/2013
% -----------------------------------
iyear = 2012; 
%% Generating 1hr1km SW from original NARR SW data
% Calculate solar zenith angle at top, center and bottom of each hour
Cal_SZN_1km1hr_linux(iyear);
% Temporarily interpolate 3hour NARR SW data into hourly, based on cosine of solar zenith angle.
NARR_SEUS_SWRadiation_1hr1km_SZN(iyear);

%% Cloudiness Correction to 1hr1km NARR SW data
% Cloudiness correction to NARR solar radiation by reproducing the large-scale 
% spatial pattern observed by GCIP SRB (GSRB) solar radiation product.
NARR_SEUS_SWRadiation_1hr1km_CloudCorr(iyear);

%% Topographic correction to cloudiness-corrected NARR SW data
% Derive transmittance from GCIP SRB (GSRB) solar radiation product
SRB_TRA_SEUS_1kmhourly_UTM(iyear);
% Prepare ancillary data for IPW
NARR_SEUS_SWRadiation_AnciFiles(iyear);
% Run bash scripts for further preparation first and then perform topographic correction: 
% ./NARR_Terrian_Cosillumi.sh
% ./TopoCorr_NARR_Ancillary.sh
% ./TopoCorr_NARR_SW.sh
