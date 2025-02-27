#!/bin/bash

test_func () {
  if [ ! -f "./test_inputs/$1.in" ]; then
    echo "Input file does not exist: $1.in"
  fi

  python ../parse.py < "./test_inputs/$1.in" > ./tmp.txt
  exit_code="$?"

  if [ ! -f "./test_inputs/$1.out" ] && [ ! -f "./test_inputs/$1.code" ]; then
    echo "No reference for what to do with file $1. Add either $1.out or $1.code or both"
  fi

  if [ ! -f "./test_inputs/$1.out" ]; then
    diff_passed="0"
  else
    diff ./tmp.txt "./test_inputs/$1.out" > "./diffs/$1"
    diff_passed="$?"
  fi

  if [ ! -f "./test_inputs/$1.code" ]; then
    code_passed="0"
  else
    [ "$exit_code" -eq "$(cat "./test_inputs/$1.code")" ]
    code_passed="$?"
  fi

  if [ "$diff_passed" -eq "0" ] && [ "$code_passed" -eq "0" ]; then
    echo -e "\e[32m$1 passed\e[0m"
  else
    echo -e "\e[31m$1 failed\e[0m"
  fi
}

files=$(find ./test_inputs/* -type f -exec basename {} \; | sed 's/\.[^.]*$//' | uniq)
for file in $files; do
  test_func "$file"
done