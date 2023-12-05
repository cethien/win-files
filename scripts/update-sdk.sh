#! /bin/bash

SDK=$1

if [ -z "$SDK" ]
then
    echo "SDK not set"
else
    . $HOME/scripts/sdk/$SDK/update.sh
fi
