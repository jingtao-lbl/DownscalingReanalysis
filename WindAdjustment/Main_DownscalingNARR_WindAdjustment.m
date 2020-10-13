%% Procedures to downscale NARR wind speed, accounting for subgrid-scale variability.
% By Jing Tao, Duke University
% Last updated: 10/10/2013
% -----------------------------------

%% Generating landcover-dependent roughness length and displacement height
MODIS_LC_DispRough(iyear);

%% Adjusting NARR 3hr32km wind speed and generating data at 3hr1km resolution 
% 1. Retrieving friction velocity at the original 32km resolution
% 2. Adjusting friction velocity to 1km
NARR_SEUS_WindAdj_3hr1km_NN(iyear);

%% Generating wind speed at 1hr1km from 3hr1km resolution data
NARR_SEUS_WindAdj_1hr1km(iyear);
