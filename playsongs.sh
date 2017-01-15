#!/bin/bash
#Initial check to see if files are converted.
if [ ! -d "/home/pi/rpitx/converted" ]; then
  echo "Converted directory does not exist, cannot play!"
  exit 1
fi
# Colours. Note the use of `$'...'` to actually store the code,
# thereby avoiding the need to later reinterpret backslash sequences
CYAN=$'\e[36m'
NC=$'\e[39m'
LGREEN=$'\e[92m'
converted=/home/pi/rpitx/converted

list_new_files() {
  inotifywait -m "$converted" -e create -e moved_to --format "%e %f"
}

# Note the use of ( ) around the body instead of { }
# This is the same as `{( ... )}'; it makes the `cd` local to the function.
list_existing_files() (
  cd "$converted"
  printf "EXISTING %s\n" *
)

# Invoked as `handle action filename`
handle() {
  case "$1" in
    EXISTING) 
      echo "${CYAN}Now playing ${2}...${NC}"
    ;;
    *)
       echo "${LGREEN}New file found: ${CYAN}${file}${NC}"
    ;;
  esac
  sudo ./rpitx -m RF -i "${converted}/${2}" -f 101100 &
  wait %%
}

# Put everything together
list_new_files |
{ list_existing_files; cat; } |
while read -r action file; do handle "$action" "$file"; done

while read -r action file; do
  # If file doesn't end with a slash, we need to read another line
  while [[ file != */ ]] && read -r line; do
    file+=$'\n'"$line"
  done
  # Remember to remove the trailing slash
  handle "$action" "${file%/}"
done
