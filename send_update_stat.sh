
#!/usr/bin/bash

#set -x

#trap read debug

date_now=$(date "+%a %d %b")
rpm_show_last50=$(rpm -qa --last | head -n 50)
rpm_count=$(rpm -qa --last | wc -l)
rpm_get_date=$(rpm -qa --last | head -n 1 | awk '{print $2" "$3" "$4}')
updates_list="/home/andrei/dailyupdate_$(date +%F)"
bak="/home/andrei/dailyupdate_$(date +%F%H%M%S).bak"

/usr/bin/dnf-3 check-update | awk 'NR>2 {print "Package Name: "$1"\nVersion Number: "$2"\n"}' > $updates_list && cat $updates_list > $bak

get_count=$(wc $updates_list -m | awk '{print $1}')

if [[ $get_count -eq 0 ]]
then

	echo -e "to: aimcorp2018@gmail.com\nSubject:No updates were installed today.\nA total of $rpm_count updates were installed recently. Showing the latest 50:\n\n$rpm_show_last50" | /usr/sbin/sendmail -t -f root

else

	echo -e "to: aimcorp2018@gmail.com\nSubject:Available updates on $(hostname)\nThe following updates are available on $(hostname):\n\n""$(cat $updates_list)\n\n\nPerforming Automatic Updates..." | /usr/sbin/sendmail -t -f root
 /usr/bin/dnf-3 upgrade -y &>2
 /usr/bin/dnf-3 autoremove -y &>2

rpm_today=$(rpm -qa --last | grep "$date_now")
rpm_today_count=$(rpm -qa --last | grep "$date_now"  | wc -l)

 echo -e "to: aimcorp2018@gmail.com\nSubject:Updates were installed on $(hostname)\nA total of $rpm_today_count updates were installed today. Here's the list:\n$rpm_today" | /usr/sbin/sendmail -t -f root
 

fi

rm -f $updates_list

