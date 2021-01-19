#! /bin/bash

# Require that this runs as root.
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"


# Define some global variables.
working_directory="/tmp/google-chrome-installation"
repo_file="/etc/yum.repos.d/google-chrome.repo"


# Work in our working directory.
echo "Working in ${working_directory}"
mkdir -p ${working_directory}
rm -rf ${working_directory}/*
pushd ${working_directory}


# Add the official Google Chrome Centos 7 repo.
echo "Configuring the Google Chrome repo in ${repo_file}"
echo "[google-chrome]" > $repo_file
echo "name=google-chrome" >> $repo_file
echo "baseurl=http://dl.google.com/linux/chrome/rpm/stable/\$basearch" >> $repo_file
echo "enabled=1" >> $repo_file
echo "gpgcheck=1" >> $repo_file
echo "gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub" >> $repo_file


# Install the Google Chrome signing key.
yum install -y wget
wget https://dl.google.com/linux/linux_signing_key.pub
rpm --import linux_signing_key.pub


# A helper to make sure that Chrome is linked correctly
function installation_status() {
    google-chrome-stable --version > /dev/null 2>&1
    [ $? -eq 0 ]
}


# Try it the old fashioned way, should work on RHEL 7.X.
echo "Attempting a direction installation with yum."
yum install -y google-chrome-stable
if [ $? -eq 0 ]
then
    if installation_status; then
        # Print out the success message.
        echo "Successfully installed Google Chrome!"
        rm -rf ${working_directory}
        popd > /dev/null
        exit 0
    fi
fi
