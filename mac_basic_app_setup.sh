#!/usr/bin/env bash

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

rm ${CHROME_INSTALL_LOC}
rm ${SLACK_INSTALL_LOC}
rm ${ZOOM_INSTALL_LOC}

hdiutil detach /Volumes/Google\ Chrome
hdiutil detach /Volumes/Slack.app
