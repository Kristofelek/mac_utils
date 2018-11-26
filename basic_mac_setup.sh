#!/usr/bin/env bash
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

