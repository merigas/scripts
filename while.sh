#!/bin/bash

while true ; do 
	date
	ping -c 1 google.com &>/dev/null
	if [ $? -eq 0 ]; then 
		echo "Ping google.com is successful"
	else
		echo "Ping google.com is failure"
		break
	fi
	sleep 1
done
