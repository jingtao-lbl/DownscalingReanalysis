#!/bin/bash
# -------------------------------------------------------------------------
# Calculate the cosine of local illumination angle using IPW function shade
# 
# By Jing Tao, Duke University
# Last updated: 10/10/2013
# -------------------------------------------------------------------------

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
  echo $anci_dir
  
#  text2ipw  -l 610  -s 716  ./NARR_Terrain.txt  > NARR_Terrain
#  mkgeoh -c UTM -u meters -o 4135816.67952,57548.6334476 -d -1000,1000 NARR_Terrain > NARR_Terrain_geo
  
  gradient NARR_Terrain_geo | shade `sunang -b 35 -l -82 -t $YEAR,$MON,$Day,$Hour | tail -1` > $anci_dir/NARR_Terrain_Cosillumi
  ipw2bin $anci_dir/NARR_Terrain_Cosillumi > $anci_dir/NARR_Terrain_Cosillumi.bin

  done
  done
  done
done
