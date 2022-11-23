---
title: "入出力フィルター"
weight: 16
id:      d19fe5ee859f31ce172c
private: false
---

## 入出力フィルターを使う

greple には、データの入力時と出力時にフィルターを設定する機能があります。普通に使う時にはパイプを使えばいいだけなので、それほど必要性はないのですが、モジュールと組み合わせることで威力を発揮します。

## 入力フィルター: --if

入力フィルターを指定します。

単純な形式は `--if=filter` です。たとえば、

    greple --if='cat -n' ^ sushi.txt

のように実行すると、`cat -n` の結果を検索します。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/9a107079-e7de-28f4-d4be-b954f35a2aa5.png)

フィルターオプションが `--if=exp:filter` のような形式の場合 `exp` を Perl の式として評価して、結果が真あれば、そのフィルターを適用します。

```
greple -n --if='s/\.gz$//:gunzip -c' まぐろ sushi.txt.gz
```

式を評価する時には、ファイル名が `$_` 変数に設定されています。上の例では、ファイル名が `.gz` で終わっていたら `gunzip -c` コマンドを使って圧縮を解いたテキストを検索します。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/51902ea0-e4f7-8640-df4d-bbdf1e7a34d7.png)

実は greple には、これに相当するフィルタがデフォルトで含まれているので、何も指定しなくても圧縮ファイルを検索することが可能です。フィルタの形式とは少し違いますが、これがデフォルトのフィルタルールです。圧縮ファイル以外に、 PDF や暗号化されたファイルも検索することができます。

```perl
[ sub { s/\.Z$//   }, 'zcat' ],
[ sub { s/\.g?z$// }, 'gunzip -c' ],
[ sub { m/\.pdf$/i }, 'pdftotext -nopgbrk - -' ],
[ sub { s/\.gpg$// }, 'gpg --quiet --no-mdc-warning --decrypt' ],
```

入力フィルターを使えば、テキストファイルではないデータからテキストを抽出して検索することもできます。次の例では、画像ファイルのメタ情報を検索しています。

    greple --if 'exif /dev/stdin' --cm=U --or Lens --or Exposure --or Speed IMG.jpg

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/da59a769-78ec-a054-63c2-7a3aef65b0c9.png)

## 出力フィルター: --of

出力フィルター形式は `--of=filter` です。たとえば、

    greple --of 'cat -n' まぐろ sushi.txt

のように実行すると、検索した結果が `cat -n` を通して表示されます。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/e9c90a61-7ce1-6ae0-d8da-66bd4cb5dd2f.png)

`--if` と比べて、行番号が変わっているのがわかります。

## プロセスフィルター: --pf

`--of` で指定されたフィルターは、それぞれのファイル毎に実行されます。それに対して `--pf` で指定されたフィルターは greple プロセスの出力に対して1回だけ実行されます。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/a30a6fd0-c2d2-4f78-ccb2-8b8c80f00a6d.png)

## まとめ

入出力フィルターをコマンドオプションとして使うことは稀で、何らかの目的で作られたモジュールの中で使われた時に有効に機能します。次の例は実際のモジュールから抜き出したものですが、複数行のデータをソートして出力するためのものです。ブロック内の改行文字をキャリッジリターンに置き換えて、最後にフィルターを通してソートしてから元に戻しています。

    --pf 'sort | tr \\015 \\012'

今回紹介したフィルターは、複数回指定して多段で適用することもできます。また、今回は紹介していませんが、外部コマンドではなくて、モジュール内で定義した任意のプログラムをフィルターとして指定することも可能です。

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

- https://github.com/kaz-utashiro/greple
- https://metacpan.org/dist/App-Greple
