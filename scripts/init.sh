#!/bin/bash

if [ $# -eq 0 ] || [ $# -eq 2 ] || [ $# -gt 3 ]; then
    echo "Illegal number of parameters"
    return 1
fi

if [ $# -eq 1 ]; then
    mkdir $1 && cd "$_" && git init && touch README.md .gitignore
fi

if [ $# -eq 3 ]; then
    SDK=$1
    TEMPLATE=$2

    . $HOME/scripts/sdk/$1/$2/init.sh $3
fi



