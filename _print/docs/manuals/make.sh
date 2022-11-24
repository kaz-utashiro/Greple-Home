#!/bin/bash

set -e
weight=1
for d in \
    greple \
    aozora \
    cm \
    daemon3 \
    fbsd2 \
    frame \
    git \
    ical \
    jq \
    mecab \
    msdoc \
    ppi \
    pw \
    sccc2 \
    subst \
    subst-desumasu \
    tel \
    type \
    update \
    wordle \
    xp
do
    echo $d
    base=$(git rev-parse --show-toplevel)
    readme="$base/$d/README.md"
    index="$d/index.md"
    if [ -f $readme ]
    then
	[ -d $d ] || mkdir $d
	[ $d = greple ] && title=$d || title="greple -M$d"
	desc=$(sed '/^$/d' < $readme | grep -A1 '# NAME' | sed -e 1d -e 's/^.*- //')
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
