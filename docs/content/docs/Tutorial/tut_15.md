---
title: "カラーマップの切り替え"
weight: 15
id:      16b5142ef7a89aa35380
private: false
---
[colors]: https://github.com/kaz-utashiro/greple/blob/master/lib/App/Greple/colors.pm
[termcolor]: https://github.com/kaz-utashiro/Getopt-EX-termcolor

## 端末の背景色によって色を選ぶ

2回に渡り、カラーオプションについて紹介しました。しかし、人によって使用する端末は様々で、デフォルトの配色がすべての環境に適しているとは限りません。今回は、環境や好みに応じてカラーマップを切り替える方法を紹介します。

## 黒いターミナル

前回紹介した、寿司ネタを `--uniqcolor` オプションで表示した例です。greple のデフォルトカラーは、白い背景色を前提にしていて、淡い基調の背景に黒い文字で設定してあります。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/c21efd5f-0243-e050-e76d-b4bb0f3ebc06.png)

エンジニアの中には黒い背景のターミナルを好む人は多いですし、最近はダークモード流行りでもあります。黒い背景の端末で同じコマンドを実行すると、このように見えます。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/8787c0e7-5047-69ce-4b75-b497a39c786b.png)

みにくいことはありませんが、明るさの変化が激しすぎてケバケバしい印象を受けます。まあ、なんというか、品がありません。

標準で添付されているモジュールには `--light` と `--dark` というオプションが設定されていて、`--dark` を使うとこのようになります。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/ed435ae2-0e81-ac33-3ad7-1883d68f5bec.png)

背景色に合わせて、濃い基調の背景色に白い文字を組み合わせています。実際の設定はこのようなもので、`--light` の背景色が 345 の組み合わせであるのに対して、`--dark` では 012 の組み合わせになっています。若干 `001` のブルーの背景が端末の黒と見分けづらい点を除けば、概ね良好ではないでしょうか。

```
option	--dark \
	--cm 555/100,555/010,555/001 \
	--cm 555/011,555/101,555/110 \
	--cm 555/021,555/201,555/210 \
	--cm 555/012,555/102,555/120 \
	--cm 555/111 \
	--cm 555/211,555/121,555/112 \
	--cm 555/122,555/212,555/221 \
	--cm 555/222
```

`--light` と `--dark` を両方指定して、カラーバリエーションを増やすこともできます。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/44599e3b-e32f-5eba-4d4e-40daac2ce5c4.png)

いつも `--dark` オプション付きで実行したければ、`~/.greplerc` を次のように設定することで、ダーク端末用のカラーパレットを適用することができます。

```:~/.greplerc
option default --dark
autoload -Mcolors --dark --solarized
```

## solarized

[Solarized]: https://ethanschoonover.com/solarized/

[Solarized] というカラーパレットをご存知でしょうか。こんなのです。様々な環境で気持ちよく見えように計算された配色で、多くの端末やエディタなどに採用されています。

![](https://raw.githubusercontent.com/altercation/solarized/master/img/solarized-yinyang.png)

`colors` モジュールには `--solarized` というオプションが定義されています。

```
define {yellow}  #b58900
define {orange}  #cb4b16
define {red}     #dc322f
define {magenta} #d33682
define {violet}  #6c71c4
define {blue}    #268bd2
define {cyan}    #2aa198
define {green}   #859900

option	--solarized \
	--cm {yellow}  \
	--cm {orange}  \
	--cm {red}     \
	--cm {magenta} \
	--cm {violet}  \
	--cm {blue}    \
	--cm {cyan}    \
	--cm {green}
```

これを使って寿司ネタを表示すると、こうなります。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/f5075a7d-7853-38b2-fb0e-fc5ea1ec5447.png)

ただ、これは Apple Terminal の近似色で表示されています。フルカラー表示の iTerm では下のようになります。違いがわかるでしょうか。iTerm の方が微妙な色の違いが表現されてはいますが、逆に「えび」(orange)、「たまご」(red)、「いか」(magenta)」の違いは曖昧で、どちがが見やすいかと一概には言えないような気もします。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/2be927cd-6710-16df-a104-3f5f4dfb4173.png)

次の例は、同じコマンドを iTerm のダークターミナルで表示したものです。Solarized カラーパレットは、このように明るい背景色でも、暗い背景色でも違和感を感じない配色になっています。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/95985ddf-569d-cb68-f503-39f1eb05a137.png)

## termcolor モジュール

使うターミナルの背景色がいつも同じであれば、それを設定しておけばいいのですが、異なる背景色を使い分ける人もいるでしょう。そのような場合に、使用している背景色に応じて適したオプションを自動的に設定するのが `termcolor` モジュールです。

`termcolor` モジュールは greple ではなく、greple が使用する `Getopt::EX` 用の汎用モジュールです。次のように使うと、使用しているターミナルの背景の明るさに応じて `--light` あるいは `--dark` というオプションを自動的にセットします。Apple_Terminal、iTerm あるいは xterm 互換ターミナルであれば自動的に背景色を判定できますが、できなかった場合には最大値の 100 を使用します。

    -Mtermcolor::bg(default=100,light=--light,dark=--dark)

次の例は、デバッグオプションを使って、オプションが展開される様子を示しています。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/d743c042-fdba-0dcd-7654-28a8bdc2ead6.png)

`~/.greplerc` を次のように指定しておくと、常に適用されます。

```:~/.greplerc
option default --autocolor
option --autocolor -Mtermcolor::bg(default=100,light=--light,dark=--dark)
```

## まとめ

端末の背景色によって、カラーマップを切り替える方法について紹介しました。最後の `termcolor` モジュールを使った方法は便利ですが、対応していない端末では使えなかったり、自動取得のためのオーバーヘッドがかかるなどの問題もあります。`TERM_BGCOLOR` という環境変数を設定しておくと、それを背景色として使うようになるので、興味のある方は[マニュアル](https://github.com/kaz-utashiro/Getopt-EX-termcolor#readme)を読んで工夫してみてください。未対応端末をサポートしてくれるのは大歓迎です。

`colors` モジュールをベースに、自分で好きな配色を作ってみても面白いと思います。

## SEE ALSO

colors: https://github.com/kaz-utashiro/greple/blob/master/lib/App/Greple/colors.pm


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

- https://github.com/kaz-utashiro/greple
- https://metacpan.org/dist/App-Greple
