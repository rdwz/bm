#!/usr/bin/env bash

readonly script_name="bm"
readonly command_name="remove"
readonly bm_path=~/.${script_name}

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'  # No color

function usage_remove() {
  cat<<USAGE_TEXT
Removes the given categories.

Usage: ${script_name} ${command_name} [<options>] [<argument>]
Usage: ${script_name} ${command_name} --help | ${script_name} ${command_name} -h

Options:
-f, --force     Ignore there are links or not in given categories
-h, --help      Print the usage information

For bug reporting and contributions, please see:
<https://github.com/gozeloglu/bm>
USAGE_TEXT
}

function remove() {
  parameters=( $@ )

  if [[ ${parameters[1]} == "--force" || ${parameters[1]} == "-f" ]]; then
    categories=${parameters[@]:2}

    for category in ${categories[@]}
    do 
      if [[ ! -f "${bm_path}/${category}.txt" ]]; then 
        echo "❌ $category: No such a category"
      else
        # Remove category
        rm "${bm_path}/${category}.txt"
        echo "✔️ $category is removed"
      fi 
    done 
  else
    categories=${parameters[@]:1}
    
    for category in ${categories[@]}
    do 
      if [[ ! -f "${bm_path}/${category}.txt" ]]; then 
        echo -e "❌ ${GREEN}$category${NC}: No such a category"
        continue
      fi
      line_count="$(wc -l < "${bm_path}/${category}.txt")"
      
      # Check the file is empty or not
      if [[ "${line_count}" -gt 0 ]]; then
        echo -e "❗ ${GREEN}$category${NC}: Category is not empty. Try '--force' option."
      else 
        rm "${bm_path}/${category}.txt"
        echo "✔️ $category is removed"
      fi 
    done
  fi 
}

case $2 in 
  --force | -f)
    remove $@
    shift
    ;;
  --help | -h)
    usage_remove
    shift
    ;;
  *)
    if echo $2 | grep -q "^\-"; then
      echo "$2: Invalid option"
      echo "Run 'bm remove --help' to see usage. "
    else
      remove $@
    fi
    shift
    ;;
esac