---
layout: page
title:  greple -Mfind
weight: 5
description: Greple module to use find command
---

## NAME

find - Greple module to use find command

## SYNOPSIS

greple -Mfind find-options -- greple-options ...

## DESCRIPTION

Provide **find** command option with ending `--`.

**Greple** will invoke **find** command with provided options and read
its output from STDIN, with option **--readlist**.  So

    greple -Mfind . -type f -- pattern

is equivalent to:

    find . -type f | greple --readlist pattern

If the first argument start with `!`, it is taken as a command name
and executed in place of **find**.  You can search git managed files
like this:

    greple -Mfind !git ls-files -- pattern

## SEE ALSO

[App::Greple](https://metacpan.org/pod/App%3A%3AGreple)

[App::Greple::dig](https://metacpan.org/pod/App%3A%3AGreple%3A%3Adig)

[App::Greple::select](https://metacpan.org/pod/App%3A%3AGreple%3A%3Aselect)
