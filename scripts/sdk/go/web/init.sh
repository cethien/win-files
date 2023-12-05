#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

MODULE=$1

if [ -z "$MODULE" ]; then
    echo "module not set"
    return 1
fi

go mod init $MODULE &&
    git init &&
    cp -rT $SCRIPT_DIR/templates . &&
    find ./ -type f -exec sed -i "s|example.com/template|$MODULE|g" {} \; &&
    bun add htmx.org alpinejs @alpinejs/persist &&
    bun add -D \
        @types/{alpinejs,alpinejs__persist} \
        postcss autoprefixer tailwindcss @iconify/{tailwind,json} \
        husky @commitlint/{cli,config-conventional} \
        prettier prettier-plugin-go-template prettier-plugin-tailwindcss &&
    bun husky install &&
    bun husky add .husky/commit-msg 'bun run commitlint ${1}' &&
    npm pkg set \
        scripts.commitlint="commitlint --edit" \
        scripts.format="prettier -w ." \
        scripts.base:js="bun build --target=browser web/js/index.ts" \
        scripts.build:js="bun run base:js -- --minify --outfile=public/js/main.min.js" \
        scripts.dev:js="bun run base:js -- --watch --outfile=public/js/main.js" \
        scripts.base:css="tailwindcss -i web/css/styles.css" \
        scripts.build:css="bun run base:css -- --minify -o ./public/css/main.min.css" \
        scripts.dev:css="bun run base:css -- --watch -o ./public/css/main.css" &&
    make clean install format &&
    git add . &&
    git commit -m "perf: init"

