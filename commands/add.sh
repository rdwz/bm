#!/usr/bin/env bash

readonly script_name="bm"
readonly command_name="add"
readonly bm_path=~/.${script_name}

function usage_add() {

    cat<<USAGE_TEXT
Adds new link.

Usage: ${script_name} ${command_name} [<your_link>] [<categories>]
Usage: ${script_name} ${command_name} -h | ${script_name} ${command_name} --help 

Example:
${script_name} ${command_name} <link> <category> <category> ...
${script_name} ${command_name} --category <category> <category> ...
${script_name} ${command_name} --help | ${script_name} ${command_name} -h

OPTIONS:
-c, --category          Adds new categories
-h, --help              Print this usage information

For bug reporting and contributions, please see:
<https://github.com/gozeloglu/bm>
USAGE_TEXT
}

# Category files are created
function touch_files() {
  categories=( "$@" )

  for category in ${categories[@]}
  do
    if [[ ! -f ${bm_path}/${category}.txt  ]]; then
      touch ${bm_path}/"${category}.txt"
      echo "✔️📁 ${bm_path}/${category}.txt is created."
    fi
  done
}

# Link is written on the file(s)
function write_files() {
  parameters=( "$@" )
  link=( "${parameters[0]}")
  files=( "${parameters[@]:1} ")

  for file in ${files[@]}
  do 
    echo $link >> ${bm_path}/"${file}.txt"
  done
}

# Helper function
# Prints out the categories that saved
function echo_categories() {
  files=( "$@" )

  echo
  echo "Categories:"
  
  for file in ${files[@]}
  do
    echo " ✅${file}"
  done 
}

function add_bm() {
  parameters=( "$@" )
  link=( "${parameters[1]}")
  categories=( "${parameters[@]:2}" )

  echo $link
  echo ${categories[@]}

  touch_files ${categories[@]}
  write_files $link ${categories[@]}

  echo "$link is added ✔️"

  echo_categories ${categories[@]}

  echo "Done"

}

case "$2" in 
  --help | -h)
    usage_add
    shift
    ;;
  --category | -c)
    shift
    ;;
  *)
    if (( $# == 2 )); then
      echo "$2" >> ${bm_path}/"bm.txt"
      echo "$2 is added ✔️"
      echo_categories "bm.txt"

      echo
      echo "Done"
    else 
      add_bm "$@"
    fi 
    shift
    ;;
esac