%% Procedures to downscale NARR air temperature, air pressure, specific humidity and downward longwave radiation
% Need to run this package first, then wind adjustment, 
% followed by the cloudiness&topographic corrections to solar radiation.
% -------------------------------------------------------------------------
% By Jing Tao, Duke University
% Last updated: 10/10/2013
% -----------------------------------
%% Generating NARR fields at 3hr1km resolution
% For air temperature, air pressure, specific humidity and downward longwave radiation
% 1. Read and extract NARR original fields
% 2. Calculating dynamic lapse rate 
% 3. Adjusting NARR fields for elevation correction 
% for iyear=2012:2017
NARR_SEUS_Adj_3hr1km(iyear);
% end

%% Generating atmospheric forcing at 1hr1km from 3hr1km NARR fields
NARR_SEUS_1hr1km;

