#!/bin/bash

# JoernBrauns.DE Webcam-Skript
# cam.sh
# JB_cam -> https://github.com/JoernBrauns/JB_cam
# Version 0.0.1 - 1920 x 1080 -> 1280 x 720 + Beschriftung -> auf FTP-Server hochladen

# Zeit eindeutig festlegen
imt=`date --rfc-2822`
imf=`date -d "$imt" +%Y%m%d%H%M%S`
irt=`date -d "$imt" +%e.' '%B' '%Y' - '%H:%M' Uhr'`
brand="Branding"
location="Ort"

# Pfade anhand vom Datum definieren

sort_year=`date -d "$imt" +%Y`
sort_month=`date -d "$imt" +%m`
sort_day=`date -d "$imt" +%d`
sort_ges="$sort_year"/"$sort_month"/"$sort_day"/

# Verzeichnisse erstellen, sofern noch nicht vorhanden

snapf_dir=/home/pi/snapshotsfull/

if [ ! -d $snapf_dir$sort_year ]; then
        mkdir $snapf_dir$sort_year
        echo "Verzeichnis" $snapf_dir$sort_year "erstellt!"
fi

if [ ! -d $snapf_dir$sort_year/$sort_month ]; then
        mkdir $snapf_dir$sort_year/$sort_month
        echo "Verzeichnis" $snapf_dir$sort_year/$sort_month "erstellt!"
fi

if [ ! -d $snapf_dir$sort_year/$sort_month/$sort_day ]; then
        mkdir $snapf_dir$sort_year/$sort_month/$sort_day
        echo "Verzeichnis" $snapf_dir$sort_year/$sort_month/$sort_day "erstellt!"
fi

snap_dir=/home/pi/snapshots/

if [ ! -d $snap_dir$sort_year ]; then
        mkdir $snap_dir$sort_year
        echo "Verzeichnis" $snap_dir$sort_year "erstellt!"
fi

if [ ! -d $snap_dir$sort_year/$sort_month ]; then
        mkdir $snap_dir$sort_year/$sort_month
        echo "Verzeichnis" $snap_dir$sort_year/$sort_month "erstellt!"
fi

if [ ! -d $snap_dir$sort_year/$sort_month/$sort_day ]; then
        mkdir $snap_dir$sort_year/$sort_month/$sort_day
        echo "Verzeichnis" $snap_dir$sort_year/$sort_month/$sort_day "erstellt!"
fi


# Dateiname 1920 x 1080
img=$imf.jpg

# Dateiname 1280 x 720
imk=$imf-snapshot.jpg

# Pfad 1920 x 1080
imp=/home/pi/snapshotsfull/$sort_ges

# Pfad 1280 x 720
imn=/home/pi/snapshots/$sort_ges

# Pfad und Dateiname 1920 x 1080
impn=$imp$img

# Pfad und Dateiname 1280 x 720
impk=$imn$imk

# Bild aufnehmen und im full-Verzeichnis speichern
echo "Erstelle" $impn  "..."
/usr/bin/raspistill -o $impn -n -w 1920 -h 1080

# Überprüfen ob Aufnahme vorhanden und nicht leer
if [ -s $impn ]; then
	# Alles ok
	echo "Aufnahme erfolgreich erstellt!"
else
	# Erneute Aufnahme
	echo "Aufnahme fehlerhaft!"
	/usr/bin/raspistill -o $impn -n -w 1920 -h 1080
	echo "Neue Aufnahme erstellt!"
fi

# Bild verkleinern und beschriften
echo "Bild verkleinern und beschriften..."
/usr/bin/convert $impn -resize 1280 -quality 85 -compress jpeg -fill white -pointsize 30 -undercolor '#00000099' \-gravity SouthWest -annotate +0+0 "$brand" \-gravity SouthEast -annotate +0+0 "$location - $irt" $impk
echo "Bild erfolgreich verkleinert und beschriftet!"
ln -sf $impk /home/pi/snapshots/lastsnap.jpg

# Bild auf den Webserver laden
mintest=`date -d "$imt" +%M`
if [ $mintest == '00' ] || [ $mintest == '15' ] || [ $mintest == '30' ] || [ $mintest == '45' ]; then
echo "Bild auf Webserver laden..."
ncftpput -f ftp.cfg /htdocs/uploads /home/pi/snapshots/lastsnap.jpg
echo "Bild erfolgreich hochgeladen!"
fi

exit 0
