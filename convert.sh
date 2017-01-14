#!/bin/bash
FILES=./toconvert/*.wav
if [ ! -d "$DIRECTORY" ]; then
  # Control will enter here if $DIRECTORY doesn't exist.
  mkdir converted
fi
for f in $FILES
do
  echo "Processing $f file..."
    # take action on each file. $f store current file name
  ./piam $f "./converted/$f am.rfa"
  read -r -p "Wish to delete file $f? [y/N] " response
  case $response in
    [yY][eE][sS]|[yY])
      rm -rf $f
      ;;
    *)
  esac
done
