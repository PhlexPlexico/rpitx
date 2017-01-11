#!/bin/bash
FILES=./toconvert/*
if [ ! -d "./converted" ]; then
  # Control will enter here if $DIRECTORY doesn't exist.
  mkdir converted
fi
for f in $FILES
do
  echo "Processing $f file..."
    # take action on each file. $f store current file name
  ./piam "${f}" "./converted/${f##*/}.rfa" 
#  read -r -p "Wish to delete file $f? [y/N] " response
#  case $response in
#    [yY][eE][sS]|[yY])
#      rm -rf $f
#      ;;
#    *)
  rm -rf $f
#  esac
done
