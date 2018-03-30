#!/bin/bash

for INSTALL_DIR in autoload compiler ftdetect ftplugin indent syntax
do
  mkdir -p ~/.vim/${INSTALL_DIR}
  cp -R ${INSTALL_DIR}/ ~/.vim/${INSTALL_DIR}
done
