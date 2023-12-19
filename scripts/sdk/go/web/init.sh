#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

MODULE=$1

if [ -z "$MODULE" ]; then
    echo "module not set"
    return 1
fi

folder_name=$(echo $MODULE | rev | cut -d/ -f1 | rev)
folder="$PWD/$folder_name"

(mkdir $folder &&
    cd $folder &&
    cp -rT "$SCRIPT_DIR"/templates . &&
    find ./ -type f -exec sed -i "s|github.com/cethien/go-web-template|$MODULE|g" {} \; &&
    go mod init "$MODULE" &&
    git init &&
    make clean update format &&
    git add . &&
    git commit -m "perf: init")

