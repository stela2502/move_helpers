#! /usr/bin/bash

group_name=$1
path=$2

echo "changes the group to '$group_name' for all files in '$path'."
echo "changes access rights to read only for all files/folders in the path."


if getent group "$group_name" >/dev/null 2>&1; then
    echo "Group exists."
else
    echo "Group '$group_name' does not exist."
    echo "Usage: ./fix_owner.sh <groupname> <folder>" 
    exit 1
fi

if ! [ -d $path ]; then
    echo "the path '$path' does not exists!"
    echo "Usage: ./fix_owner.sh <groupname> <folder>"
    exit 1
fi

chown -R :$group_name $path

find "$path" -type d -exec chmod 550 {} +
find "$path" -type f -exec chmod 440 {} +

echo "finished!"
