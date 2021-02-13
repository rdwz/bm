#!/usr/bin/env bash

readonly script_name="bm"

function error_message() {
  echo "$*" >&2
}

function setup() {
  if [[ ! -d ~/.${script_name}/ ]]; then
    if ! mkdir -p ~/.${script_name} ; then
      error_message "Directory could not created"
    else
      echo "✔️ Directory is created successfully."
    fi
  else
    echo "You already created directory"
  fi

  if [[ ! -f ~/.${script_name}/bm.txt ]]; then
    touch ~/.${script_name}/bm.txt
    echo "✔️ Created bm-default category."
  else
    # TODO Can be refactored this part
    while true; do
      read -p "Are you sure you want to recreate the existing file?(y/N) " yn
      case $yn in
          [Yy]* ) touch ~/.${script_name}/bm.txt; break;;
          [Nn]* ) exit;;
          * ) echo "Please answer yes or no.";;
      esac
    done
  fi
}

setup