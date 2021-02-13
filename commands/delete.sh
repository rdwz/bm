#!/usr/bin/env bash

readonly script_name="bm"
readonly command_name="delete"
readonly bm_path=~/.${script_name}

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'  # No color

function usage_delete() {
  cat<<USAGE_TEXT
Deletes the given bookmarks.

Usage: ${script_name} ${command_name} [<argument>]
Usage: ${script_name} ${command_name} --category [<argument>]
Usage: ${script_name} ${command_name} --help | ${script_name} ${command_name} -h

Options:
-c, --category  Give the specific category
-h, --help      Print the usage information

For bug reporting and contributions, please see:
<https://github.com/gozeloglu/bm>
USAGE_TEXT
}

# Delete bookmarks from default category, bm
function delete_default() {
  parameters=( $@ )
  bm_ids=${parameters[@]:1}

  local file="${bm_path}/bm.txt"
  local bookmark_count="$(wc -l < "$file")"
  local line_str=""     # string for deleting lines
  declare -a bookmarks  # bookmark array
  
  for id in ${bm_ids[@]}
  do 
    if (( $id > $bookmark_count || $id < 1 )); then
      continue
    fi

    local bookmark="$(sed "${id}!d" < "$file")"
    bookmarks+=( ${bookmark} )
    line_str+="${id}d;"
  done

  local i=0
  for id in ${bm_ids[@]}
  do 
    if (( $id > $bookmark_count || $id < 1 )); then
      echo "#$id There is no such a bookmark ❌"
      continue
    fi
    echo "#$id '${bookmarks[i]}' deleted ✔️"
    (( i+=1 ))
  done 

  # Delete lines
  sed -i "${line_str}" $file
  
}

# Deletes the bookmark by given category
function delete() {
  parameters=( $@ )
  category=${parameters[2]}
  bm_ids=${parameters[@]:3}

  local file="${bm_path}/${category}.txt"

  if [[ ! -f $file ]]; then 
    echo "❌ There is no such category."
    exit 1
  fi 
  re='^[+-]?[0-9]+([.][0-9]+)?$'
  local bm_count="$(wc -l < "$file")"
  local line_str=""
  declare -a bookmarks
  
  for id in ${bm_ids[@]}
  do 
    # check id is number or not
    if ! [[ $id =~ $re ]]; then
      continue
    fi 
    
    # check invalid bookmark id
    if (( $id > $bm_count || $id < 1 )); then 
      continue
    fi

    local bookmark="$(sed "${id}!d" < "$file")"
    bookmarks+=( ${bookmark} )
    line_str+="${id}d;"
  done 

  local i=0
  for id in ${bm_ids[@]}
  do 

    if ! [[ $id =~ $re ]]; then
      echo "'$id' is not a number ❓"
      continue
    fi 

    if (( $id > $bm_count || $id < 1 )); then
      echo "#$id There is no such a bookmark ❌"
      continue
    fi 

    echo "#$id '${bookmarks[i]}' deleted ✔️"
    (( i+= 1 ))
  done 

  # Delete lines
  sed -i "${line_str}" $file
}

case $2 in 
  --help | -h)
    usage_delete
    shift
    ;;
  --category | -c)
    delete $@
    shift 
    ;;
  *)
    if echo $2 | grep -q "^\-"; then
      echo "$2: Invalid option"
      echo "See '${script_name} ${command_name} --help'."
    elif (( $# == 1 ));then
      usage_delete
    else 
      delete_default $@
    fi
    shift
    ;; 
esac
