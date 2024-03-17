#!/bin/bash

if [ $# -eq 1 ]; then
    mkdir "$1" && cd "$_" && git init && touch README.md .gitignore
    return 0
else
    echo "Illegal number of parameters"
    return 1
fi
