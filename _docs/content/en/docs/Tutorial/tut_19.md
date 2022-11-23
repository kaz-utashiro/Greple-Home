---
title:   "モジュールの作り方 (1)"
weight: 19
id:      010f141f17e855aab4fc
private: false
---

## 宣言だけのモジュール

最も単純なモジュールは、`.greplerc` と同じように、オプションの定義だけでできたものです。

## モジュールの宣言

しかし、greple のモジュールは Perl のモジュールでもあるので、最低限の作法に従わなければなりません。

標準モジュールの `colors` は、先頭で次のように宣言しています。

```perl
package App::Greple::colors;
1;
__DATA__
```

`App::Greple::colors` という Perl のパッケージだということを宣言して、呼び出されると真の値である 1 を返すだけです。greple から使用する際には、自動的に `App::Greple` が付加されるので `-Mcolors` のように呼び出すことができます。

宣言の後に `__DATA__` というキーワードが続きます。これは、これ以降にはプログラムで扱うデータが含まれているという意味です。何も書くことがなければ、必要ありませんが、そうするとこのモジュールは何もしなくなります。

この3行だけが必要で、その後に含まれるデータは greple モジュール定義として解釈されます。実際には、ドキュメントも含まれていることが普通ですが、なくても問題ありません。

## モジュール本体

greple は、`__DATA__` 部分に含まれる内容を `.greplerc` と同じように処理します。

```
option	--light \
	--cm K/544,K/454,K/445 \
	--cm K/455,K/545,K/554 \
	--cm K/543,K/453,K/435 \
	--cm K/534,K/354,K/345 \
	--cm K/444 \
	--cm K/433,K/343,K/334 \
	--cm K/344,K/434,K/443 \
	--cm K/333

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

これで、`greple -Mcolors` という形式でモジュールを呼び出すと `--light` と `--dark` という2つのオプションが利用できるようになります。

実際に実行すると、次のようになります。デバッグオプション `-do` を使って、実際に適用されるオプションを表示しています。


![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/bdf310f1-0522-7b99-ba47-5d9f87cadf50.png)

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/00e65164-9bd9-3f4a-0dbd-cbd28ea6c4d0.png)

## マクロ展開

前にも紹介したように、この中ではマクロを使うことができて、`--solarized` オプションは次のように定義されています。

```
define {base03}  #002b36
define {base02}  #073642
define {base01}  #586e75
define {base00}  #657b83
define {base0}   #839496
define {base1}   #93a1a1
define {base2}   #eee8d5
define {base3}   #fdf6e3
define {yellow}  #b58900
define {orange}  #cb4b16
define {red}     #dc322f
define {magenta} #d33682
define {violet}  #6c71c4
define {blue}    #268bd2
define {cyan}    #2aa198
define {green}   #859900

option --solarized --solarized-fg

option	--solarized-fg \
	--cm {yellow}  \
	--cm {orange}  \
	--cm {red}     \
	--cm {magenta} \
	--cm {violet}  \
	--cm {blue}    \
	--cm {cyan}    \
	--cm {green}
```

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/22337a0e-ecc2-fa82-376c-a719ea423b58.png)

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/13df1b41-989b-c321-32e1-448e6de1ad2c.png)

## まとめ

`.greplerc` を使うと、日常的に使うオプションを定義しておくことができます。しかし、様々な目的のオプションが混在してくるとファイルの内容が煩雑になってきますし、滅多に使うことがないようなものをいつも処理しなければならなくなります。

モジュールとしてまとめることで、特定の目的のためのオプションを1箇所で管理し、モジュール間で矛盾が起きることを気にする必要もなくなります。また、関係者の間で共有したり、オープンソースとしてリリースすることも可能になります。

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
18. https://qiita.com/kaz-utashiro/items/6e4b1f51455e587ef743

- https://github.com/kaz-utashiro/greple
- https://metacpan.org/dist/App-Greple
