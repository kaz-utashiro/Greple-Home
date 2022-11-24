---
title: "複数キーワード検索 MUST"
weight: 6
id:      a1ba4e3d07cf37dc25e3
private: false
---

これまでに、複数キーワードを使った検索について AND、OR、NOT と紹介してきました。

今回は、ちょっと変わった MUST について紹介します。

## 注目したいキーワード

前回は、以下のような寿司セットの中から、**まぐろ**と**はまち**か**えび**を含んでいて、**いくら**が入っていないものを探すという例を考えました。

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

そして、条件を満たすものは、次のようにして得られました。

```
greple -n 'まぐろ はまち|えび -いくら' sushi.txt
```

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/0fc07065-b9c7-25ea-feb9-250b6f232e1e.png)

しかし、どのセットに**いくら**が入っていたかにも興味がないでしょうか。**いくら**以外はいい内容だったら、誰かと交換してもいいかもしれません。もちろん `-いくら` の指定を外せばいいのですが、そうするとどこに**いくら**があるのかを自分の目で探さなければなりません。

このように「なければならない」「あってはいけない」だけではなく、「注目したい」ワードを指定したいことがあります。このような時に使えるのが MUST キーワードです。

## `+` による MUST 指定

これもまた検索エンジンと同様に、キーワードの先頭にプラス記号 `+` を付けることで実現します。実際、検索エンジンに複数のキーワードを与えた時に、すべてのキーワードが含まれてはいない結果が表示されることがあります。その時に、絶対にあってほしいキーワードに対して `+` をつけて検索します。

先の例であれば、このように使います。

```
greple -n '+まぐろ +はまち|えび いくら' sushi.txt
```

MUST キーワードがあると、記号なしのキーワードはオプショナルに格下げされます。つまり、**いくら**はあってもなくても構わないが、あれば色付きで表示されます。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/5f0956f0-0fd6-6136-9b10-e7b418ae44c5.png)

これも、ハイライトカラーが複数あることの効果が感じられる例です。試しに、単色での表示にしてみると、こんな風になります。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/73a2f209-559c-5578-2af2-39f7fdaab239.png)


## まとめ

今回は MUST キーワードについて説明しましたが、それによって新たに導入されるのは「オプショナルキーワード」であると言うこともできます。

最後に、以前の記事で紹介した実際の使用例を載せておきます。これは compromise という単語がどういう日本語に翻訳されているかを調べた時のものです。compromise のみを必須として、候補となる訳語を着色して表示しています。いずれ、詳しく説明できるかもしれません。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/9813b14d-aed6-381b-aead-49593ee36f55.png)

## SEE ALSO

https://qiita.com/advent-calendar/2021/greple

1. https://qiita.com/kaz-utashiro/items/5b6bcbe54891b3bd9db5
2. https://qiita.com/kaz-utashiro/items/eb8c7067e6de34842fe3
3. https://qiita.com/kaz-utashiro/items/165e744d4250adedc4c1
3. https://qiita.com/kaz-utashiro/items/439e6abcecf36c520703
5. https://qiita.com/kaz-utashiro/items/24ac0b8fdd30b598e069

- https://github.com/kaz-utashiro/greple
- https://metacpan.org/dist/App-Greple
