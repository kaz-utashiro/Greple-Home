---
title: "複数キーワード検索 NOT"
weight: 5
id:      24ac0b8fdd30b598e069
---

これまでに、複数キーワードを使った AND と OR の組み合わせを紹介しました。AND、OR　とくれば、当然次は NOT です。

## 実行例

また寿司セットを使って考えてみます。

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

**まぐろ**は必ず食べたくて、**はまち**か**えび**のどちらかが入ったセットは、次のようにして探すことができました。

```
greple -n 'まぐろ はまち|えび' sushi.txt
```

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/8f8ea7ce-3418-c0bf-d1bf-e87a2db26202.png)

でも、実は**いくら**はアレルギーで食べられないことを思い出しました。

```
greple -n 'まぐろ はまち|えび いくら' sushi.txt
```

とすれば、候補の中から**いくら**を含む食べられないセットを表示することができます。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/0d8e93bb-6c50-02cd-551d-6745e96c6d40.png)

でも、本当に探したいのは**いくらを含まない**セットです。そのような場合には、やはり検索エンジンと同じように、キーワードの先頭にマイナス記号 `-` を付けます。

```
greple -n 'まぐろ はまち|えび -いくら' sushi.txt
```

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/0fc07065-b9c7-25ea-feb9-250b6f232e1e.png)

これで、望みの結果を得ることができました。

## grep -v との違い

grep の `-v` オプションは、全体から指定したパターンを含まない行を選び出すためのものです。それに対して、greple の NOT キーワードは、他のキーワードによって選ばれた選択肢から、指定したパターンを含むものを削除するためのものです。ですから NOT キーワードだけのパターンはエラーになります。

grep と同様に動作して欲しければ、どの行にも必ずマッチするパターン、たとえば行頭にマッチする `^` を指定することで実現は可能です。ただ、そのために greple を使う必要性は、あまり感じられません。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/77853d57-05b9-347f-59b4-773b8c2aaa70.png)

## まとめ

今回は、複数キーワードを使った検索について AND と OR に続いて NOT の使い方を紹介しました。使い方は簡単で、検索エンジンと同じように、除外したいパターンの先頭に `-` を付けるだけです。

寿司セットの例は、数が少ないので**目grep**でも望む情報は得られますが、もし数千行の情報から選び出すとすれば、ツールの力を借りた方が得策です。AND、OR、NOT を組み合わせて情報を絞り込んでいくことで、望みの結果に近づくことができます。

## SEE ALSO

https://qiita.com/advent-calendar/2021/greple

1. https://qiita.com/kaz-utashiro/items/5b6bcbe54891b3bd9db5
2. https://qiita.com/kaz-utashiro/items/eb8c7067e6de34842fe3
3. https://qiita.com/kaz-utashiro/items/165e744d4250adedc4c1
3. https://qiita.com/kaz-utashiro/items/439e6abcecf36c520703

- https://github.com/kaz-utashiro/greple
- https://metacpan.org/dist/App-Greple
