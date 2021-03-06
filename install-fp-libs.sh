#!/bin/bash

last_dir=`pwd`
green='\033[1;32m'
nc='\033[0m'

if [[ ! -d $1 ]]; then
	echo "Please provide a directory to which .pretty libraries should be"
	echo "cloned to, e.g. ~/kicad/lib/"
	exit 1
fi

command -v jq >/dev/null 2>&1 || { echo >&2 "jq commmand is required to run this, install it first."; exit 1; }

cd $1

repos=`curl 'https://api.github.com/users/KiCad/repos?per_page=10000' | jq '.[] | .name, .clone_url' | grep .pretty`
readarray -t reposArray <<<"$repos"
i=0
n=${#reposArray[@]}
while [ "$i" -lt "$n" ]; do
	reposArray[$i]=`echo "${reposArray[$i]}" | tr -d '"'`
	printf "Cloning ${green}${reposArray[$i]}${nc} (repository ${green}%d/%d${nc})\n" "$(((i+2)/2))" "$((n/2))"
	let i++

	reposArray[$i]=`echo "${reposArray[$i]}" | tr -d '"'`
	git clone ${reposArray[$i]}
	let i++
done

cd $last_dir
