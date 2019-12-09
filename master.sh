#!/bin/bash

start=1
dir='/mnt/lustre01/work/ba1035/a270092/runtime/oifsamip'

#res='T159'
for res in {T511,T1279}
do
	if [ $res == 'T1279' ]
	then
		end=40
	else
		end=100
	fi

	for e in {11,16}
	do
		for var in nao #T2M z500 MSL #U MSL T2M SD SF
		do
			if [ "$var" == "z500" ]
			then
				printf "z500_cat.sh"
				./z500_cat.sh $e $start $end $res $var $dir
			fi
			printf "seasmean.sh"
			#./seasmean.sh $e $start $end $res $var $dir
		done
	done

	for e in {11,16}
	do
		for var in nao #T2M z500 MSL #U T2M SD SF synact NAO
		do
			if [ "$var" == "synact" ]
			then
				printf "synact_PAMIP.job"
				./synact_PAMIP.job $e $start $end $res $var $dir
				./post_data_oifs_synact_stddev.job $e $start $end $res $var $dir
			elif [ "$var" == "nao" ]
			then
				printf "post_data_oifs_nao.job"
				./post_data_oifs_nao.job $e $start $end $res $var $dir
			else
				printf "ensmean.sh"
				./ensmean.sh $e $start $end $res $var $dir
				./split_to_seasons.sh $e $start $end $res $var $dir
			fi
			
		done
	done
done
