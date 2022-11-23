---
title: "カラーオプション"
weight: 13
id:      b265deef9c9b1953a414
private: false
---

greple は、複数のハイライトカラーを使って結果を表示することができます。これまで紹介したような、検索キーワードの色分け以外にも、様々な色の指定が可能です。今回は、色の指定方法について紹介します。

## カラーマップ

greple の色情報はカラーマップで管理され、その中にはインデックスリストと名前付きのリストという2種類の要素があります。つまり、リストとハッシュです。

`-dc` というデバッグオプションを使うと、カラーマップ情報を見ることができます。デフォルトのカラーマップはこうです。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/03d5c09f-4f59-dc16-558b-ccf58a0c430e.png)

最初に表示されているのが名前付きリストで、ファイル名 (`FILE`) や行番号 (`LINE`) の表示色に関する情報を保持しています。

次にあるのがインデックスリストで、検索した文字列をハイライトするために使われます。

## --colormap, --cm オプション

カラーマップは `--colormap` オプションで指定します。ちょっと長いので `--cm` と省略することもできます。デフォルトのカラーマップは、次のように指定したのと同じです。

```
--cm BLOCKEND=/WE,FILE=G,LINE=Y,PROGRESS=B,TEXT= \
--cm 000D/544,000D/454,000D/445 \
--cm 000D/455,000D/545,000D/554 \
--cm 000D/543,000D/453,000D/435,000D/534,000D/354,000D/345 \
--cm 000D/444,000D/433,000D/343,000D/334 \
--cm 000D/344,000D/434,000D/443,000D/333
```
1行目の名前付きのリストは `NAME=color` という形式、2行目以下のインデックスリストはラベルなしの `color` だけです。複数の要素をカンマで区切って同時に指定することができます。`--cm` オプションは繰り返し使うことができるので、上の例では分けて書いてありますが、1つにまとめてしまっても構いません。

簡単に説明すると、G (Green), Y (Yellow) などの基本の色、D (ボールド) のような効果、544 のように 0-5 の数字3桁で表された216色で指定されています。スラッシュ (`/`) の左がフォアグラウンド、右側はバックグラウンドカラーです。

## 色の指定

### 基本 16色

```
    R  r   Red
    G  g   Green
    B  b   Blue
    C  c   Cyan
    M  m   Magenta
    Y  y   Yellow
    K  k   Black
    W  w   White
```

大文字は、赤、緑、青、シアン、マジェンタ、黄、黒、白の基本の8色です。小文字は代替色を意味しますが、多くの端末では基本色よりも明るい色が指定されています。

### RGB 6x6x6 216色

```
    000 .. 555         : 6x6x6 RGB 216 colors
```

RGB 値を0から5の数字で表した216色です。

慣れると案外わかりやすくて、555は白、R以外を0にして500なら原色の赤。GとBの値を増やすと白に近づいて544は淡い赤という具合です。RGB と CMY のポジションが対応していて、R　の部分を落とした055は、補色のシアン、Bを落として550なら黄色になります。1つだけ大きければ RGB、1つだけ小さければ CMY と憶えるとわかりやすいと思います。

基本のカラーマップは RGB に 543 のどれかを当てた組み合わせをバックグラウンドカラーとしています。


### グレースケール 24色

`L01` から `L24` は、24階調のグレースケールです。`L00` は黒 (`000`)、`L25` は白 (`555`) と同じです。`W` や `w` は、真っ白とは限りません。

```
    L00 .. L25         : Black (L00), 24 grey levels, White (L25)
```

### 12ビット/24ビット RGB

RGB を10進や16進の、12ビット値あるいは24ビット値で指定することもできます。ただし、256色表示の端末では表示できないので、その場合は近似する216色に変換して表示します。

```
    (255,255,255)      : 24bit decimal RGB colors
    #000000 .. #FFFFFF : 24bit hex RGB colors
    #000    .. #FFF    : 12bit hex RGB 4096 colors
```

### 名前

https://en.wikipedia.org/wiki/X11_color_names で定義されている名前で色を指定することができます。

```
    <red> <blue> <green> <cyan> <magenta> <yellow>
    <aliceblue> <honeydue> <hotpink> <mooccasin>
    <medium_aqua_marine>
```

### 効果

色以外の効果を指定することもできます。よく使うのはボールド(`D`)、イタリック(`I`)、アンダーライン(`U`)、反転(`S`)あたりでしょうか。見えなくする `H` や、見え消し線を引く `X` はサポートされていない端末もありますが、使い方によっては効果的です。点滅(`F`)は面白いけど、うるさいのであまり使いません。早い点滅 (Q) をサポートしている端末は見たことがありません。

```
    N    None
    Z  0 Zero (reset)
    D  1 Double strike (boldface)
    P  2 Pale (dark)
    I  3 Italic
    U  4 Underline
    F  5 Flash (blink: slow)
    Q  6 Quick (blink: rapid)
    S  7 Stand out (reverse video)
    H  8 Hide (concealed)
    X  9 Cross out
    E    Erase Line

    ;    No effect
    /    Toggle foreground/background
    ^    Reset to foreground
```

行消去の `E` は特殊で、文字の属性を定義するものではありません。これを指定すると、色設定のシークエンスと同時に、カーソルがある場所から行末までを消去するシークエンスを出力します。文字を消すのと同時に背景色で埋めるので、その色の線が引かれたように見えます。最初の例の `BLOCKEND` で使われています。

## ANSI 256色 ターミナルカラー

標準的な256色表示のANSI端末は、これまでに説明した基本の16色、6階調の RGB 216色、24階調のグレースケールを表示することができます。これは、次のコマンドで一覧することができます。

```
perl -MGetopt::EX::Colormap=:all -E colortable
```

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/542cd6ad-e187-dca5-a9d0-91c934e7140c.png)

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/1ee056a7-58fa-56df-4c40-ac813e644459.png)


## フルカラーターミナル

24ビットフルカラーに対応している端末では、フルカラーの指定をそのまま出力することができます。Apple の標準ターミナルは256色表示ですが、iTerm2 などはフルカラー表示が可能です。greple は、`COLORTERM` という環境変数に `truecolor` という値が設定されていると、フルカラー端末であると認識します。

## まとめ

greple は、複数の色を扱えることが特徴の１つです。しかし、色の指定が煩雑だと使いこなすのが難しいので、シンプルで統一的な方法で指定できるように工夫しています。現在は、色を管理する部分を切り出して `Getopt::EX::Colormap` という独立したモジュールでリリースしています。

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

- https://github.com/kaz-utashiro/greple
- https://metacpan.org/dist/App-Greple
