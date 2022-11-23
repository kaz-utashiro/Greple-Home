---
title: "関数オプション"
weight: 18
id:      6e4b1f51455e587ef743
private: false
---
# 関数オプションについて

前回は、greple で関数を定義する方法と、それをコマンドオプションから使う方法について説明しました。今回は、関数オプションの種類について説明します。

## 事前・事後処理を指定するオプション

### --begin, --end

ファイルを処理する前と、処理した後に呼ばれる関数です。`--begin` を使った例を前回紹介しました。`$_` にはファイルの内容が保持されていて、データを変更することもできます。

### --prologue, --epilogue

一連の検索処理を始める前と、終了した後に呼ばれる関数です。ファイルはオープンされていないので、`FILELABEL` 引数は渡されません。

## 出力に関わるオプション

### --colormap

カラーマップに関数を指定すると、彩色する代わりに関数の結果に置き換えて出力します。ここでは `&func` のように指定する以外に、Perl の無名関数を直接記述することもできます。次の例では `sub{"[$_]"}`という関数を指定して、マッチした文字列を括弧で囲んで表示しています。このように `--colormap` で指定された関数には、表示しようとする文字列が `$_` として渡され、関数の結果によって置き換えられます。

    greple -n --outside '^\S+' はまち --cm 'sub{"[$_]"}' sushi.txt

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/090119a7-3c8a-ca49-a2e7-cdbb5ac124ea.png)

### --print

検索結果のブロックを表示する時に呼ばれる関数を指定します。`--colormap` の方が便利なので、あまり利用する機会はありません。

## --uniqsub

`--uniqcolor` オプションで、マッチした文字列に対して固有の色を割り当てられることについては、すでに説明しました。`--uniqsub` は、その判定の際に使われる同一性を定義するオプションです。

たとえば、次のようにすると、寿司ネタをその名前の文字数で色分けします。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/7b0ac395-c5c5-6de8-cf54-6e19cdcdaa51.png)

## --callback

これは、簡単に説明するのは無理なので、興味がある方はマニュアルを読んでください。callback インタフェースは、以下の記事で紹介している `subst` モジュールで使用しています。

https://qiita.com/kaz-utashiro/items/85add653a71a7e01c415

## リージョンを指定するオプション

以下のオプションは、どれもリージョン（範囲）を返すことが期待されています。リージョンは、ファイル内でのデータのオフセットを表す `[start, end]` のリストです。

### --block
### --inside, --outside, --include, --exclude
### --le

これらについては、すでに今までに紹介し、その時にはパターンを指定して使用しました。

以下の関数 `match` は、`pattern` で与えられた文字列を検索して、それに対応するリージョンを返します。これらのオプションは、この関数を呼ぶのとほぼ同じ動作をします。

```perl
sub match {
    my %arg = @_;
    my @match;
    while (/$arg{pattern}/g) {
        push @match, [ $-[0], $+[0] ];
    }
    @match;
}
```

以下のコマンドはまったく同じように動作し、連続する3行をブロックとして検索を実行します。

    greple -n --block '(.+\n){3}' サラダ sushi.txt
    greple -n --block '&match(pattern=(.+\n){3})' サラダ sushi.txt

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/1f27414a-8525-5970-0de7-95f2d65a8fe1.png)

簡単な例を作るのは難しいので、実際に使っている様子をお見せします。下の画面は、以前翻訳した書籍の原稿を greple の機能を使って表示したものです。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/15312e3b-2fde-7a4a-5c40-ea2b6de468f5.png)

この原稿は以下のリージョンで構成されています。greple の機能を使うことで「対訳：日本語部」分のみを検索対象にするなどが可能になります。これらのリージョンを単純なパターンマッチで生成するのは難しいため、スクリプトで実装してあります。

- マクロ
- コメント
- 原文
- 訳文
    - 対訳：英語
    - 対訳：日本語

## フィルター

### --if, --of, --pf

フィルターオプションにも関数を指定することができます。ちょっと説明が難しいので、`pgp` モジュールの一部を載せておきます。雰囲気だけ見てください。

最後の

    option default --if s/\\.(pgp|gpg|asc)$//:&__PACKAGE__::filter

で、デフォルトオプションを設定しています。これによって `.pgp` などで終わるファイルを処理しようとすると、ここで定義している `filter` 関数が入力フィルターとして実行されます。関数は内部で fork して、サブプロセスとして復号処理を実行し、親プロセスはサブプロセスからの出力を標準入力として処理します。

```perl:pgp.pm
sub filter {
    activate if not defined $pgp;
    $pgp->reset;
    my $pid = open(STDIN, '-|') // croak "process fork failed";
    if ($pid == 0) {
        exec $pgp->decrypt_command or die $!;
    }
    $pid;
}
1;
__DATA__
option default --if s/\\.(pgp|gpg|asc)$//:&__PACKAGE__::filter
```

## まとめ

greple の関数オプションについて簡単に紹介しました。これらは単独ではなく、他の様々な機能と組み合わせて利用することで効力を発揮します。

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
11. https://qiita.com/kaz-utashiro/items/25a14e75380c39b5e0af
12. https://qiita.com/kaz-utashiro/items/ebbeb8a5538a15ff04fc
13. https://qiita.com/kaz-utashiro/items/b265deef9c9b1953a414
14. https://qiita.com/kaz-utashiro/items/2b20e0226cffde213ce0
15. https://qiita.com/kaz-utashiro/items/16b5142ef7a89aa35380
16. https://qiita.com/kaz-utashiro/items/d19fe5ee859f31ce172c
17. https://qiita.com/kaz-utashiro/items/09a5f5cf08ce314e2add

- https://github.com/kaz-utashiro/greple
- https://metacpan.org/dist/App-Greple
