JB_cam
======

A webcam script based on the Raspberry Pi and the original Raspberry Pi Camera

Due to some requests I published this basic webcam script.

#INFO
At the moment the comments in the sourcecode are only in German.
I will fix this soon.

Contact: http://www.joernbrauns.de/kontakt/

#DEMO#
http://www.joernbrauns.de/webcam/

#INSTALLATION#

Download the code from this site to /home/pi/ on your Raspberry Pi running the latest version of Raspbian

##Install required packages##
```
sudo apt-get install ncftp
sudo apt-get install imagemagick
sudo apt-get install libav-tools
```
##Set permissions##
```
sudo chmod u+x /home/pi/cam.sh
sudo chmod u+x /home/pi/timelapse.sh
sudo chmod u+x /home/pi/timelapsefull.sh
```
##Create folders##
```
mkdir snapshots
mkdir snapshotsfull
```
##Install cronjob##
```
  crontab -e
```
```
  */5 6-18 * * * /home/pi/cam.sh
  00 19 * * * /home/pi/cam.sh
  01 19 * * * /home/pi/timelapse.sh
  40 19 * * * /home/pi/timelapsefull.sh
```
