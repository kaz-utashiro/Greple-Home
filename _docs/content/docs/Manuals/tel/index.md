---
layout: page
title:  greple -Mtel
weight: 17
description: Module to support simple telephone/address data file
---

[![Actions Status](https://github.com/kaz-utashiro/greple-tel/workflows/test/badge.svg)](https://github.com/kaz-utashiro/greple-tel/actions)
## NAME

tel - Module to support simple telephone/address data file

## VERSION

Version 0.01

## SYNOPSIS

greple -Mtel \[ options \]

## SAMPLES

greple -Mtel pattern

## DESCRIPTION

Sample module for **greple** command supporting simple telephone /
address data file.

## FORMAT

NAME, TEL, ADDRESS fields are separated by tab.

The line start with space is continuous line.

\[ keyword1, keyword2, ... \]

< string to be printed >

    [travel,airline]UA Reservations         800-241-6522
    [travel,airline]UA Premier Reservations
            03-3817-4441    Japan
            800-356-8900    US and Canada
            008-025-808     Australia
            810-1308        Hong Kong
            02-325-9914     Korea
            09-358-3500     New Zealand
            810-4356        Philippines
            321-8888        Singapore
            02-325-9914     Taiwan
    [travel,airline]UA Premier Exective
            800-225-8900    Reservations
            800-325-0046    Service Desk

    Kokkai Gijidou, The National Diet <国会議事堂>
            03-5521-7445    100-0014 東京都千代田区永田町1-7-1

## LICENSE

Copyright (C) Kazumasa Utashiro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

## AUTHOR

Kazumasa Utashiro
