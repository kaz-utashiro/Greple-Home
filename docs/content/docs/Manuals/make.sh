#!/bin/bash

set -e
public=(
    greple
    greple@v8
    greple/lib/App/Greple/debug.pm
    greple/lib/App/Greple/colors.pm
    greple/lib/App/Greple/find.pm
    greple/lib/App/Greple/dig.pm
    greple/lib/App/Greple/select.pm
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
for target in ${public[*]}
do
    echo $target
    read repo rev < <(echo $target | sed 's/@/ /g')

    path=$base/public/$repo
    basename=$(basename $path)
    dirname=$(dirname $path)
    if [[ $path =~ .(pm|pod)$ ]]
    then
	md=$(pod2markdown $path)
	label=${basename/.pm/}
	title="greple -M$label"
    elif [ -d $path ]
    then
	readme="$path/README.md"
	[[ "$repo" =~ ^greple ]] && title=$target || title="greple -M$target"
	if [ "$rev" != "" ]
	then
	    md=$( cd $path; git show $rev:README.md )
	else
	    md=$(< $path/README.md)
	fi
	label=$target
    else
	echo ERROR: $target
	continue
    fi
    [ -d $label ] || mkdir $label
    index="$label/index.md"
    desc=$(\
	sed '/^$/d' <<< "$md" | grep -m1 -A1 '^# NAME' | sed -e 1d -e 's/^.*- //' \
    )
    (
    sed $'s/^[ \t]*//' << END
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
done
