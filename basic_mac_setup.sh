# Installing brew
BREW_SOURCE="https://raw.githubusercontent.com/Homebrew/install/master/install"

BREW_LOC=$(which brew)

if [[ -z $BREW_LOC ]]; then
	echo "Installing brew...";
	/usr/bin/ruby -e "$(curl -fsSL ${BREW_SOURCE})";
	brew install wget --with-libressl }
else
	echo "brew already installed..."
fi


# Setting up a user account
DEFAULT_PASS="-"
USER_HANDLE=""
FULL_NAME=""

if [[ -z $USR_PASS ]]; then
	USR_PASS=$DEFAULT_PASS
fi

echo "Creating a new user:"
echo "Enter user shorthand (3 letters)"
read USER_HANDLE
echo "Enter user full name"
read FULL_NAME
echo "Enter user password"
read USR_PASS

echo "You will be prompted for ADMIN password in a moment..."
sudo sysadminctl -addUser ${USER_HANDLE} -fullName "${FULL_NAME}" -password ${USR_PASS} # will prompt for user password


# Auto install of Chrome, Slack, Zoom
DOWNLOAD_FOLDER="/tmp"

#CHROME
CHROME_SOURCE="https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"
CHROME_INSTALL_LOC="${DOWNLOAD_FOLDER}/googlechrome.dmg"

wget ${CHROME_SOURCE} -O ${CHROME_INSTALL_LOC} && \
hdiutil attach -nobrowse ${CHROME_INSTALL_LOC} && \
sudo cp -r /Volumes/Google\ Chrome/Google\ Chrome.app /Applications/

#SLACK
SLACK_SOURCE="https://slack.com/ssb/download-osx"
SLACK_INSTALL_LOC="${DOWNLOAD_FOLDER}/slack.dmg"

wget ${SLACK_SOURCE} -O ${SLACK_INSTALL_LOC} && \
hdiutil attach -nobrowse ${SLACK_INSTALL_LOC} && \
sudo cp -r /Volumes/Slack.app/Slack.app /Applications/

# ZOOM
ZOOM_SOURCE="https://zoom.us/client/latest/Zoom.pkg"
ZOOM_INSTALL_LOC="${DOWNLOAD_FOLDER}/Zoom.pkg"

wget ${ZOOM_SOURCE} -O ${ZOOM_INSTALL_LOC} && \
#open ${ZOOM_INSTALL_LOC} && \
sudo installer -pkg /tmp/Zoom.pkg -target /

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

rm ${CHROME_INSTALL_LOC}
rm ${SLACK_INSTALL_LOC}
rm ${ZOOM_INSTALL_LOC}

hdiutil detach /Volumes/Google\ Chrome
hdiutil detach /Volumes/Slack.app
