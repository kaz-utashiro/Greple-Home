---
title: "カラーオプション（続き）"
weight: 14
id:      2b20e0226cffde213ce0
private: false
---

## 色についてもっと色々

前回は、カラーマップを指定する `--colormap` オプションと、色の指定の仕方について紹介しました。今回は、色を扱う様々なオプションについて紹介します。

## --colormap

greple のカラーマップには、名前付きカラーと、インデックスカラーの2種類があり、どちらも `--colormap` (`--cm`) オプションで設定することができました。今回紹介するのは、マッチしたパターンをハイライトするために使用されるうインデックスカラーに関するものです。

## --regioncolor, --ri

以前に、複数の検索範囲を指定すると、それぞれの領域に別の色が割り当てられる例を紹介しました。

    greple -n --inside '^\S+' --outside '^\S+' '[ー\p{Katakana}]+' sushi.txt

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/93d1783b-a8e0-59a4-4acf-9ab8e9276dae.png)

<!--

    greple -n --inside '^\S+' --outside '^\S+' まぐろ sushi.txt --all

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/0c5f7d2e-4f73-0227-a406-aa32f828e433.png)

---

しかし、複数の検索ワードが指定されている場合、次のようにそれぞれのパターンに別の色が割り当てられます。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/557e8274-601e-6534-1321-361100ff1fcb.png)

`--regioncolor` (`--rc`) オプションは、領域による色分けを強制するものです。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/d4d002f3-3a9e-99de-74c5-5c0f25174f2b.png)

## --uniqcolor, --uc

次のようにすると、全部の寿しネタを抜き出すことができます。

    greple -n --outside '^\S+' '\S+' sushi.txt

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/393e6f17-197b-26f6-7551-119432374cd4.png)

`--uniqcolor` (`--uc`) オプションを使うと、マッチした文字列に固有の色を割り当てて、わかりやすく表示することができます。

    greple -n --outside '^\S+' '\S+' sushi.txt --uc

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/5e9da2c6-fa56-cc28-9072-b8963458a3ee.png)

## --colorindex, --ci

`--colorindex` (`--ci`) は、インデックスカラーを適用するアルゴリズムを指定するオプションで、次のパラメータを取ります。

|記号| 意味  |
|:-:|:-----|
| A |Ascend|
| D |Descend|
| R |Random|
| B |Block |

### Ascend (昇順)

`--uc=A` オプションを指定すると、それぞれのマッチに順番に色を割り当てていきます。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/3b44f5f7-c266-ab6b-d9d2-412df1a64d28.png)

`--cm` オプションで2つの色を指定して、それを交互に適用することもできます。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/37b8b814-b5bd-8e48-8e77-0282edbf94ce.png)

### Ascend/Block (昇順/ブロック)

`--uc=AB` のように `B` (ブロック)　を指定すると、各ブロック毎に順序をリセットするようにようになります。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/72ec69a4-3572-d235-57c1-02fb680b7b73.png)

なんの役に立つのかと思うかもしれませんが、こんな使い方はいかがでしょう。

    sed /^#/d /etc/passwd | head | greple '[^:\n]+' --ci=AB

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/174a52de-3063-f4fd-f6e6-aa8fdb0780a7.png)

### Descend (降順)

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/df0a616a-0d88-43cc-a34d-01979a6d6efe.png)

### Random (ランダム)

ランダムは、文字通りランダムに色を割り当てます。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/c877399b-b797-9597-01b7-70de8b55fc07.png)

これも何の役に立つのかと言われると困るのですが、意匠的には面白い効果を得ることができます。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/2f4512ba-67ce-c23f-91b4-b4a1b0f14d23.png)

## まとめ

今回は、インデックスカラーの適用方法について説明しました。途中説明を省略していますが、`--face` というオプションはすべてのインデックスカラーに対して効果を適用するオプションです。行末まで背景色を適用する `E` と組み合わせると、面白い効果が得られます。

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

- https://github.com/kaz-utashiro/greple
- https://metacpan.org/dist/App-Greple
