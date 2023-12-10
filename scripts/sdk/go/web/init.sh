#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

MODULE=$1

if [ -z "$MODULE" ]; then
    echo "module not set"
    return 1
fi

go mod init "$MODULE" &&
    git init &&
    cp -rT "$SCRIPT_DIR"/templates . &&
    find ./ -type f -exec sed -i "s|example.com/template|$MODULE|g" {} \; &&
    make setup &&
    git add . &&
    git commit -m "perf: init"

