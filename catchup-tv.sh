#!/bin/bash
echo Content-type: text/plain
echo ""
query=$(echo $QUERY_STRING | grep '[0-9]*-[0-9]*' -o)
echo querry $query >> /var/log/apache2/
inputA=$(date --date=@$(echo $query | cut -d "-" -f 1) +%y%m%d%H%M%S)
inputB=$(date --date=@$(echo $query | cut -d "-" -f 2) +%y%m%d%H%M%S)
echo kodi heur début $inputA et h de fin $inputB >> /var/log/apache2/log

curl http://10.129.8.248/tf1/tf1.m3u8|grep .ts|sed 's/.ts//'> list

for i in $(cat list);
do
    if [[ $i < $inputA ]];
    then
        starting=$i
    fi
done


for i in $(cat list);
do
    if [[ $i < $inputB ]];
    then
        stop=$i
    fi
done
echo date de debut $starting et de fin $stop >> /var/log/apache2/log


echo \#EXTM3U
echo \#EXT-X-VERSION:3
echo \#EXT-X-TARGETDURATION:10
echo \#EXT-X-MEDIA-SEQUENCE:0
echo \#EXT-X-PLAYLIST-TYPE:VOD

for i in $(cat list);
do
    if [[ $i < $inputB ]] && [[ $inputA < $i ]];
    then
		echo \#EXTINF:10.000000,-1 tvg-id="1",CatchUpTV
        echo http://10.129.8.248/tf1/$i.ts
    fi
done

echo \#EXT-X-ENDLIST