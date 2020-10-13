# Algorithm Package For Downscaling Reanalysis Products
By Jing Tao (jingtao@lbl.gov)
(Last updated on October 12, 2020)

This repository contains three packages that assemble Matlab codes and shell scripts to downscale coarse-resolution reanalysis fields to finer resolutions, accounting for subgrid-scale variability and/or topographic effects. The packages aim to generate high-resolution, high-accuracy meteorological forcing for hydrological applications, especially over topographically complex regions. Using the 3-hourly North American Regional Reanalysis (NARR) as an example, the packages downscale 32-km resolution NARR atmospheric temperature, atmospheric pressure, specific humidity, wind speed, downward longwave and shortwave radiation to 1-km and hourly resolution. The generated atmospheric forcing datasets have been used for hydrological modeling (Tao and Barros, 2018, 2019) and providing initials for hydrological forecasting practice (Tao et al., 2016). Users can modify the codes to apply the downscaling packages to any other reanalysis products, e.g., the downscaling packages have been adapted by Rouf et al. (2020) to downscale the 1/8° North America Land Data Assimilation System version 2 (NLDAS-2) fields to 500-m resolution.

Please check Tao and Barros (2018) for further details. Contact Dr. Jing Tao at jingtao@lbl.gov if you have any questions. 

# 1. ElevationCorrection
A package for elevation corrections to coarse-resolution reanalysis fields, including atmospheric temperature, atmospheric pressure, specific humidity, and downward longwave radiation. Follow procedures in "Main_DownscalingNARR_ElevationCorrection.m".
-	Instead of using the standard lapse rate (i.e., - 6.5 K/km), the package derives dynamic lapse rates in space and time to downscale atmospheric temperature, accounting for elevation differences between the coarse-resolution terrain and high-resolution DEM.
- The elevation correction for atmospheric pressure, specific humidity, and downward longwave radiation follows Cosgrove et al. (2003).

# 2. WindAdjustment

# 3. TopoCloudCorrSolarRad 

# Reference 

Tao, Jing, Di Wu, Jonathan Gourley, Sara Q. Zhang, Wade Crow, Christa Peters-Lidard, and Ana P. Barros. "Operational hydrological forecasting during the IPHEx-IOP campaign–Meet the challenge." Journal of Hydrology 541 (2016): 434-456. (https://doi.org/10.1016/j.jhydrol.2016.02.019)

Tao, Jing, and Ana P. Barros. "Multi-year atmospheric forcing datasets for hydrologic modeling in regions of complex terrain–Methodology and evaluation over the Integrated Precipitation and Hydrology Experiment 2014 domain." Journal of Hydrology 567 (2018): 824-842. (https://doi.org/10.1016/j.jhydrol.2016.12.058)

Tao, Jing, and Ana P. Barros. "Multi-year surface radiative properties and vegetation parameters for hydrologic modeling in regions of complex terrain—Methodology and evaluation over the Integrated Precipitation and Hydrology Experiment 2014 domain." Journal of Hydrology: Regional Studies 22 (2019): 100596. (https://doi.org/10.1016/j.ejrh.2019.100596)

Rouf, Tasnuva, Yiwen Mei, Viviana Maggioni, Paul Houser, and Margaret Noonan. "A Physically Based Atmospheric Variables Downscaling Technique." Journal of Hydrometeorology 21, no. 1 (2020): 93-108.

Cosgrove, Brian A., Dag Lohmann, Kenneth E. Mitchell, Paul R. Houser, Eric F. Wood, John C. Schaake, Alan Robock et al. "Real‐time and retrospective forcing in the North American Land Data Assimilation System (NLDAS) project." Journal of Geophysical Research: Atmospheres 108, no. D22 (2003).

Frew, James Edward. "The image processing workbench." PhD diss., University of California, 1990.

Dubayah, R., and S. Loechel. "Modeling topographic solar radiation using GOES data." Journal of Applied Meteorology 36, no. 2 (1997): 141-154.

