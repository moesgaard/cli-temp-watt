#!/bin/bash
function sdisplay () {
IFS=$'\n'
BOF="|"
VOV=""
green=$(tput setaf 2)
blue=$(tput setaf 4)
red=$(tput setaf 1)
normal=$(tput sgr0)
echo -e "Watt usage:"
BOB=$(sensors | grep -E "(SVI2_P_Core|SVI2_P_SoC|W)" )
ZOBE=0
for ill in $BOB
do
	ZOB=$( echo $ill | awk '{print $2}' | grep -Eo '[0-9]*\.[0-9]*' | cut -d. -f1 )
	VOV=""
	BOBBY=$( echo $ill | awk '{print $1}' | sed 's/SVI2_P_/Watt /g' | sed 's/PPT/GPU Watt/g' | sed 's/://g' )
	for ins in $( seq 0 $ZOB )
	do 
		VOV+=$BOF
	done
	
	if [ $ZOB -le 79  ]; 
	then
		printf "%-10s\t%-10s\t%-80s\n" $BOBBY":"  "${green}$ZOB${normal}" $VOV 
	
	elif  [ $ZOB -ge 80   ];
	then	
		printf "%-10s\t%-10s\t%-80s\n" $BOBBY":"  "${blue}$ZOB${normal}" $VOV 
	
	elif [ $ZOB -ge 120  ];
	then
		printf "%-10s\t%-10s\t%-80s\n" $BOBBY  "${red}$ZOB${normal}" $VOV 
	fi


	ZOBE="$ZOBE+$ZOB"
done
printf "%-10s\t%-8d\t%-10s\n" $( echo "Total Watt")  $( echo  "$ZOBE" | bc) 

ZOB=0
BOB=$(sensors | grep "T" | grep -v "PPT" | grep -v "VTT" | grep -v "EC_"   )
echo -e "\nCPU:"
for ill in $BOB
do
	ZOB=$( echo $ill | awk '{print $2}' | grep -Eo '[0-9]*\.[0-9]*' | cut -d. -f1 | xargs )
	VOV=""
	BOBBY=$( echo $ill | awk '{print $1}' )
	for ins in $( seq 0 $ZOB )
		do 
		VOV+=$BOF
	done
	if [ $ZOB -le 55  ]; 
	then
		printf "%-10s\t%-5s\t%-80s\n" $BOBBY  "${green}$ZOB${normal}" $VOV 
	elif  [ $ZOB -ge 56   ];
	then	
		printf "%-10s\t%-5s\t%-80s\n" $BOBBY  "${blue}$ZOB${normal}" $VOV 
	elif [ $ZOB -ge 71 ];
	then
		printf "%-10s\t%-5s\t%-80s\n" $BOBBY  "${red}$ZOB${normal}" $VOV 
	fi
done

echo -e  "\nGPU:"
BOB=$(sensors | grep -E  "(junction|edge|mem)")
for ill in $BOB
do
	ZOB=$( echo $ill | awk '{print $2}' | grep -E '[0-9]*\.[0-9]*' | cut -d. -f1  )
	VOV=""
	BOBBY=$( echo $ill | awk '{print $1}')
	for ins in $( seq 0 $ZOB )
	do 
		VOV+=$BOF
	done
	printf "%-10s\t%-5d\t%-80s\n" $BOBBY  $ZOB   $VOV
done
echo -e  "\ntemps:"
BOB=$(sensors | grep -E  "thermistor")
for ill in $BOB
do
	ZOB=$( echo $ill | awk '{print $2}' | grep -E '[0-9]*\.[0-9]*' | cut -d. -f1  )
	VOV=""
	BOBBY=$( echo $ill | awk '{print $1}')
	for ins in $( seq 0 $ZOB )
	do 
		VOV+=$BOF
	done
	printf "%-10s\t%-5d\t%-80s\n" $BOBBY  $ZOB   $VOV
done
}
export -f sdisplay
watch -n $1 -c sdisplay
