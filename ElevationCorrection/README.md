# Algorithm Package For Downscaling Reanalysis Products
By Jing Tao (jingtao@lbl.gov)
(Last updated on October 12, 2020)

This repository contains three packages that assemble codes and scripts for downscaling coarse-resolution reanalysis fields while also accounting for topographic (and cloudiness) effects. The packages aim to generate high-resolution, high-accuracy meteorological forcing for hydrological applications, especially over topographically complex regions. Using the 3-hourly North American Regional Reanalysis (NARR) as an example, the packages downscale 32-km resolution NARR atmospheric temperature, atmospheric pressure, specific humidity, wind speed, downward longwave and shortwave radiation to 1-km and hourly resolution. Users can modify the codes to apply to any other reanalysis products.

Please check Tao and Barros (2018) for further details. Contact Dr. Jing Tao at jingtao@lbl.gov if you have any questions.

# ElevationCorrection
A package for elevation corrections to reanalysis atmospheric temperature, atmospheric pressure, specific humidity, and downward longwave radiation.
-	Instead of using the standard lapse rate (i.e., - 6.5 K/km), we derived dynamic lapse rates in space and time.

# WindAdjustment
# TopoCloudCorrSolarRad 

# Reference 
Tao, Jing, and Ana P. Barros. "Multi-year atmospheric forcing datasets for hydrologic modeling in regions of complex terrain–Methodology and evaluation over the Integrated Precipitation and Hydrology Experiment 2014 domain." Journal of Hydrology, 567 (2018): 824-842. (https://doi.org/10.1016/j.jhydrol.2016.12.058)

