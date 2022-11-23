---
title: "モジュールの作り方 (2)"
weight: 20
id:      88a70cbdb9cc6c7a4520
private: false
---

## モジュール内で関数を定義する

前回は、単純な宣言のみのモジュールの作り方について説明しました。今回は、モジュール内で定義関数をオプションから呼び出す方法を紹介します。

## 入出力フィルター

greple の入出力フィルターについては以前の記事で紹介しました。

https://qiita.com/kaz-utashiro/items/d19fe5ee859f31ce172c

フィルターには `--if`, `--of`, `--pf` の3種類があって、入力や出力に対して適用するフィルターコマンドを指定することができます。今回紹介するのは、コマンドではなく、モジュール内で定義した関数をフィルターとして利用する方法です。

## -Mmsdoc モジュール

greple の `msdoc` モジュールは、MicroSoft Office のファイルからテキストを抜き出して検索対象にするものです。

### オプション指定

まず、オプションの定義方法を見てみます。

```
__DATA__
option default --if '/\.(doc|ppt|xls)[xm]$/:&__PACKAGE__::extract_content'
```

ここでは、default オプションとして `--if` を指定しています。つまり、このモジュールを指定すると、常にこのフィルターが適用されることになります。

まず、ファイル名が `/\.(doc|ppt|xls)[xm]$/` にマッチするかどうかをチェックします。つまり docx, docm, pptx, pptm, xlsx, xlsm のいずれかの拡張子を持っているかをチェックして、この条件に当てはまると、その後で指定されている入力フィルターが適用されます。

以前コマンドを指定していた部分に `&__PACKAGE__::extract_content` と書かれています。このようにコマンド部分が `&` で始まると、コマンドではなく関数が実行されます。`__PACKAGE__` は、モジュールのパッケージに展開されるので、この場合は `App::Greple::msdoc` と書いたのと同じ意味です[^export]。

[^export]: main パッケージに export すればパッケージを指定する必要はありません。

結果として、docx 等のファイルを開くと `App::Greple::msdoc::export_content` という関数が実行されるようになります。

### 関数定義

内容を簡略化すると、このようになります。

```perl
package App::Greple::msdoc;

use App::optex::textconv::msdoc qw(to_text get_list);

sub extract_content {
    my %arg = @_;
    my $file = $arg{&FILELABEL} or die;
    my $pid = open(STDIN, '-|') // croak "process fork failed: $!";
    binmode STDIN, ':encoding(utf8)';
    if ($pid) {
        return $pid;
    }
    print to_text($file);
    exit;
}

1;
```

[greple #17 関数インタフェース](2021-12-20_grep_greple_09a5f5cf08ce314e2add.md)で説明したように、ファイル名は `FILELABEL` という名前付きパラメータとして渡されます。

フィルター関数は、プロセス管理を行うことが期待されています。つまり、入力フィルタであれば、フィルター自体は別プロセスとして動作し、元のプロセスは標準入力からデータを読み込みます。これを行っているのが以下の部分です。親プロセスは、何もせずに return します。

```perl
my $pid = open(STDIN, '-|') // croak "process fork failed: $!";
if ($pid) {
    return $pid;
}
```

子プロセスは、受け取ったファイルの内容をテキストに変換して、標準出力に書き出します。

実際の変換処理は `App::optex::textconv::msdoc` という別モジュールを利用しています。このモジュールで定義される `to_text` という関数を渡すと、その内容がテキストとして得られます。内容を書き出したら、子プロセスは `exit` します。
