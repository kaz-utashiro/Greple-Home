---
title: "初期設定ファイル .greplerc"
weight: 12
id:      ebbeb8a5538a15ff04fc
---

greple は、UNIX の他の多くのコマンドと同様に、ホームページに初期設定ファイル (~/.greplerc) を用意することで、起動時にそれを読み込むことができます。この中では、様々な設定が可能です。

## default: デフォルトオプション

`option` 命令で新しいオプションを定義することができます。中でも `default` という名前は特別で、実行時に自動的に付与するオプションを指定することができます。たとえば、次のように設定すると、ハイライトモードが常に有効になります。

```
option default --color=always
```

さらに、行番号を表示させたければ、このようにします。default の定義が複数行あった場合には、最後の定義だけが有効になります。

```
option default --color=always -n
```

## option: オリジナルオプション

自分でオリジナルのオプションを定義することもできます。次のように設定しておけば `--sushi` と書くだけで、そこに定義したオプション指定したことになります。

```
option --sushi --outside '^\S+' --exclude '^お子様セット.*'
```

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/ee2dab7d-b5f1-6f21-580a-44be630fe7bf.png)

`-do` はデバッグ用のオプションで、最終的に実行されるオプションを表示します。

## define: マクロ定義

複雑なオプションを定義する際には、マクロによる文字列置換を使用することができます。

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

option  --solarized \
        --cm {yellow}  \
        --cm {orange}  \
        --cm {red}     \
        --cm {magenta} \
        --cm {violet}  \
        --cm {blue}    \
        --cm {cyan}    \
        --cm {green}
```
## autoload: モジュールの自動読み込み

`autoload` は、モジュールを自動的に読み込むための命令です。次の設定は `--dig` および `--git` オプションは `dig` モジュールで定義されていることを指示します。`--dig` オプションは `-Mdig --dig` に展開され、`dig` モジュールが自動的に読み込まれます。

```
autoload -Mdig --dig --git
```
## `__PERL__`: 任意コードの実行

`.greplerc` の中に `__PERL__` という文字列があると、それより後の内容を Perl プログラムとして評価します。

greple のオプションの中には、任意の関数を呼び出すことができるものがあります。たとえば `--begin` オプションを使うと、ファイルを検索する前にその内容に対して行う処理を指定することができます。

`.greplerc` に次のようなコードを用意したとします。

```
__PERL__
sub remove_header {
    s/\A---\n(.+\n)+---\n\n*//;
}
```

すると、次のようにして、マークダウンファイルを検索する前に、ヘッダ部分を削除することができます。

```
greple --begin '&remove_header' *.md
```

他の言語にも対応できるように、このような形式にしていますが、今のところ対応しているのは　Perl だけです。

## まとめ

greple の初期設定ファイル .greplerc について紹介しました。

オプションを組み合わせることで、様々なタイプのデータに対応する複雑な処理を実現することができますが、どうしてもコマンド行が複雑化してきます。.greplerc に自分でよく使うオリジナルオプションを定義することで、作業を効率化することができます。

デフォルトオプションについては、.greplerc に記述する以外に、`GREPLEOPTS` という環境変数を設定する方法もあります。


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

- https://github.com/kaz-utashiro/greple
- https://metacpan.org/dist/App-Greple
