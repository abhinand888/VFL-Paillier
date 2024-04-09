#! /bin/bash
filename=$1

basehours=`cat $filename  | cut -f 3 -d"[" | tr -d "]" | cut -d " " -f2 | cut -c 1-12,14-16 | tr "," "."|head -n 1| cut -d":" -f1`
baseminutes=`cat $filename | cut -f 3 -d"[" | tr -d "]" | cut -d " " -f2 | cut -c 1-12,14-16 | tr "," "."|head -n 1| cut -d":" -f2`

cat $filename | cut -f 3 -d"[" | tr -d "]" | cut -d " " -f2 | cut -c 1-12,14-16 | tr "," "." | tr ":" "," > $1.csv
echo -n "Filename = #$filename#"
awk -v bh=$basehours -v bm=$baseminutes -F ',' '{ sum += (($1-bh)*3600+($2-bm)*60+$3) } END { printf "\tLines = #%d#\t Sum = #%f#\n" ,NR,sum }' "$1.csv"
rm $1.csv

