---
title: "複数キーワードによる検索"
weight: 3
id: 165e744d4250adedc4c1
---

## パターンオプション

greple には、パターンを指定するために以下のようなオプションがあります。オプション指定がない場合には、最初のコマンド引数がパターンとされ、これは `-le` オプションで指定されたのと同様に扱われます。

         PATTERN
           pattern              'and +must -not ?alternative &function'
           -x, --le   pattern   lexical expression (same as bare pattern)
           -e, --and  pattern   pattern match across line boundary
           -r, --must pattern   pattern cannot be compromised
           -v, --not  pattern   pattern not to be matched
               --or   pattern   alternative pattern group
               --re   pattern   regular expression
               --fe   pattern   fixed expression

### `--le` オプションによる複数キーワード指定

`--le` は lexical expression の略としていて greple の le もここから来ています。単なる文字列ではなくて、意味を持ったトークンの集まりというような意味合いですが、英語として通じるか実はちょっと不安です。とりあえず、ブラウザの検索欄と同じように考えてもらえばいいと思います。

検索エンジンの検索欄に空白で区切って複数の単語を並べると、そのすべての文字列にマッチするページを表示しようとしてくれます。greple の `--le` オプションも同様で、空白で区切られた検索トークンのすべてが含まれる行を表示します。

前回の寿司セットを例にとってみます。

```sushi.txt
サービスセット      熟成まぐろ えび たまご いか サーモン いなり ねぎまぐろ サラダ
お子様セット        熟成まぐろ えび たまご いなり ツナサラダ
特上セット          中とろ 熟成まぐろ 熟成真鯛 はまち 赤えび ほたて うなぎ かに いくら
特上極旨セット      中とろ はまち かに いくら 赤えび サーモン うなぎ うに
うどんセット        熟成まぐろ サーモン たまご えび うどん
サラダ軍艦セット    えびマヨ ツナサラダ サラダ シーフードサラダ
人気セット          熟成まぐろ 漬けまぐろ サーモン びんちょう いか えび えびアボカド たまご
まぐろづくしセット  中とろ 熟成まぐろ ねぎまぐろ
プレミアムセット    中とろ まぐろ サーモン 赤えび はまち うなぎ かに いくら
```

前回は**まぐろ**が入っているセットを検索しましたが、やっぱり**はまち**も食べたいので、**まぐろ**と**はまち**が入っているセットを探します。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/ad06e218-f46b-9a13-b10f-6af4982ec99e.png)

2つのセットがあることがわかります。

**ほたて**も食べたいと探すと、**特上セット**一択になりました。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/153569c0-f869-5950-3f60-e133616639ae.png)

このように、greple のパターンに空白で区切って複数のキーワードを指定すると、その全てを含む行を表示します。

## grep の場合

grep も `-e` オプションを繰り返し使用することで、複数のキーワードを指定することができます。同じように、**まぐろ**と**はまち**を探してみます。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/d383062f-9095-4eab-05f2-2169820f6de3.png)

grep の場合は、複数のパターンを指定すると、そのいずれかが含まれる行を表示します。

では、**まぐろ**と**はまち**の両方が入っているセットを検索するためにはどうするかというと、まず思いつくのはパイプでつなぐことです。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/f74a4749-5e64-365d-2c4e-1782c0b715d6.png)

あるいは、**まぐろ**と**はまち**の両方が含まれるパターンを指定する方法もあります。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/b1fc5af5-9f1d-8293-826e-6a4a0215a238.png)

しかし、これでは**はまち**の方が先に出てきた場合に対応することができません。どちらにも対応しようとするとこうなります。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/81bb2831-0643-d499-87fa-bc6caac187e4.png)

この例では grep ではなく egrep を使っています。grep で同じ結果を得るためには `|` を `\|` に置き換えます。

見てわかるように、**まぐろ**と**はまち**以外の部分もマッチしてしまうので、その部分に色をつけるためには、最後にもう一度 egrep を通します。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/e73e46c0-6ac1-f2c1-7285-c0677e2b06b0.png)

これで grep でも、greple と同じ出力を得ることができました。ただ、これ以上キーワードが増えていくとちょっと大変なので、やはりパイプを使った方がよさそうです。

## 両方を含む行にマッチする正規表現

順序に関係なく**まぐろ**と**はまち**の両方を含む行にマッチさせる正規表現を作ることも可能です。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/b5cff79a-ac4c-fc86-a481-6b6de637218c.png)

正規表現の先読み (look-ahead) の機能を使って、`(?=.*まぐろ)` と `(?=.*はまち)` の両方の条件を満たす行頭 (`^`) を探しています。ripgrep 標準の正規表現は先読みをサポートしていないので `--pcre2` オプションを使っています。

幅のない行頭にしかマッチしていないので、**まぐろ**と**はまち**はカラー出力されません。この `^` はなくても同じ結果になりますが、正規表現エンジンの作りによっては非効率な動作になる可能性があるので、あった方がいいでしょう。

## マルチカラーハイライト

3種類の寿司ネタを探した例で、それぞれのネタが違う色で表示されていたことに気が付いたでしょうか。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/153569c0-f869-5950-3f60-e133616639ae.png)

greple はこのように複数のキーワードが指定された場合、それぞれにマッチする部分を異なる色でハイライトして表示します。色に関するオプションについては、いずれ詳しく説明します。

## まとめ

greple で複数のキーワードを指定して、そのすべてが含まれる行を出力する方法について説明しました。

まとまった文章の執筆や校正をしていると、場所は覚えていないけど、どこかにあったはずの説明を参照したくなることがあります。「TCP の再送とタイムアウトについて、どこに書いてあったっけ」というような状況です。この例であれば  '**TCP** **再送** **タイムアウト**' という3つのキーワードを含む部分を探せばいいわけです。

1行の中にすべてのキーワードが含まれているとは限らないじゃないか、と思われるでしょうか。その通りです。そのような場合についても、いずれ考えてみましょう。

## SEE ALSO

https://qiita.com/advent-calendar/2021/greple

1. https://qiita.com/kaz-utashiro/items/5b6bcbe54891b3bd9db5
2. https://qiita.com/kaz-utashiro/items/eb8c7067e6de34842fe3

- https://github.com/kaz-utashiro/greple
- https://metacpan.org/dist/App-Greple
