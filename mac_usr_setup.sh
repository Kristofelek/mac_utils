#!/usr/bin/env bash

# Setting up a user account
echo "Creating a new user:"

echo "Enter user shorthand (3 letters):"
read USR_HANDLE

if [[ -z $USR_HANDLE || ${#USR_HANDLE} != 3 ]]; then
	echo "User handle incorrect, please try running the script again..."
	exit 1
fi

echo "Enter user full name:"
read FULL_NAME

echo "Enter user password:"
read -s USR_PASS

echo "Confirm user password:"
read -s USR_PASS_CONFIRM

if [[ $USR_PASS != $USR_PASS_CONFIRM ]]; then
	echo "Passwords do not match, please try running the script again..."
	exit 1
fi

echo "You will be prompted for ADMIN password in a moment..."
sudo sysadminctl -addUser "${USR_HANDLE}" -fullName "${FULL_NAME}" -password "${USR_PASS}"

echo "Now please login into the new account and complete the initial account setup using the UI"
echo "Once the user setup is complete log back into the admin account and run the rest of the scripts."
