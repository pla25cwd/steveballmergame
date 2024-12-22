#!/bin/bash

cd /home/hmontana/sbgameapi/mkhtml

echo "" > out.html
cat pre.html >> out.html
echo "copied pre to file"

# name, time, vistas, wphones, replay link
data=$(sort -n -t"," -k2,2 absolutelyNeverAnySQL.csv)
index=0
for l in $data; do
	((index++))
	if [[ "$index" == "50" ]];then
		break
	fi
	echo "reading data entry $index"

	l_arr=($(echo "$l" | tr ',' ' '))
	l_name="${l_arr[0]}"
	l_time="${l_arr[1]}"
	l_time="$(date --date='@'"$((($l_time-3600000)/1000))"'' '+%Hh %Mm %Ss')"

	l_wphones="${l_arr[2]}"
	l_vistas="${l_arr[3]}"
	unixtime="${l_arr[4]}"
	l_replaylink=''$l_name'_'$unixtime''

	echo "writing data entry"
	echo '		<tr>' >> out.html
	echo '			<td>'"$l_name"'</td>' >> out.html
	echo '			<td>'"$l_time"'</td>' >> out.html
	echo '			<td>'"$l_wphones"'</td>' >> out.html
	echo '			<td>'"$l_vistas"'</td>' >> out.html
	echo '			<td><a href="https://172.16.139.69/sbgame/replays/'"$l_replaylink"'.msreplay">replay</a></td>' >> out.html
	echo '		</tr>' >> out.html
	# worst thing ive ever done

done
echo "done writing data"

cat post.html >> out.html
echo "copied post to file"
cp out.html /var/www/html/sbgame/leaderboard.html
# laziness
cp styles.css /var/www/html/sbgame/leaderboard.css 

