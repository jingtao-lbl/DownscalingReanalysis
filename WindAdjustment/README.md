# Algorithm Package For Downscaling Reanalysis Products
By Jing Tao (jingtao@lbl.gov)
(Last updated on October 12, 2020)

This repository contains three packages that assemble codes and scripts for downscaling coarse-resolution reanalysis fields while also accounting for topographic (and cloudiness) effects. The packages aim to generate high-resolution, high-accuracy meteorological forcing for hydrological applications, especially over topographically complex regions. Using the 3-hourly North American Regional Reanalysis (NARR) as an example, the packages downscale 32-km resolution NARR atmospheric temperature, atmospheric pressure, specific humidity, wind speed, downward longwave and shortwave radiation to 1-km and hourly resolution. Users can modify the codes to apply to any other reanalysis products.

Please check Tao and Barros (2018) for further details. Contact Dr. Jing Tao at jingtao@lbl.gov if you have any questions.

# ElevationCorrection

# WindAdjustment
A package for downscaling reanalysis wind speed from coarse-resolution to high-resolution, accounting for fine-resolution heterogeneity.
-	Based on a high-resolution (e.g., 1 km) land cover map, the package first derives maps of roughness length and displacement height at the consistent spatial resolution. 
-	The package then derives high-resolution friction velocity and then generates wind speeds adjusted for high-resolution subgrid variability (Equation 6 in Tao and Barros (2018)). 

# TopoCloudCorrSolarRad 

# Reference 
Tao, Jing, and Ana P. Barros. "Multi-year atmospheric forcing datasets for hydrologic modeling in regions of complex terrain–Methodology and evaluation over the Integrated Precipitation and Hydrology Experiment 2014 domain." Journal of Hydrology, 567 (2018): 824-842. (https://doi.org/10.1016/j.jhydrol.2016.12.058)

Tao, Jing, and Ana P. Barros. "Multi-year surface radiative properties and vegetation parameters for hydrologic modeling in regions of complex terrain—Methodology and evaluation over the Integrated Precipitation and Hydrology Experiment 2014 domain." Journal of Hydrology: Regional Studies 22 (2019): 100596. (https://doi.org/10.1016/j.ejrh.2019.100596)


