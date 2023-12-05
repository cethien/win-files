#!/bin/bash

SDK=$1
TEMPLATE=$2

if [ -z "$SDK" ]; then
    echo "SDK not set"
    return 1
fi

if [ -z "$TEMPLATE" ]; then
    echo "Template not set"
    return 1
fi

. $HOME/scripts/sdk/$1/$2/init.sh $3