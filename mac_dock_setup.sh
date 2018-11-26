#!/usr/bin/env bash

# Organising Mac Dock
# to reset to default:  defaults delete com.apple.dock; killall Dock
dockutil_dir="/tmp/dockutil"
dockutil_script="/tmp/dockutil/scripts/dockutil"

mkdir $dockutil_dir
git clone https://github.com/kcrawford/dockutil.git $dockutil_dir && \

# APPS_TO_REMOVE=("Mail.app" "Calendar.app" "Maps.app" "Safari.app" "Launchpad.app" "Siri.app" "")
#APPS_TO_REMOVE=$($dockutil_script --list | awk '{ if($2 ~ /file:/) { print $1 } else { print $1 " " $2 } }')
#APPS_TO_REMOVE=$($dockutil_script --list | awk -v OFS="\"" '{ if($2 ~ /file:/) { print "",$1,"" } else { print "",$1 " " $2,"" } }')

DOCK_APPS_TO_REMOVE=$($dockutil_script --list | awk -v OFS="\"" 'BEGIN{ORS=","} { if($2 ~ /file:/) { print "",$1,"" } else { print "",$1 " " $2,"" } } ')

IFS="," read -ra APPS <<< "$DOCK_APPS_TO_REMOVE"

for app in "${APPS[@]}"
do
        cmd="${dockutil_script} --remove ${app} --no-restart --allhomes"
        echo "Running cmd: ${cmd}"
        eval $cmd
done

DOCK_APPS_TO_ADD=("Google\ Chrome.app","zoom.us.app","Slack.app")
IFS="," read -ra APPS <<< "$DOCK_APPS_TO_ADD"

for app in "${APPS[@]}"
do
        cmd="${dockutil_script} --add /Applications/${app} --no-restart --allhomes"
        echo "Running cmd: ${cmd}"
        eval $cmd
done

# restarting Mac Dock to enable the changes
killall Dock


# Cleaning up files
rm -rf $dockutil_dir
