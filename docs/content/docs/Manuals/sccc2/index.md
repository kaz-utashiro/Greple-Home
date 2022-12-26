---
layout: page
title:  greple -Msccc2
weight: 25
description: Greple module for Secure Coding in C and C++ (2nd Edition)
---

## NAME

sccc2 - Greple module for Secure Coding in C and C++ (2nd Edition)

## VERSION

Version 2.02

## INSTALL

cpanm で git リポジトリを指定：

    cpanm git@github.com:JPCERTCC/greple-sccc2.git

    cpanm https://github.com/JPCERTCC/greple-sccc2.git

または、clone して

    cpanm .

## SYNOPSIS

greple -Msccc2 \[ options \]

## OPTION

### ファイル

環境変数 `$SCCC2DIR` を設定すれば、以下のオプションで第一版、第二版の
原稿を検索できる。

    --ed1                search 1st edition
    --ed2                search 2nd edition

### 検索対象

    --in <part>          search in <part>
                         (jp, eg, jptxt, egtxt, comment, figure, table)

### 表示範囲

    --by <part>          display by <part>
                         (jp, eg, jptxt, egtxt, comment, figure, table)

    --jp                 display Japanese block
    --jptxt              display Japanese text block
    --eg                 display English block
    --egtxt              display English text block
    --egjp               display jp/eg combined block

### 除外範囲

    --extable            exclude table       
    --exfigure           exclude figure 
    --exexample          exclude example
    --excomment          exclude comment
    --join-block         join block into single line

### 用語検査

    --wordcheck             check against the dictionary
    --wordcheck --stat      show statistics only
    --wordcheck --with-stat print with statistics

### 表示

    --com                show all comments
    --com1               show comment level 1
    --com2               show comment level 2
    --com3               show comment level 3
    --com2+              show comment level 2 or <
    --retrieve           retrieve given part in plain text
    --colorcode          show each part in color-coded
    --oldcite            old style 2digit citation
    --newcite            new style 4digit citation

## DOCUMENT FORMAT

    Society's increased dependency on networked software systems has been
    matched by an increase in the number of attacks aimed at these
    systems.

    社会がネットワーク化したソフトウェアシステムへの依存を深めるにつれ、こ
    れらのシステムを狙った攻撃の数は増加の一途を辿っています。

    ※ comment level 1

    ※※ comment level 2

    ※※※ comment level 3

## DESCRIPTION

Text is devided into forllowing parts.

    egtxt    English  text
    jptxt    Japanese text
    eg       English  text and comment
    jp       Japanese text and comment
    comment  Comment block
    gap      empty line between English and Japanese

egtxt と jptxt を取り出せば英語版と日本語版の原稿になる。

    $ greple -Msccc2 --retrieve egtxt

    $ greple -Msccc2 --retrieve jptxt

## EXAMPLE

### 用語チェック

次のコマンドでテキスト全体の用語チェックができる:

    greple -Msccc2 --wordcheck --ed2

修正点を見る:

    greple -Msccc2 --wordcheck --ed2 --diff | cdif (あるいは sdif)

### 「偽装」と対応する原語を表示する

「偽装」含む行を表示する。

    greple -Msccc2 --ed2 偽装

`--egjp` を付けると対訳部分を表示する。

    greple -Msccc2 --egjp --ed2 偽装

「偽装」を `-r` で必須パターンとすると、他の検索パターンはオプショナルになる。
それぞれは別の色で表示される。

    greple -Msccc2 --egjp --ed2 \
        -r 偽装 \
        -e 'spoof\w*' -e 'craft\w+' -e 'disguis\w+' -e 'subterfug\w+' -e 'redirect\w*'

パターンをまとめてもいいが、一つのパターンにマッチする文字列は同じ色で表示される。
`--uc` (`--uniqcolor`) を指定しすれば文字列毎に違う色が割当てられる。

    greple -Msccc2 --egjp --ed2 --uc \
        -r 偽装 \
        --re '(?i:subterfug|disguis|craft|fake|spoof|redirect)\w*'

`-e` (`--and`) の代わりに `-v` (`--not`) を指定すると、いずれの単
語も含まれない部分だけが表示される。

    greple -Msccc2 --egjp --ed2 \
        -r 偽装 \
        -v 'spoof\w*' -v 'craft\w+' -v 'disguis\w+' -v 'subterfug\w+' -v 'redirect\w*'

## AUTHOR

Kazumasa Utashiro

## LICENSE

Copyright 2014,2020 Kazumasa Utashiro

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
