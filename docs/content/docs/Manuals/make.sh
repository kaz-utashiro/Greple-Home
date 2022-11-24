#!/bin/bash

set -e
public=(
    greple
    aozora
    cm
    daemon3
    frame
    git
    ical
    jq
    mecab
    msdoc
    ppi
    pw
    sccc2
    subst
    subst-desumasu
    type
    update
    wordle
    xp
)
private=(
    tel
)
weight=1
for d in ${public[*]}
do
    echo $d
    base=$(git rev-parse --show-toplevel)
    readme="$base/public/$d/README.md"
    index="$d/index.md"
    if [ -f $readme ]
    then
	[ -d $d ] || mkdir $d
	[ $d = greple ] && title=$d || title="greple -M$d"
	desc=$(sed '/^$/d' < $readme | grep -m1 -A1 '^# NAME' | sed -e 1d -e 's/^.*- //')
	(
	sed $'s/^[ \t]*//' <<- END
	---
	layout: page
	title:  $title
	weight: $weight
	description: $desc
	---
	
	END
	sed 's/^#/##/' $readme
	) > $index
	(( weight++ ))
    fi
done
