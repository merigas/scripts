#!/bin/bash

if [ $# -eq 0 ]; then 
	echo "Pass number of lines you want to print"
	echo "Ex: $0 3  --> Print three strred lines"
	exit 
fi

no=$1
a=1
while [ $a -le $no ]; do
	i=1
	while [ $i -le $a ]; do
		echo "*"
		i=$(($i+1))
	done |xargs
	a=$(($a+1))
done
	
