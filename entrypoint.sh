#! /usr/bin/env sh
set -xe
Xvfb :99 &
export DISPLAY=:99
rspec -f d
