#!/bin/bash

#   Dylan Wright - dylan.wright@uky.edu
#   EE480 - Assignment 2: The Making Of An IDIOT
#   test.sh : Automatic test script
#               adapted from testing script provided by
#               Dr Jaromczyk for CS 441
#   Version:
#       02-14-2016 : initial

spec="IDIOT_spec"
aik="aik.py"
dir="progs/"

execute () {
  local testfile="$1";
  local outfile="${1/.idiot/.out}"
  echo "$testfile" | ./$aik > $outfile
}

plain () { tput sgr0; }
bold () { tput bold; }
red () { tput setaf 1; }
green () { tput setaf 2; }
brown () { tput setaf 3; }
ltred () { bold; red; }
ltgreen () { bold; green; }
yellow () { bold; brown; }

showdiff () {
  local difffile="$1"
  sed -e "s/^+.*/$(green)&$(plain)/ ;
          s/^-.*/$(red)&$(plain)/ ;
          s/^/   /" "$difffile"
}

numgood=0
numbad=0
numquestionable=0
bads=()
questionables=()

success() {
  echo "  --> $(ltgreen)Success!$(plain)"
  let ++numgood
}
failure() {
  local testname="$1"
  echo "  --> $(ltred)Failure!$(plain)"
  let ++numbad
  bads+=("$testname")
}
questionable() {
  local testname="$1"
  local msg="$2"
  echo "  -->$(brown)${msg:-Questionable}:$(plain)"
  let ++numquestionable
  questionables+=("$testname")
}

summarize() {
  echo -n "$(ltgreen)$numgood good$(plain), "
  echo -n "$(ltred)$numbad bad$(plain), "
  echo    "$(brown)$numquestionable questionable$(plain)"

  if (( numbad > 0)); then
    echo -n " --> Failed tests:$(ltred)"
    printf " %s" "${bads[@]}"
    echo "$(plain)"
  fi

  if (( numquestionable > 0)); then
    echo -n " --> Possibly failed tests:$(brown)"
    printf " %s" "${questionables[@]}"
    echo "$(plain)"
  fi
}

# main

for f in $dir/*.idiot
do
  base=${f%.idiot}
  testname=${base##*/}
  expected=${base}.expected.out
  expected_err=${base}.expected.err

  echo "--> Executing $testname..."
  execute "$f" > aik.out 2> aik.err

  if [ -r "$expected_err" ]; then
    echo " --> Checking for expected errors/mesages..."
    if diff -u "$expected_err" aik.err > aik.err.diff; then
      success "$testname"
    else
      failure "$testname"
      echo "  --> Diff results:"
      showdiff aik.err.diff
    fi
  fi

  if [ -r "$expected" ]; then
    echo " --> Checking output..."
    if diff -u "$expected" aik.out > aik.out.diff; then
      if [ -s aik.err ]; then
        questionable "$testname" "Correct but with compiler/error messages"
      else
        success "$testname"
      fi
    fi
  else
    failure "$testname"
    echo "  --> Diff results:"
    showdiff aik.out.diff
  fi

  if [ -s aik.err ]; then
    echo "  --> Compiler/Error messages:"
    sed -e 's/^/   /' aik.err
  fi

  echo
done

echo "--> Removing temporary files..."
rm -f aik.out aik.err aik.out.diff aik.err.diff

echo
echo -n "--> Testing has finished: "
summarize
