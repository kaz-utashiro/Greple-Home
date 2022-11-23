---
title: "検索ブロック指定"
weight: 10
id:      ebc7ea99f800cfc8c90c
private: false
---

一般的に、grep 系のツールが検索の対象とするのは「行」です。しかし、扱いたい情報の単位は行とは限りません。greple は、検索対象とするデータの単位を柔軟に指定することができます。

## --all

`--all` は、ファイル全体を検索単位とするオプションです。

このオプションが有効なのは、当たり前ですが、ファイルの内容を全部見たい場合です。

寿司セットの中には魚介類以外のネタとして「サラダ」「アボカド」「うどん」があって、すべてを AND で指定すると、そのすべてを含むセットはありませんが `--all` を指定すれば全体を眺めることができます。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/33ceac6e-bed0-5bbc-2104-2a334af6292f.png)

対象が原稿であれば、注目する部分をハイライトして、全体を眺めたいような場合に有効です。

ファイル名のみを表示する `-l` オプションと組み合わせて使用すると、指定したワードをすべて含むファイルを探すことができます。検索エンジンと同じような使い方です。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/5d178d48-e17c-d0fc-148c-c763633a238d.png)

## -p, --paragraph

`-p` (`--paragraph`) オプションを指定すると、行ではなく、空白行で区切られた**パラグラフ**を単位として検索を行います。複数キーワードの処理も、行ではなくパラグラフ単位で行われるので、指定したワードは同一行に含まれる必要はありません。

次の例では AND, OR, NOT, MUST という単語がすべて含まれるパラグラフを検索しています。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/695f4be3-46e8-fd62-8a1b-1f8b0001b652.png)

デフォルトでは、ファイル名は grep と同様にすべての行に表示されますが、`--filestyle=once` というオプションを指定することで、最初に一度だけ表示しています。

## --block

`--block` オプションでパターンを指定すると、それにマッチする部分が検索単位となります。次の例では git のソースコードから、Cのコメント部分 (`/*...*/`) をブロックとして指定して UTF, Unicode, BOM という単語がすべて含まれるブロックを検索しています。

```sh
greple --border '(?s)/\*.*?\*/' --fs=once -i 'utf unicode bom' *.h
```

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/074099d0-ba34-246f-88c3-a5567815a19b.png)

この場合、検索対象のブロックは連続していません。ブロックに相当しない場所でのマッチは無視されます。

## --border

`--border` オプションには `--block` と同じようにパターンを指定して、それを元にブロックを作りますが、`--block` と違い、マッチの始点と終点を境界とする連続したブロックを作ります。

デフォルトの行単位での挙動は `--border=^` を指定したのと同じで、パラグラフモードは連続する改行文字 `--border='\n\n+'` を指定したのと同じです[^p]。

[^p]: 簡略化して書いています。実際に使っているパターンは `(?:\A|\R)\K\R+` というものです。

次の例は、シャープ (#) で始まる行の行頭にブロック境界を設定します。つまり、# ではじまる行から次の行頭の # までの、マークダウン形式のパラグラフがブロックとなります。

```sh
greple --border '^(?=#)' PCRE *.md --fs=once
```

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/da3374d7-399e-2fb7-0bd0-d55f4f7603e4.png)

## -A, -B, -C

-A (after), -B (before), -C (context) オプションは、検索行の前後を同時に表示するためのもので、grep とほぼ同様に使うことができます。次の例は、マッチした前後1行ずつを表示しています。

```
greple -n -e びんちょう sushi.txt -C1
```

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/c5a2df53-3674-8e6b-a030-f66ad6533ef5.png)

この前後コンテキストも、指定したブロックに対して適用されます。ですから、パラグラフモードであれば、前後のパラグラフを一緒に表示します[^C]。

[^C]: `-C` オプションのデフォルトは2です。`-p` オプションを使った場合、空白行の部分も1パラグラフを構成します。したがって、このように前後1パラグラフずつを表示しているように見えます。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/c843918d-25a1-4b5f-42c4-bffd87e791bf.png)

この時、検索ロジックもコンテキスト同様に拡張されます。次の例で、最初のコマンドでは**びんちょう**と**サラダ**を両方含むセットは見つかりませんが、次のコマンドは `-C1` でコンテキストを前後に1行ずつ拡張することで、条件を満たすデータが発見されます。

```
greple -n -e びんちょう -e サラダ sushi.txt
greple -n -e びんちょう -e サラダ sushi.txt -C1
```

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/7490bdf4-ad6c-b89f-a10d-f663434040b4.png)

## まとめ

greple の検索単位を指定するブロック機能について紹介しました。テキストファイルであっても、行単位で情報が管理されていることはむしろ稀です。処理対象の情報単位を柔軟に設定することで、論理的に意味のあるデータブロックに対して検索等の操作をすることが可能になります。

今回紹介した単純なパターンマッチによる方法では処理できないような複雑なデータ形式もあります。そのような場合には、また別のアプローチがあります。

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

- https://github.com/kaz-utashiro/greple
- https://metacpan.org/dist/App-Greple
