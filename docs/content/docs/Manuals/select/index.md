---
layout: page
title:  greple -Mselect
weight: 7
description: Greple module to select files
---

## NAME

select - Greple module to select files

## SYNOPSIS

greple -Mdig -Mselect ... --dig .

    FILENAME
      --suffix         file suffixes
      --select-name    regex match for file name
      --select-path    regex match for file path
      --x-suffix       exclusive version of --suffix         
      --x-select-name  exclusive version of --select-name
      --x-select-path  exclusive version of --select-path

    DATA
      --shebang        included in #! line
      --select-data    regex match for file data
      --x-shebang      exclusive version of --shebang        
      --x-select-data  exclusive version of --select-data

## DESCRIPTION

Greple's **-Mselect** module allows to filter files using their name
and content data.  It is usually supposed to be used along with
**-Mfind** or **-Mdig** module.

For example, next command scan files end with `.pl` and `.pm` under
current directory.

    greple -Mdig -Mselect --suffix=pl,pm foobar --dig .

This is almost equivalent to the next command using **--dig** option
with extra conditional expression for **find** command.

    greple -Mdig foobar --dig . -name '*.p[lm]'

The problems is that the above command does not search perl command
script without suffixes.  Next command looks for both files looking at
`#!` (shebang) line.

    greple -Mdig -Mselect --suffix=pl,pm --shebang perl foobar --dig .

Generic option **--select-name**, **--select-path** and **--select-data**
take regular expression and works for arbitrary use.

### ORDER and DEFAULT

Besides normal inclusive rules, there is exclusive rules which start
with **--x-** option name.

As for the order of rules, all exclusive rules are checked first, then
inclusive rules are applied.

When no rules are matched, default action is taken.  If no inclusive
rule exists, it is selected.  Otherwise discarded.

## OPTIONS

### FILENAME

- **--suffix**=_xx,yy,zz ..._

    Specify one or more file name suffixes connecting by comma (`,`).
    They will be converted to `/\.(xx|yy|zz)$/` expression and compared
    to the file name.

- **--select-name**=_regex_

    Specify regular expression and it is compared to the file name.  Next
    command search Makefiles under any directory.

        greple -Mselect --select-name '^Makefile.*'

- **--select-path**=_regex_

    Specify regular expression and it is compared to the file path.

- **--x-suffix**=_xx,yy,zz ..._
- **--x-select-name**=_regex_
- **--x-select-path**=_regex_

    These are reverse version of corresponding options.  File is not
    selected when matched.

### DATA

- **--shebang**=_aa,bb,cc_

    This option test if a given string is included in the first line of
    the file start with `#!` (aka shebang) mark.  Multiple names can be
    specified connecting by command (`,`).  Given string is converted to
    the next regular expression:

        /\A #! .*\b (aa|bb|cc)/x

- **--select-data**=_regex_

    Specify regular expression and it is compared to the file content data.

- **--x-shebang**=_aa,bb,cc_
- **--x-select-data**=_regex_

    These are reverse version of corresponding options.  File is not
    selected when matched.
