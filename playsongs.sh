#!/bin/bash
#Initial check to see if files are converted.
if [ ! -d "./converted" ]; then
  echo "Converted directory does not exist, cannot play!"
  exit 1
fi
#Set variables.
FILES=./converted/*
CYAN='\e[36m'
NC='\e[39m'
for f in $FILES
do
  echo -e "${CYAN}Now playing ${f##*/}...${NC} In order to exit, press Q."
  # take action on each file. $f store current file name
  sudo ./rpitx -m RFA -i "${f}" -f 1190  
  #Read in from console in order to exit. Not quite working.
  #read -r -t 45 -s response < /dev/pts/1 &
  #case $response in
  #  [qQ][uU][iI][tT]|[qQ])
  #    echo -e "${CYAN}Now quitting${NC}"
  #    exit 0
  #    ;;
  #  *)
  #esac
done
exit 0
