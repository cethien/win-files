#! /bin/bash

go mod init $1 &&
    bun add htmx.org alpinejs @alpinejs/persist &&
    bun add -D \
        @types/{alpinejs,alpinejs__persist} \
        postcss autoprefixer tailwindcss @iconify/{tailwind,json} \
        husky @commitlint/{cli,config-conventional} \
        prettier prettier-plugin-go-template prettier-plugin-tailwindcss &&
    bun tailwindcss init -p &&

    #scripts
    npm pkg set \
        scripts.commitlint="commitlint --edit" \
        scripts.format="prettier -w ." \
        scripts.base:js="bun build --target=browser web/js/index.ts" \
        scripts.build:js="bun run base:js -- --minify --outfile=public/js/main.min.js" \
        scripts.dev:js="bun run base:js -- --watch --outfile=public/js/main.js" \
        scripts.base:css="tailwindcss -i web/css/styles.css" \
        scripts.build:css="bun run base:css -- --minify -o ./public/css/main.min.css" \
        scripts.dev:css="bun run base:css -- --watch -o ./public/css/main.css" &&
    echo "module.exports = {extends: ['@commitlint/config-conventional']}" >commitlint.config.js &&
    cp -rT $HOME/scripts/templates/go-web . &&
    touch README.md &&
    make clean install &&
    git init &&
    bun husky install &&
    bun husky add .husky/commit-msg 'bun run commitlint ${1}' &&
    git add .
