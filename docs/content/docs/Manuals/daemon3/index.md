---
layout: page
title:  greple -Mdaemon3
weight: 19
description: Module for translation of the book "The Design and Implementation of the FreeBSD Operating System"
---

## NAME

daemon3 - Module for translation of the book "The Design and Implementation of the FreeBSD Operating System"

## VERSION

Version 1.01

## SYNOPSIS

greple -Mdaemon3 \[ options \]

    --by <part>  makes <part> as a data record
    --in <part>  search from <part> section
                 
    --jp         print Japanese chunk
    --eg         print English chunk
    --egjp       print Japanese/English chunk
    --comment    print comment block
    --injp       search from Japanese text
    --ineg       search from English text
    --inej       search from English/Japanese text
    --retrieve   retrieve given part in plain text
    --colorcode  show each part in color-coded

## DESCRIPTION

Text is devided into forllowing parts.

    e        English  text
    j        Japanese text
    eg       English  text and comment
    jp       Japanese text and comment
    macro    Common roff macro
    retain   Retained original text
    comment  Comment block
    com1     Level 1 comment
    com2     Level 2 comment
    com3     Level 3 comment
    mark     .EG, .JP, .EJ mark lines
    gap      empty line between English and Japanese

So \[ macro \] + \[ e \] recovers original text, and \[ macro \] + \[ j \]
produces Japanese version of book text.  You can do it by next
command.

    $ greple -Mdaemon3 --retrieve macro,e

    $ greple -Mdaemon3 --retrieve macro,j

## OPTION

- **--by** _part_

    Makes _part_ as a unit of output.  Multiple part can be given
    connected by commma.

- **--in** _part_

    Search pattern only from specified _part_.

- **--roffsafe**

    Exclude pattern included in roff comment and index.

- **--retrieve** _part_

    Retrieve specified part as a plain text.

    Special word _all_ means _macro_, _mark_, _e_, _j_, _comment_,
    _retain_, _gap_.  Next command produces original text.

        greple -Mdaemon3 --retrieve all

    If the _part_ start with minus ('-') character, it is removed from
    specification.  Without positive specification, _all_ is assumed. So
    next command print all lines other than _retain_ part.

        greple -Mdaemon3 --retrieve -retain

- **--colorcode**

    Produce color-coded result.

## EXAMPLE

Produce original text.

    $ greple -Mdaemon3 --retrieve macro,e

Search sequence of "system call" in Japanese text and print _egjp_
part including them.  Note that this print lines even if "system" and
"call" is devided by newline.

    $ greple -Mdaemon3 -e "system call" --by egjp --in j

Seach English text block which include all of "socket", "system",
"call", "error" and print _egjp_ block including them.

    $ greple -Mdaemo3 "socket system call error" --by egjp --in e

Look the file conents each part colored in different color.

    $ greple -Mdaemon3 --colorcode

Look the colored contents with all other staff

    $ greple -Mdaemon3 --colorcode --all

Compare produced result to original file.

    $ diff -U-1 <(lv file) <(greple -Mdaemon3 --retrieve macro,j) | sdif

## TEXT FORMAT

### Pattern 1

Simple Translation

    .\" Copyright 2004 M. K. McKusick
    .Dt $Date: 2013/12/23 09:04:26 $
    .Vs $Revision: 1.3 $
    .EG \"---------------------------------------- ENGLISH
    .H 2 "\*(Fb Facilities and the Kernel"
    .JP \"---------------------------------------- JAPANESE
    .H 2 "\*(Fb の機能とカーネルの役割"
    .EJ \"---------------------------------------- END

### Pattern 2

Sentence-by-sentence Translation

    .PP
    .EG \"---------------------------------------- ENGLISH
    The \*(Fb kernel provides four basic facilities:
    processes,
    a filesystem,
    communications, and
    system startup.
    This section outlines where each of these four basic services
    is described in this book.
    .JP \"---------------------------------------- JAPANESE
    The \*(Fb kernel provides four basic facilities:
    processes,
    a filesystem,
    communications, and
    system startup.
    
    \*(Fb カーネルは、プロセス、ファイルシステム、通信、
    システムの起動という4つの基本サービスを提供する。
    
    This section outlines where each of these four basic services
    is described in this book.
    
    本節では、これら4つの基本サービスが本書の中のどこで扱われるかを解説する。
    .EJ \"---------------------------------------- END

### COMMENT

Block start with ※ (kome-mark) character is comment block.

    .JP \"---------------------------------------- JAPANESE
    The
    .GL kernel
    is the part of the system that runs in protected mode and mediates
    access by all user programs to the underlying hardware (e.g.,
    .Sm CPU ,
    keyboard, monitor, disks, network links)
    and software constructs
    (e.g., filesystem, network protocols).
    
    .GL カーネル
    は、システムの一部として特権モードで動作し、
    すべてのユーザプログラムがハードウェア (\c
    .Sm CPU 、
    モニタ、ディスク、ネットワーク接続等) や、ソフトウェア資源
    (ファイルシステム、ネットワークプロトコル等)
    にアクセスするための調停を行う。
    
    ※
    protected mode は、ここでしか使われていないため、
    protection mode と誤解されないために特権モードと訳すことにする。

## INSTALL

cpanm App::Greple::daemon3

## LICENSE

Copyright (C) Kazumasa Utashiro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

## SEE ALSO

[https://github.com/kaz-utashiro/greple-daemon3](https://github.com/kaz-utashiro/greple-daemon3)

## AUTHOR

Kazumasa Utashiro

## POD ERRORS

Hey! **The above document had some coding errors, which are explained below:**

- Around line 132:

    Non-ASCII character seen before =encoding in 'の機能とカーネルの役割"'. Assuming UTF-8
