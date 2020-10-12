# Algorithm Package For Downscaling Reanalysis Products
This package contains three components that assembles codes for downscaling coarse-resolution reanalysis fields to high-resolution meteorological forcing for hydrological applications especially over topographically complex regions. Using the 3-hourly North American Regional Reanalysis (NARR) as an example, the packages downscale 32-km  resolution NARR atmospheric temperature, atmospheric pressure, specific humidity, wind speed, downward longwave and shortwave radiation to 1-km and hourly resolution. Users can modify the codes to apply to any other reanalysis products.

Please check our article (Tao and Barros, 2018) for further details.

Tao, Jing, and Ana P. Barros. "Multi-year atmospheric forcing datasets for hydrologic modeling in regions of complex terrain–Methodology and evaluation over the Integrated Precipitation and Hydrology Experiment 2014 domain." Journal of hydrology 567 (2018): 824-842. (https://doi.org/10.1016/j.jhydrol.2016.12.058)

# ElevationCorrection
Package for elevation corrections to atmospheric temperature, atmospheric pressure, specific humidity, and downward longwave radiation.
-	Instead of using the standard lapse rate (i.e., - 6.5 K/km), we derived dynamic lapse rates both in space and time.

# WindAdjustment
Package for downscaling wind speed from coarse-resolution to high-resolution accounting for heterogeneity.
-	Accouting 

# TopoCloudCorrSolarRad 
Package for downscaling coarse-resolution downward shortwave (solar) radiation to high-resolution, meanwhile accounting for topographic and cloudiness corrections.


