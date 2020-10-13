#!/bin/bash
# -----------------------------------------------------------------
# Preparing ancillary data: Sky view and terrain configuration factors
#
# By Jing Tao, Duke University
# Last updated: 10/10/2013
# -----------------------------------------------------------------

text2ipw  -l 610  -s 716  ./Data/dem_noheader.txt  > DEM
mkgeoh -c UTM -u meters -o 4135816.67952,57548.6334476 -d -1000,1000 DEM > DEMgeo

viewf DEMgeo > DEMviewf
demux -b 0  DEMviewf > DEMtestviewfband0
demux -b 1  DEMviewf > DEMtestviewfband1
ipw2bin DEMtestviewfband0 > DEMviewfSVF
ipw2bin DEMtestviewfband1 > DEMviewfTCF


