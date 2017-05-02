#!/bin/bash

if [ "$(id -u)" -ne "0" ]; then
	echo "You must run the command with root priviledges."
	exit 1
fi

echo "Failed SSH login attempts per IP"
echo "--------------------------------"

sudo zgrep 'failure;' /var/log/auth.log* | sed 's/^.*rhost=//g' | cut -d " " -f 1 | sed '/^[^0-9]*$/d' | sort | uniq -c | sort -n -r | head -n 20
