#!/bin/bash

(cd $HOME && \
curl -fsSL https://s.id/golang-linux | bash -s && \
rm -rf go*.tar.gz)
