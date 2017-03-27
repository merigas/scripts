#!/bin/bash

if [ `id -u` -ne 0 ]; then 
	echo "Please run the script as root user or sudo command"
	exit 1
fi

if [ -f `which lsb_release &>/dev/null` ]; then 
	HOST_OS=$(lsb_release -a 2>/dev/null|grep 'Distributor ID' | cut -d ':' -f2 |xargs)
fi

if [ -z "$HOST_OS" -a -f `which rpm` ]; then 
	HOST_OS=$(rpm -qi  basesystem |grep Vendor |cut -d : -f2 |xargs)
fi

if [ -z "$HOST_OS" ]; then 
	echo "Unable to find the host OS"
	exit
fi

echo "Host OS = $HOST_OS"
