#!/bin/bash
# -----------------------------------------------------------------
# Ingesting the partitioned direct and diffuse components (already 
# corrected for cloudiness); Calculating solar radiation over 
# topographically complex terrain using IPW function toporad.
#
# By Jing Tao, Duke University
# Last updated: 10/10/2013
# -----------------------------------------------------------------

data_dir=$HOME/HMT-SEUS/Mat/SEUS_NARR_1hr1km_UTM_SW_Anci
out_dir=$HOME/HMT-SEUS/Mat/SEUS_NARR_1hr1km_UTM_CloudTopoCorrSW

for YEAR in {2007..2010}
do
mkdir -p $out_dir/$YEAR
for MON in {1..12} 
  do  
  if [ $MON -lt 10 ]
  then
    typeset -a mp=0
  else
    unset mp
  fi
  endDay=$(for i in `cal $MON $YEAR| tail -3`; do echo $i; done | tail -1)

  for (( Day=1; Day<=$endDay; Day++ ))
  do  
  if [ $Day -lt 10 ]
  then
    typeset -a dp=0
  else
    unset dp
  fi
  for Hour in {0..23}
  do  
  if [ $Hour -lt 10 ]
  then
    typeset -a hp=0
  else
    unset hp
  fi

  anci_dir=$data_dir/$YEAR/$YEAR$mp$MON$dp$Day$hp$Hour

  text2ipw  -l 610  -s 716  $anci_dir/Diff_CloudCorr.txt  > $anci_dir/Diff_CloudCorr
  mkgeoh -c UTM -u meters -o 4135816.67952,57548.6334476 -d -1000,1000 $anci_dir/Diff_CloudCorr > $anci_dir/Diff_CloudCorr_geo
  text2ipw  -l 610  -s 716  $anci_dir/Dirct_CloudCorr.txt  > $anci_dir/Dirct_CloudCorr
  mkgeoh -c UTM -u meters -o 4135816.67952,57548.6334476 -d -1000,1000 $anci_dir/Dirct_CloudCorr > $anci_dir/Dirct_CloudCorr_geo

  tmp=`prhdr $anci_dir/Cosillumi  | tail -4 | head -1`
  cosszn="0.${tmp//[!0-9]}"
  tmp=`prhdr $anci_dir/Cosillumi  | tail -2 | head -1`
  azm="0.${tmp//[!0-9]}"
  
  text2ipw  -l 610  -s 716  $anci_dir/Cosillumi_Scaled.txt  > $anci_dir/Cosillumi_Scaled
  mkgeoh -c UTM -u meters -o 4135816.67952,57548.6334476 -d -1000,1000 $anci_dir/Cosillumi_Scaled > $anci_dir/Cosillumi_Scaled_geo
  mksunh -z $cosszn -a $azm $anci_dir/Cosillumi_Scaled_geo > $anci_dir/Cosillumi_Scaled_geosun
  
  mux $anci_dir/Dirct_CloudCorr_geo $anci_dir/Diff_CloudCorr_geo $anci_dir/Cosillumi_Scaled_geosun DEMviewf $anci_dir/Albedo_geo | toporad -d > $anci_dir/TopoSW
  demux -b 0 $anci_dir/TopoSW > $anci_dir/TopoSW_Total
  demux -b 1 $anci_dir/TopoSW > $anci_dir/TopoSW_Diff
  ipw2bin $anci_dir/TopoSW_Total > $out_dir/$YEAR/TopoSW\_$YEAR$mp$MON$dp$Day$hp$Hour.bin
  ipw2bin $anci_dir/TopoSW_Diff > $out_dir/$YEAR/TopoSW_Diff\_$YEAR$mp$MON$dp$Day$hp$Hour.bin

  done
  done
  done
done
