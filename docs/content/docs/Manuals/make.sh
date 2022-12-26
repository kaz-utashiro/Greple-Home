#!/bin/bash

set -e
public=(
    greple
    greple@v8
    xp
    git
    frame
    update
    subst
    subst-desumasu
    type
    msdoc
    wordle
    aozora
    cm
    daemon3
    ical
    jq
    mecab
    ppi
    pw
    sccc2
)
private=(
    tel
)
base=$(git rev-parse --show-toplevel)
weight=1
for d in ${public[*]}
do
    echo $d
    read repo rev < <(echo $d | sed 's/@/ /g')
    subdir="$base/public/$repo"
    readme="$subdir/README.md"
    index="$d/index.md"
    if [ -f $readme ]
    then
	[ -d $d ] || mkdir $d
	[[ "$d" =~ ^greple ]] && title=$d || title="greple -M$d"
	if [ "$rev" != "" ]
	then
	    md=$( cd $subdir; git show $rev:README.md )
	else
	    md=$(< $readme)
	fi
	desc=$(\
	    sed '/^$/d' <<< "$md" | grep -m1 -A1 '^# NAME' | sed -e 1d -e 's/^.*- //' \
	)
#	desc=$(sed '/^$/d' < $readme | grep -m1 -A1 '^# NAME' | sed -e 1d -e 's/^.*- //')
	(
	sed $'s/^[ \t]*//' <<- END
	---
	layout: page
	title:  $title
	weight: $weight
	description: $desc
	---
	
	END
	sed 's/^#/##/' <<< "$md"
	) > $index
	(( weight++ ))
    fi
done
