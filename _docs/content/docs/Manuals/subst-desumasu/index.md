---
layout: page
title:  greple -Msubst-desumasu
weight: 15
description: Japanese DESU/MASU dictionary for App::Greple::subst
---

[![Actions Status](https://github.com/kaz-utashiro/greple-subst-desumasu/workflows/test/badge.svg)](https://github.com/kaz-utashiro/greple-subst-desumasu/actions) [![MetaCPAN Release](https://badge.fury.io/pl/App-Greple-subst-desumasu.svg)](https://metacpan.org/release/App-Greple-subst-desumasu)
## NAME

App::Greple::subst::desumasu - Japanese DESU/MASU dictionary for App::Greple::subst

## SYNOPSIS

    greple -Msubst::desumasu --dearu --subst --all file

    greple -Msubst::desumasu --dearu --diff file

    greple -Msubst::desumasu --dearu --replace file

## DESCRIPTION

greple -Msubst module based on
[desumasu-converter](https://github.com/kssfilo/desumasu-converter).

This is a simple checker/converter module for Japanese writing style
so called DUSU/MASU (ですます調: 敬体) and DEARU (である調: 常体).
This is not my own idea and the dictionary is based on
[https://github.com/kssfilo/desumasu-converter](https://github.com/kssfilo/desumasu-converter).

See article [https://kanasys.com/tech/722](https://kanasys.com/tech/722) for detail.

## OPTIONS

- **--dearu**
- **--dearu-n**
- **--dearu-N**

    Convert DESU/MASU to DEARU style.

    DESU (です) and MASU (ます) sometimes followed by NE (ね) in frank
    situation, and that NE (ね) is removed from converted result by
    default.  Option with **-n** keep that NE (ね), and option with **-N**
    igonore them.

- **--desumasu**
- **--desumasu-n**
- **--desumasu-N**

    Convert DEARU to DESU/MASU style.

Use them with **greple** **-Msubst** options.

- **--subst --all --no-color**

    Print converted text.

- **--diff**

    Produce diff output of original and converted text.  Use **cdif**
    command in [App::sdif](https://metacpan.org/pod/App%3A%3Asdif) to visualize the difference.

- **--create**
- **--replace**
- **--overwrite**

    To update the file, use these options.  Option **--create** make new
    file with `.new` suffix.  Option **--replace** update the target file
    with backup, while option **--overwrite** does without backup.

See [App::Greple::subst](https://metacpan.org/pod/App%3A%3AGreple%3A%3Asubst) for other options.

## INSTALL

### CPANMINUS

From CPAN:

    cpanm App::Greple::subst::desumasu

From GIT repository:

    cpanm https://github.com/kaz-utashiro/greple-subst-desumasu.git

## SEE ALSO

[App::Greple](https://metacpan.org/pod/App%3A%3AGreple), [App::Greple::subst](https://metacpan.org/pod/App%3A%3AGreple%3A%3Asubst)

[App::sdif](https://metacpan.org/pod/App%3A%3Asdif)

[https://github.com/kssfilo/desumasu-converter](https://github.com/kssfilo/desumasu-converter),
[https://kanasys.com/tech/722](https://kanasys.com/tech/722)

[greple で「ですます調」を「である化」する](https://qiita.com/kaz-utashiro/items/8f4878300043ce7b73e7)

## AUTHOR

Kazumasa Utashiro

## LICENSE

Copyright 2021-2022 Kazumasa Utashiro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
