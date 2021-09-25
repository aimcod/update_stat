#!/usr/bin/bash
sudo /usr/bin/dnf-3 check-update | awk 'NR>2 {print "Package Name: "$1"\nVersion Number: "$2"\n"}' > /home/andrei/dailyupdate$(date +%F)
gc=$(cat /home/andrei/dailyupdate$(date +%F)) 
if [ "" = "$gc" ]; then
       	echo -e "to: aimcorp2018@gmail.com\nSubject:No new updates are available on $(hostname)" | /usr/sbin/sendmail -t -f root 
else 
	echo -e "The following updates are available on $(hostname):\n\n""$gc" 
	echo -e "to: aimcorp2018@gmail.com\nSubject:Available updates on $(hostname)\nThe following updates are available on $(hostname):\n\n""$gc" | /usr/sbin/sendmail -t -f root fi
	
#/usr/bin/dnf-3 upgrade -y 
#/usr/bin/dnf-3 autoremove -y
