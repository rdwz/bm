#!/usr/bin/env bash

readonly script_name="bm"
readonly command_name="list"
readonly bm_path=~/.${script_name}

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'  # No color

function usage_list() {

    cat<<USAGE_TEXT
List the bookmarks.

Usage: ${script_name} ${command_name} [<options>] [<categories>]
Usage: ${script_name} ${command_name} [<options>] 
Usage: ${script_name} ${command_name} -h | ${script_name} ${command_name} --help 

Example:
${script_name} ${command_name} -c || ${script_name} ${command_name} --category
${script_name} ${command_name} -c <category> <category> ...
${script_name} ${command_name} -h | ${script_name} ${command_name} --help

OPTIONS:
-c, --category          List the bookmarks by their categories
-h, --help              Print this usage information

For bug reporting and contributions, please see:
<https://github.com/gozeloglu/bm>
USAGE_TEXT
}

# Splits the given path by '/' character
# Then, splits the last element of the path_array, 
# which is name of the category file, by '.' 
# Returns the value by using local and echo 
function split_path() {
  IFS='/' read -r -a  path_array <<< $@
  IFS='.' read -r -a category <<< ${path_array[-1]}

  local splitted_category=${category}
  echo $splitted_category  
}

# Lists all categories
# No bookmarks, just the name of categories
function list_categories() {
  
  if [[ ! -d ~/.${script_name}/ ]]; then
    echo "You did not setup."
  else 
    i=0
    echo -e "${YELLOW}Categories:${NC}"
    for c in "${bm_path}"/*
    do
      category_name=$(split_path $c)
      bm_count=`cat ${c} | wc -l`
      echo -e "#$i ${YELLOW}${category_name}:${NC} $bm_count bookmarks"
      (( i+= 1))
    done
  fi
}

# Lists the bookmarks by given categories
function list_by_category() {
  parameters=( $@ )
  categories=( ${parameters[@]:2} )

  for category in ${categories[@]}
  do
    echo $category
    echo -e "${YELLOW}---------------------------${NC}"
    if [[ ! -f ${bm_path}/${category}.txt ]]; then
      echo "❌ $category : There is no such a category"
    else

      local i=1
      file="${bm_path}/${category}.txt"
      while read line
      do

        # check empty lines
        if [ -z $line ]; then
          continue
        fi

        echo -e "${CYAN}#$i${NC} $line"
        (( i+= 1))
      done < "$file"
      (( i-=1 ))
      echo -e "${GREEN}Total bookmarks: $i${NC}"
      echo
    fi
  done
}

function list() {
  parameters=( "$@" )
  
  case "$2" in 
    --category | -c)
      if (( $# == 2 )); then
        list_categories
      else 
        list_by_category $@
      fi
      shift
      ;;
    *)
      echo "Invalid command."
      shift
      ;;
  esac

}

case $2 in 
  --help | -h)
    usage_list
    shift
    ;;
  *)
    list $@
    shift
    ;;
esac