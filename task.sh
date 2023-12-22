#!/bin/bash
url="https://www.edarabia.com/prayer-times-egypt/"
data=$(curl -s $url)
if [ -z "$data" ];
then
echo "there is a problem connecting to the net, using the last data"
else 

$(echo "$data" >  data.txt)
fi

Fajr=$( grep -Po 'Fajr - ([^<]*)'  "data.txt"  | head -n 1 | tail -c 9)
read FajrH FajrM Fajrampm <<< $(awk -F '[ :]' '{print $1,$2,$NF}' <<< $Sunrise)

Fajrd=$(awk -F '[ :]' '{if($NF == "PM" ){print $1 + 12 + ($2 /60) }else{print $1 + ($2 / 60) } }' <<< $Fajr)


 
Sunrise=$( grep -Po 'Sunrise - ([^<]*)'  "data.txt"  | head -n 1 | tail -c 9)
read SunriseH SunriseM Sunriseampm <<< $(awk -F '[ :]' '{print $1,$2,$NF}' <<< $Sunrise) 

Sunrised=$(awk -F '[ :]' '{if($NF == "PM" ){print $1 + 12 + ($2 /60) }else{print $1 + ($2 / 60) } }' <<< $Sunrise)



Dhuhr=$( grep -Po 'Dhuhr - ([^<]*)'  "data.txt"  | head -n 1 | tail -c 9)
read DhuhrH DhuhrM Dhuhrampm <<< $(awk -F '[ :]' '{print $1,$2,$NF}' <<< $Dhuhr) 

Dhuhrd=$(awk -F '[ :]' '{if($NF == "PM" ){print $1 + ($2 /60) }else{print $1 + ($2 / 60) } }' <<< $Dhuhr)




Asr=$( grep -Po 'Asr - ([^<]*)'  "data.txt"  | head -n 1 | tail -c 9)
read AsrH AsrM Asrampm <<< $(awk -F '[ :]' '{print $1,$2,$NF}' <<< $Asr) 

Asrd=$(awk -F '[ :]' '{if($NF == "PM" ){print $1 + 12 + ($2 /60) }else{print $1 + ($2 / 60) } }'<<< $Asr)



Maghrib=$( grep -Po 'Maghrib - ([^<]*)'  "data.txt"  | head -n 1 | tail -c 9)
read MaghribH MaghribM Maghribampm <<< $(awk -F '[ :]' '{print $1,$2,$NF}' <<< $Maghrib) 

Maghribd=$(awk -F '[ :]' '{if($NF == "PM" ){print $1 + 12 + ($2 /60) }else{print $1 + ($2 / 60) } }' <<< $Maghrib)



Isha=$( grep -Po 'Isha - ([^<]*)'  "data.txt"  | head -n 1 | tail -c 9)
read IshaH IshaM Ishaampm <<< $(awk -F '[ :]' '{print $1,$2,$NF}' <<< $Isha) 

Ishad=$(awk -F '[ :]' '{if($NF == "PM" ){print $1 + 12 + ($2 /60) }else{print $1 + ($2 / 60)  } }'<<< $Isha)

allitems=($Fajrd $Sunrised $Dhuhrd $Asrd $Maghribd $Ishad)

currentH=$(date +%H)
currentM=$(date +%M)

ji=$(awk '{print $1 + ($2 / 60)}' <<< "$currentH $currentM")
wow=$(awk '{for(i = 0; i< 6; i++ ){if($NF < $(i + 1)){print   $(i + 1) - $NF;  exit 0;}}print $1 + 24 - $NF}' <<< "${allitems[@]} $ji")
 
theintegerpart=$(awk -F '[.]' '{print $1}' <<< $wow)

thedecimelpart=$(awk -F '[.]' '{print "0."$2}' <<< $wow)

time=$(awk -F '[ ]' '{print "the remainguing time for next prayer is " $1 " hours and " $NF * 60 " minutes" }' <<< "$theintegerpart $thedecimelpart")

echo "--------------------------------------------------------------------------------"
echo "warning this programme needs internet connection and will be displaying  the last updated data and the accuracy is not perfect as it depands on the geographic location"
echo "the todays prayers times are :"
echo "-------------------------------------"
echo "Fajr:" $Fajr
echo "Sunrise:" $Sunrise
echo "Dhuhr:" $Dhuhr
echo "Asr:" $Asr
echo "Maghrib:" $Maghrib
echo "Isha:" $Isha

echo "-------------------------------------"
echo $time


