#!/bin/bash

mkdir -p ~/.vim/

for INSTALL_DIR in autoload compiler ftdetect ftplugin indent syntax
do
  cp -R ${INSTALL_DIR} ~/.vim/
done

