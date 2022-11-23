---
layout: page
title:  greple -Mppi
weight: 12
description: Greple module to use Perl PPI module
---

[![Actions Status](https://github.com/kaz-utashiro/greple-ppi/workflows/test/badge.svg)](https://github.com/kaz-utashiro/greple-ppi/actions) [![MetaCPAN Release](https://badge.fury.io/pl/App-Greple-ppi.svg)](https://metacpan.org/release/App-Greple-ppi)
## NAME

ppi - Greple module to use Perl PPI module

## SYNOPSIS

greple -Mppi

## VERSION

Version 0.01

## DESCRIPTION

Greple module to use Perl PPI module.  This is just a work in
progress experimental module.

## OPTIONS

- **--dumper**

    Dump PDOM trees produced by PPI::Dumper module.

- **--cdumper**

    Colorize dumped data.

- **--top**

    Make search data block top level object.

- **--state**

    Make search data block PPI::Statement.

- **--prune**=_type_

    Remove _type_ object from tree.  This option have to be used before
    any other options.

## AUTHOR

Kazumasa Utashiro

## LICENSE

Copyright 2022 Kazumasa Utashiro

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
