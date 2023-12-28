#!/bin/bash

MODULE=$1

if [ -z "$MODULE" ]; then
    echo "module not set"
    return 1
fi

folder_name=$(echo "$MODULE" | rev | cut -d/ -f1 | rev)
folder="$PWD/$folder_name"
template=github.com/cethien/go-template-web

(gonew $template "$MODULE" "$folder_name"
    cd "$folder" &&
    find ./ -type f -exec sed -i "s|$template|$MODULE|g" {} \; &&
    cp .example.env .env
    git init &&
    make clean update format &&
    git add . &&
    git commit -m "perf: init")

