---
title: "拡張モジュールの使用法"
weight: 11
id:      25a14e75380c39b5e0af
private: false
---

greple の特徴の一つは、モジュールによって拡張可能なことです。今回は、モジュールの使い方について紹介します。

## 利用可能なモジュールを表示する

モジュールは `-M` オプションで指定します。単独で使用すると、利用できるモジュールを表示します。この中には、greple に標準で含まれるものと、別パッケージからインストールしたもの、プライベートに作成したものが含まれます。

```
$ greple -M
Use -M option at the beginning with module name.
Available modules:
	dig
	find
	line
	perl
	pgp
	select
	subst
	autocolor
	i18n
	termcolor
```

greple の拡張モジュールは、`App::Greple` の下にある小文字ではじまる Perl モジュールです。大文字ではじまるものは greple そのものを実装するためのものです。

greple の拡張モジュール機能は `Getopt::EX` モジュールで実現されており、`App::Greple` に加えて `Getopt::EX` の下にある汎用のモジュールを使うこともできます。`i18n`, `termcolor` などは `Getopt::EX` のモジュールです。

## モジュールを呼び出す

 `-M` オプションにモジュール名を指定することで、そのモジュールを呼び出すことができます。次の例は `App::Greple::find` モジュールを使うことを指示していますが、greple の拡張モジュールとして使用する場合には、単に `-Mfind` と指示します。

```
greple -Mfind
```

## マニュアルを表示する

モジュールオプションに続いて `--help` オプションを指定することで、そのモジュールのマニュアルを表示することができます。

```sh
$ greple -Mfind --man
```
```
NAME
    find - Greple module to use find command

SYNOPSIS
    greple -Mfind find-options -- greple-options ...

DESCRIPTION
    Provide find command option with ending '--'.

    Greple will invoke find command with provided options and read its output
    from STDIN, with option --readlist. So

        greple -Mfind . -type f -- pattern

    is equivalent to:

        find . -type f | greple --readlist pattern

    If the first argument start with `!', it is taken as a command name and
    executed in place of find. You can search git managed files like this:

        greple -Mfind !git ls-files -- pattern
```

ただ、実装上の都合で、別のモジュールのマニュアルが表示されてしまうことがあります。その場合は、`man` コマンドや `perldoc` で `App::Greple` に続いてモジュール名を指定します。

```sh
man App::Greple::find
perldoc App::Greple::find
```

ちなみに、`--man` の代わりに `--show` を使うと、モジュールの内容を見ることができます。`perldoc -m` としても同じです。

## モジュールを使う

モジュールの使い方について `find` と `dig` モジュールを例に説明します。

greple には `grep -r` のようにディレクトリの下を再起的に検索するオプションはありません。その代わりに `--readist` というオプションがあって、標準入力から読んだファイル名を検索対象とします。find コマンドの出力を `--readlist` オプションで読み込めば再起的な検索が可能です。

```sh
find . -type f | greple --readlist Copyright
```

`find` モジュールを使うと、greple コマンドのオプションとして find オプションを指定することができるようになります。`-Mfind` から `--` までの間の引数を `find` コマンドのオプションとして処理します。

```sh
greple -Mfind . -type f -- Copyright
```

find コマンドのオプションは非常に詳細な指定が可能ですが、使いこなすのにはちょっとコツが必要です。たとえば .git ディレクトリを検索対象から外すためには次のように指定します。あまり直感的ではなくて、`-prune` オプションの使い方はいつもわからなくなります。

```sh
find . -name .git -prune -o -type f
```

git だけではなく様々なケースに対応しようとすると、オプションはさらに複雑化してきます。`dig` モジュールは `find` モジュールの面倒なオプションを自動的に設定して、必要のないリポジトリや画像ファイルなどをスキップするためのモジュールです。次のように使うことができます。

```sh
greple -Mdig Copyright --dig .
```

このコマンドは、実際には次のようなオプションに展開されて実行されます。

```sh
greple -Mfind .
( ( ( -name .git -o -name .svn -o -name RCS -o -name CVS ) -o ( -name .vscode ) -o ( -name .build -o -name _build ) ) -prune -o -type f )
! -name .* ! -name *,v ! ( -name *~ -o -name *.swp )
! ( -iname *.jpg -o -iname *.jpeg -o -iname *.gif -o -iname *.png -o -iname *.ico -o -iname *.heic -o -iname *.heif -o -iname *.svg )
! ( -iname *.tar -o -iname *.tar.gz -o -iname *.tbz -o -iname *.tgz -o -name *.a -o -name *.zip )
! -iname *.pdf ! ( -name *.db -o -iname *.bdb )
! ( -name *.bundle -o -name *.dylib -o -name *.o -o -name *.fits )
-print --
```

これを手で入力することを考えると気が遠くなりそうです。

`dig` モジュールには `--git` というオプションも定義されていて、`git ls-files` の結果に対して検索をかけることができます。


## まとめ

今回は greple のモジュール機能について、その使い方を紹介しました。greple には、これまで紹介していないオプションが数多くありますが、モジュールを使うことで、複雑なオプション指定を組み合わせてシンプルなインタフェースを提供することが可能になります。モジュールの作り方については、機会を改めて説明します。

## SEE ALSO

https://qiita.com/advent-calendar/2021/greple

1. https://qiita.com/kaz-utashiro/items/5b6bcbe54891b3bd9db5
2. https://qiita.com/kaz-utashiro/items/eb8c7067e6de34842fe3
3. https://qiita.com/kaz-utashiro/items/165e744d4250adedc4c1
4. https://qiita.com/kaz-utashiro/items/439e6abcecf36c520703
5. https://qiita.com/kaz-utashiro/items/24ac0b8fdd30b598e069
6. https://qiita.com/kaz-utashiro/items/a1ba4e3d07cf37dc25e3
7. https://qiita.com/kaz-utashiro/items/0c8c944c17a72724b771
8. https://qiita.com/kaz-utashiro/items/8783c2fd0cc4315b9a3d
9. https://qiita.com/kaz-utashiro/items/84f5a6be6bf996076c64
10. https://qiita.com/kaz-utashiro/items/ebc7ea99f800cfc8c90c

- https://github.com/kaz-utashiro/greple
- https://metacpan.org/dist/App-Greple
