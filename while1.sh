#!/bin/bash

while read line; do 

	User=$(echo $line |awk -F : '{print $1}')
	pass=$(echo $line |awk -F : '{print $2}')

	id $User &>/dev/null
	if [ $? -eq 0 ]; then
		echo "User :: $User already exists ... Skipping"
		continue
	fi
	useradd $User &>/dev/null
	echo $pass |passwd --stdin $User &>/dev/null
	id $User &>/dev/null
	if [ $? -eq 0 ]; then	
		echo "User :; $User added Successfully"
		continue
	else
		echo "User :: $User is not added"
	fi
done <users
