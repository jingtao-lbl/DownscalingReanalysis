# Algorithm Package For Downscaling Reanalysis Products
By Jing Tao (jingtao@lbl.gov)
(Last updated on October 12, 2020)

This repository contains three packages that assemble codes and scripts for downscaling coarse-resolution reanalysis fields while also accounting for topographic (and cloudiness) effects. The packages aim to generate high-resolution, high-accuracy meteorological forcing for hydrological applications, especially over topographically complex regions. Using the 3-hourly North American Regional Reanalysis (NARR) as an example, the packages downscale 32-km resolution NARR atmospheric temperature, atmospheric pressure, specific humidity, wind speed, downward longwave and shortwave radiation to 1-km and hourly resolution. The generated atmospheric forcing datasets have been used for hydrological forcasting practice (see Tao et al., 2016). Users can modify the codes to apply to any other reanalysis products.

Please check Tao and Barros (2018) for further details. Contact Dr. Jing Tao at jingtao@lbl.gov if you have any questions.

# - ElevationCorrection
A package for elevation corrections to reanalysis atmospheric temperature, atmospheric pressure, specific humidity, and downward longwave radiation.
-	Instead of using the standard lapse rate (i.e., - 6.5 K/km), we derived dynamic lapse rates in space and time.

# - WindAdjustment
A package for downscaling reanalysis wind speed from coarse-resolution to high-resolution, accounting for fine-resolution heterogeneity.
-	Based on a high-resolution (e.g., 1 km) land cover map, the package first derives maps of roughness length and displacement height at the consistent spatial resolution. 
-	The package then derives high-resolution friction velocity and then generates wind speeds adjusted for high-resolution subgrid variability (Equation 6 in Tao and Barros (2018)). 

# - TopoCloudCorrSolarRad 
A package for downscaling coarse-resolution reanalysis downward shortwave (solar) radiation to high-resolution, meanwhile accounting for topographic and cloudiness corrections.
-	Cloudiness correction to NARR solar data is conducted by reproducing the spatial pattern observed by GCIP SRB (GSRB) solar radiation product.
-	The package temporally downscales 3-hourly shortwave radiation to hourly, relying on hourly solar zenith angle and the diurnal cycle (Equation 8 in Tao and Barros (2018)).
-	Based on GSRB data, the package computes hourly transmittance to partition the hourly shortwave radiation to direct and diffuse components. 
-	Based on an existing method modeling topographic solar radiation (Dubayah and Loechel, 1997), the bash script uses the Image Processing Workbench (IPW) software (Frew, 1990) to compute the high-resolution illumination angle, sky view factor, and terrain configuration factor. Ancillary datasets include DEM, hourly solar zenith angle, and hourly albedo that can be derived from MODIS BRDF products (details can be found in Tao and Barros, 2019). 
-	Input the partitioned direct and diffuse components to IPW to perform the topographic correction to each component.

# Reference 

Tao, Jing, Di Wu, Jonathan Gourley, Sara Q. Zhang, Wade Crow, Christa Peters-Lidard, and Ana P. Barros. "Operational hydrological forecasting during the IPHEx-IOP campaign–Meet the challenge." Journal of Hydrology 541 (2016): 434-456. (https://doi.org/10.1016/j.jhydrol.2016.02.019)

Tao, Jing, and Ana P. Barros. "Multi-year atmospheric forcing datasets for hydrologic modeling in regions of complex terrain–Methodology and evaluation over the Integrated Precipitation and Hydrology Experiment 2014 domain." Journal of Hydrology 567 (2018): 824-842. (https://doi.org/10.1016/j.jhydrol.2016.12.058)

Tao, Jing, and Ana P. Barros. "Multi-year surface radiative properties and vegetation parameters for hydrologic modeling in regions of complex terrain—Methodology and evaluation over the Integrated Precipitation and Hydrology Experiment 2014 domain." Journal of Hydrology: Regional Studies 22 (2019): 100596. (https://doi.org/10.1016/j.ejrh.2019.100596)

Frew, James Edward. "The image processing workbench." PhD diss., University of California, 1990.

Dubayah, R., and S. Loechel. "Modeling topographic solar radiation using GOES data." Journal of Applied Meteorology 36, no. 2 (1997): 141-154.

