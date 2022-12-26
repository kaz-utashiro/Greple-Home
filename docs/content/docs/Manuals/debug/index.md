---
layout: page
title:  greple -Mdebug
weight: 3
description: Greple module for debug control
---

## NAME

debug - Greple module for debug control

## SYNOPSIS

greple -dmc

greple -Mdebug

greple -Mdebug::on(getoptex)

greple -Mdebug::on=getoptex

## DESCRIPTION

Enable debug mode for specified target.  Currently, following targets
are available.

    getoptex         Getopt::EX
    getopt           Getopt::Long
    color       -dc  Color information
    directory   -dd  Change directory information
    file        -df  Show search file names
    number      -dn  Show number of processing files
    match       -dm  Match pattern
    option      -do  Show command option processing
    process     -dp  Exec ps command before exit
    stat        -ds  Show statistic information
    grep        -dg  Show grep internal state
    filter      -dF  Show filter informaiton
    unused      -du  Show unused 1-char option name

When used without function call, default target is enabled; currently
`getoptex` and `option`.

    $ greple -Mdebug

Specify required target with `on` function like:

    $ greple -Mdebug::on(color,match,option)

    $ greple -Mdebug::on=color,match,option

Calling `debug::on=all` enables all targets, except `unused` and
`number`.

Target name marked with `-dx` can be enabled in that form.  Following
commands are all equivalent.

    $ greple -Mdebug::on=color,match,option

    $ greple -dc -dm -do

    $ greple -dcmo

## EXAMPLE

Next command will show how the module option is processed in
[Getopt::EX](https://metacpan.org/pod/Getopt%3A%3AEX) module.

    $ greple -Mdebug::on=getoptex,option -Mdig something --dig .
