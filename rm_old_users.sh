#!/bin/bash
# A bash script that removes "it*" users that haven't logged into the system at all

# Total removed users
total=0 

# Only root can run this 
if [ ! "$(whoami)" = "root" ]
then
	echo "Please run script as root."
	exit 1
fi

# We accept no arguments!
if [ $# -gt 0 ]; then
	echo "USAGE: $0 "
	exit 1
fi

# Users that have logged into the system at least once
last | awk '{print $1}' | grep "^it" | sort | uniq > .active_users
# Registered users 
cat /etc/passwd | awk 'BEGIN {FS=":"} {print $1}' | grep "^it" | sort > .registered_users
# Users to be removed
diff .active_users .registered_users | sed '/^[^>]/d' | sed 's/^> \(.*\)/\1/' > .users_to_remove
total=$(cat .users_to_remove | wc -l)
# Remove users and log actions
for user in $(cat .users_to_remove); do
	deluser --remove-home  $user;
	deluser --group  $user;
 	echo "$(date +%d-%m-%Y) $(whoami) $0[$$]: $user was successfully removed" >> .removed_users.log
done

# Remove temporary files
rm .active_users .registered_users .users_to_remove

echo "$total users were removed"
echo "Verbose logs are saved at .removed_users.log"

