---
title: "複数キーワード検索 単独オプション"
weight: 7
id:      0c8c944c17a72724b771
private: false
---

これまで `--le` オプションを使って、複数のキーワードを指定する方法について紹介してきました。キーワードの前に記号を付けることで AND, OR, NOT, MUST の意味を持たせることができました。

## 単独オプション

実は `--le` オプションで扱うそれぞれのキーワードは、個別の単独オプションで指定することもできます。一覧にすると、こうです。


| 記号 |      意味      |単独オプション|
|:----:|:--------------:|:------------:|
| なし | AND or OPTIONAL|  -e, --and   |
|  -   |      NOT       |  -v, --not   |
|  ?   |      OR        |  --or        |
|  +   |      MUST      |  -r, --must  |

このため、以下のコマンドは、どれも同じ意味になります。

```
greple 'まぐろ ?はまち ?えび -いくら' sushi.txt
greple 'まぐろ はまち|えび -いくら' sushi.txt
greple -e まぐろ --or はまち --or えび -v いくら sushi.txt
greple -e まぐろ -e 'はまち|えび' -v いくら sushi.txt
```

機能的に違いはないので、どれでも使いやすい方法で指定すればいいと思います。`--or` オプションに関しては、単独オプションで指定したものがグループ化されます。

## 絞り込み検索

単独オプションが便利なのは、次々にオプションを追加して、選択肢を絞り込んでいくような場合です。シェルのヒストリー機能を使って直前のコマンドを呼び出して、そのまま最後に追加していくことができます。

特に `-v` オプションは検索ワードを指定するオプションとしては解釈されないので、裸の（オプション指定なしの）検索ワードがあっても、最後に追加するだけで検索結果を絞り込むことが可能です。オプション引数とそれ以外の引数は、このように混在させることができます。

```
greple -n まぐろ sushi.txt
greple -n まぐろ sushi.txt -v いくら
greple -n まぐろ sushi.txt -v いくら -v いか
greple -n まぐろ sushi.txt -v いくら -v いか -v サーモン
```

実行してみるとこのような結果になります。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/b2efc8ec-8a80-7d09-5951-be7df0478eff.png)

ちょうど、パイプで `grep -v` コマンドをつないでいくのと同じ要領で絞り込んでいくことができます。

毎回**まぐろ**の色が変わってしまっているのは実装上の都合です。この結果を見て、修正した方がいいのではないかと感じていますが、この場合むしろ見やすくなっていいですね。そのうち直します。

`-v` オプションにも正規表現を使えるので、最後のコマンドは次のように書いても同じです。

```
greple -n まぐろ sushi.txt -v 'いくら|うに|たまご'
```

## まとめ

複数キーワードの AND, OR, NOT, MUST 指定を単独のオプションで行う方法について紹介しました。`--le` オプションとどちらが適しているかは、好みや状況によって変わってくると思います。

grep 系のコマンドを使う状況では、最初に出た結果が多すぎて、どうやって絞り込んでいくか試行錯誤するようなことがよくあります。この場合、上で紹介した `-v` オプションの使い方は有効です。

オプションを最後にまとめて、こんな風に使うやり方もいいかもしれません。この場合は、パターンが最初の引数ではないのでオプション指定が必要ですが、`--le` の代わりに `-x` を使うこともできます。

```
greple sushi.txt -x 'まぐろ -いくら -いか -サーモン'
```

## SEE ALSO

https://qiita.com/advent-calendar/2021/greple

1. https://qiita.com/kaz-utashiro/items/5b6bcbe54891b3bd9db5
2. https://qiita.com/kaz-utashiro/items/eb8c7067e6de34842fe3
3. https://qiita.com/kaz-utashiro/items/165e744d4250adedc4c1
4. https://qiita.com/kaz-utashiro/items/439e6abcecf36c520703
5. https://qiita.com/kaz-utashiro/items/24ac0b8fdd30b598e069
6. https://qiita.com/kaz-utashiro/items/a1ba4e3d07cf37dc25e3

- https://github.com/kaz-utashiro/greple
- https://metacpan.org/dist/App-Greple
