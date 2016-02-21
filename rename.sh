#!/usr/bin/env bash

oldpath="./"
newpath="./sim/"

for file in $(find $oldpath -type f -name sim.cfg); do
  shortname=${file#$oldpath/}
  newname="$newpath/${shortname//\//_}"

  if [ -f $newname ]; then
    echo "$newname already exists."
  else
    echo "copy: $file"
    echo "  --> $newname"
    cp $file $newname
  fi
done
