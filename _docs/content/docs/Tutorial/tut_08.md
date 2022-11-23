---
title: "検索範囲指定 --inside/--outside"
weight: 8
id:      8783c2fd0cc4315b9a3d
private: false
---
[grepleチュートリアル]: https://qiita.com/advent-calendar/2021/greple
[1日目]: https://qiita.com/kaz-utashiro/items/5b6bcbe54891b3bd9db5
[2日目]: https://qiita.com/kaz-utashiro/items/eb8c7067e6de34842fe3
[3日目]: https://qiita.com/kaz-utashiro/items/165e744d4250adedc4c1
[4日目]: https://qiita.com/kaz-utashiro/items/439e6abcecf36c520703
[5日目]: https://qiita.com/kaz-utashiro/items/24ac0b8fdd30b598e069
[6日目]: https://qiita.com/kaz-utashiro/items/a1ba4e3d07cf37dc25e3
[7日目]: https://qiita.com/kaz-utashiro/items/0c8c944c17a72724b771
[前回]: https://qiita.com/kaz-utashiro/items/0c8c944c17a72724b771

これは[grepleチュートリアル]の8日目です。これまでに、複数キーワードを使って、様々なロジックで対象データから文字列を検索する方法を紹介しました。今回は、検索する対象の範囲を指定する方法について紹介します。

## 検索する場所を選びたい

今まで、寿司セットから好みのネタを探す方法について考えてきました。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/4ce529c9-9cb2-3d10-3b20-57e0315a8987.png)

しかし、一点どうも気に入らない部分があります。おわかりでしょうか。寿司ネタを検索しているのに、「まぐろづくしセット」というセット名がマッチしてしまっている点です。

それくらい別にいいじゃないかというかもしれませんが、**まぐろづくし**だからいいものの、これがもし**まぐろ嫌いセット**だったらどうでしょうか。まぐろ好きは激おこです。

このように、検索対象データの内容は一様ではないのに、一般の検索コマンドはそれを無視して全体を検索対象にしてしまいます。解決するためにはデータベースを使うとか、専用の検索コマンドを用意するなどの必要があります。

## greple による検索範囲指定

greple には、検索範囲を指定する機能があります。まず、寿司セット名範囲を表すパターンを考えてみましょう。セット名部分は `^\S+` という正規表現でマッチすることができます。行頭から始まる空白以外の文字の連続という意味です。まずは、そのパターンを検索してみます。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/a7bed838-89c5-0e2f-fdba-ff712973cbd6.png)

うまく動いているようです。次に、この部分を `--inside` オプションとして指定して、**まぐろ**を検索します。

```sh
greple --inside '^\S+' まぐろ sushi.txt
```

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/3b712043-de61-604d-a28b-b9c9b89b32a7.png)

意図した通りに、セット名に含まれる**まぐろ**だけが検索されました。

でも、求めているのは**セット名に含まれないまぐろ**です。ですから、今度は `--inside`　ではなくて `--outside` オプションとして指定します。

```sh
greple -n --outside '^\S+' まぐろ sushi.txt
```

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/7cd85a9d-a6c6-6846-db6a-1c071454e811.png)

これで、セット名以外の範囲にある**まぐろ**だけがハイライトされるようになりました。もちろん、セット名以外の部分に**まぐろ**が含まれなければ、その行は表示されません。

## 繰り返し指定

`--inside` と `--outside` は、繰り返し指定することができます。その場合、それぞれの範囲の和集合が検索対象範囲となります。

`--inside` と `--outside` で同じ範囲を指定するとどうなるかというと、ある領域とその補集合の和になるので、当然全体になります。

```sh
greple --inside '^\S+' --outside '^\S+' まぐろ sushi.txt
```
![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/0c5f7d2e-4f73-0227-a406-aa32f828e433.png)

このように、何も指定しないのと同じ部分がマッチしていますが、寿司セット名とそれ以外の部分で色が変わっています。greple は、複数の検索範囲が指定され、検索ワードが1つしかなかった場合、検索範囲毎にハイライトカラーを変えて表示します。

## まとめ

`--inside` と `--outside` オプションにパターンを指定することで、指定した領域の内側、あるいは外側だけに検索対象を限定する方法について紹介しました。

指定するパターンは、いくらでも複雑化することができます。たとえば、次のようにすれば、C のソースコードのコメント部分のみを対象にして検索することができます。`/*` で始まって `*/` で終わる最小範囲を指定しています。

```sh
greple --inside '(?s)/\*.*?\*/' pattern ...
```

次の例は、メールの Subject 行と本文のみを対象にして検索しています。今回のチュートリアルの中では正規表現そのものについて詳しく説明はしません。ちょっとトリッキーな表現になっているので、どうして動作するのか考えてみてください。

```sh
greple --inside '\A(.+\n)*\KSubject:.+' --outside '\A(?s:.*?)\n\n'
```

## SEE ALSO

https://qiita.com/advent-calendar/2021/greple

1. https://qiita.com/kaz-utashiro/items/5b6bcbe54891b3bd9db5
2. https://qiita.com/kaz-utashiro/items/eb8c7067e6de34842fe3
3. https://qiita.com/kaz-utashiro/items/165e744d4250adedc4c1
4. https://qiita.com/kaz-utashiro/items/439e6abcecf36c520703
5. https://qiita.com/kaz-utashiro/items/24ac0b8fdd30b598e069
6. https://qiita.com/kaz-utashiro/items/a1ba4e3d07cf37dc25e3
7. https://qiita.com/kaz-utashiro/items/0c8c944c17a72724b771

- https://github.com/kaz-utashiro/greple
- https://metacpan.org/dist/App-Greple
