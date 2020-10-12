# Algorithm Package For Downscaling Reanalysis Products
By Jing Tao (jingtao@lbl.gov)

Last update: October 12, 2020

This package contains three components that assemble codes and scripts to downscale coarse-resolution reanalysis fields to high-resolution meteorological forcing for hydrological applications, especially over topographically complex regions. Using the 3-hourly North American Regional Reanalysis (NARR) as an example, the packages downscale 32-km  resolution NARR atmospheric temperature, atmospheric pressure, specific humidity, wind speed, downward longwave and shortwave radiation to 1-km and hourly resolution. Users can modify the codes to apply to any other reanalysis products.

Please check Tao and Barros (2018) for further details. Contact me at jingtao@lbl.gov if you have any questions.

# ElevationCorrection
A package for elevation corrections to atmospheric temperature, atmospheric pressure, specific humidity, and downward longwave radiation.
-	Instead of using the standard lapse rate (i.e., - 6.5 K/km), we derived dynamic lapse rates in space and time.

# WindAdjustment
A package for downscaling wind speed from coarse-resolution to high-resolution, accounting for fine-resolution heterogeneity in friction velocity.
-	Based on a high-resolution (e.g., 1 km) land cover map, the package first derives maps of roughness length and displacement height at the consistent spatial resolution. 
-	The package then derives high-resolution friction velocity (Equation 5) and then the adjusted wind speeds (Equation 6 in Tao and Barros (2018)). 

# TopoCloudCorrSolarRad 
A package for downscaling coarse-resolution downward shortwave (solar) radiation to high-resolution, meanwhile accounting for topographic and cloudiness corrections.
-	Cloudiness correction to NARR solar data is conducted by reproducing the spatial pattern observed by GCIP SRB (GSRB) solar radiation product.
-	The package temporally downscales 3-hourly shortwave radiation to hourly, relying on hourly solar zenith angle and the diurnal cycle (Equation 8 in Tao and Barros (2018)).
-	Based on GSRB data, the package computes hourly transmittance to partition the hourly shortwave radiation to direct and diffuse components. 
-	The bash script uses the Image Processing Workbench (IPW) software (Frew, 1990) to compute the high-resolution illumination angle, sky view factor, and terrain configuration factor. Ancillary datasets include DEM and hourly albedo that can be derived from MODIS BRDF products (details can be found in Tao and Barros, 2019). 
-	Input the partitioned direct and diffuse components to IPW to perform the topographic correction to each component.

# Reference 
Tao, Jing, and Ana P. Barros. "Multi-year atmospheric forcing datasets for hydrologic modeling in regions of complex terrain–Methodology and evaluation over the Integrated Precipitation and Hydrology Experiment 2014 domain." Journal of Hydrology, 567 (2018): 824-842. (https://doi.org/10.1016/j.jhydrol.2016.12.058)

Tao, Jing, and Ana P. Barros. "Multi-year surface radiative properties and vegetation parameters for hydrologic modeling in regions of complex terrain—Methodology and evaluation over the Integrated Precipitation and Hydrology Experiment 2014 domain." Journal of Hydrology: Regional Studies 22 (2019): 100596. (https://doi.org/10.1016/j.ejrh.2019.100596)

Frew, James Edward. "The image processing workbench." PhD diss., University of California, 1990.
