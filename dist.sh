#!/bin/sh

folder_name="$(basename $(pwd))"
mkdir -p ../dist
rm -f ../dist/${folder_name}.zip
git archive -o ../dist/${folder_name}.zip --prefix=${folder_name}/ HEAD
