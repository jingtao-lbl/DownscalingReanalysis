#!/bin/bash
# -------------------------------------------------------------
# Calculate sunrise and sunset time using IPW function sunlight
# 
# By Jing Tao, Duke University
# Last updated: 10/10/2013
# -------------------------------------------------------------

data_dir=$HOME/HMT-SEUS/Mat/SEUS_NARR_1hr1km_UTM_SW_Anci
out_dir=$HOME/HMT-SEUS/Mat/SEUS_NARR_1hr1km_UTM_TopoCorrSW

for YEAR in {2009..2010}
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
	for i in {1..400297}
	do
		VAR=`sed -n ''$i' p' ../Data/latlon_noNaN.txt`
		lat=$(for ii in `echo $VAR`; do echo $ii; done | head -1)
		lon=$(for ii in `echo $VAR`; do echo $ii; done | tail -1)
		sunlight -d $YEAR,$MON,$Day -b $lat -l $lon -a >> sunrisesunset.dat
	done
	for Hour in {0..23}
	do  
		if [ $Hour -lt 10 ]
		then
			typeset -a hp=0
		else
			unset hp
		fi
		anci_dir=$data_dir/$YEAR/$YEAR$mp$MON$dp$Day$hp$Hour
		cp sunrisesunset.dat $anci_dir
	done
  rm sunrisesunset.dat
  done
  done
done
