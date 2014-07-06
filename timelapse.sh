#!/bin/bash

# JoernBrauns.DE Webcam-Skript
# timelapse.sh
# JB_cam -> https://github.com/JoernBrauns/JB_cam
# Version 0.0.1

# Zeit eindeutig festlegen
imt=`date --rfc-2822`
imf=`date -d "$imt" +%Y%m%d`

# Pfade anhand vom Datum definieren

snap_dir=/home/pi/snapshots/
sort_year=`date -d "$imt" +%Y`
sort_month=`date -d "$imt" +%m`
sort_day=`date -d "$imt" +%d`
sort_ges="$sort_year"/"$sort_month"/"$sort_day"
action_dir="$snap_dir$sort_ges"
process_dir="$snap_dir$sort_ges"_process

# Temporäre Daten erzeugen
echo "Erzeuge Temporäre Daten ..."
cp -r  $action_dir $process_dir
ls $process_dir/*.jpg| awk 'BEGIN{ a=0 }{ printf "mv %s '$process_dir/'%03d.jpg\n", $0, a++ }' | bash

# Timelapse Video erzeugen
echo "Erzeuge Timelapse Video" $action_dir/$imf-timelapse.mp4 "..."
avconv -r 12 -i $process_dir/%03d.jpg -r 12 -vcodec libx264 -g 6 -qscale 5 $action_dir/$imf-timelapse.mp4

# Temporäre Daten löschen
echo "Lösche Temporäre Daten ..."
rm -r $process_dir

# FTP-Upload
ln -sf $action_dir/$imf-timelapse.mp4 /home/pi/snapshots/lasttimelapse.mp4
echo "Video auf Webserver laden..."
ncftpput -f ftp.cfg /htdocs/uploads /home/pi/snapshots/lasttimelapse.mp4
echo "Video erfolgreich hochgeladen!"

exit 0
