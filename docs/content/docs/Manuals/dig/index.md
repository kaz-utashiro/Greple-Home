---
layout: page
title:  greple -Mdig
weight: 6
description: Greple module for recursive search
---

## NAME

dig - Greple module for recursive search

## SYNOPSIS

greple -Mdig pattern --dig directories ...

greple -Mdig pattern --git ...

## DESCRIPTION

Option **--dig** searches all files under specified directories.  Since
it takes all following arguments, place at the end of all options.

It is possible to specify AND condition after directories, in **find**
option format.  Next command will search all C source files under the
current directory.

    $ greple -Mdig pattern --dig . -name *.c

    $ greple -Mdig pattern --dig . ( -name *.c -o -name *.h )

If more compilicated file filtering is required, combine with
**-Mselect** module.

You can use **--dig** option without module declaration by setting it
as autoload module in your `~/.greplerc`.

    autoload -Mdig --dig --git

Use **--git-r** to search submodules recursively.

## OPTIONS

- **--dig** _directories_ _find-option_

    Specify at the end of **greple** options, because all the rest is taken
    as option for [find(1)](http://man.he.net/man1/find) command.

- **--git** _ls-files-option_

    Search files under git control.  Specify at the end of **greple**
    options, because all the rest is taken as option for
    [git-ls-files(1)](http://man.he.net/man1/git-ls-files) command.

- **--git-r** _ls-files-option_

    Short cut for **--git --recurse-submodules**.

## SEE ALSO

[App::Greple](https://metacpan.org/pod/App%3A%3AGreple)

[App::Greple::select](https://metacpan.org/pod/App%3A%3AGreple%3A%3Aselect)

[find(1)](http://man.he.net/man1/find), [git-ls-files(1)](http://man.he.net/man1/git-ls-files)
