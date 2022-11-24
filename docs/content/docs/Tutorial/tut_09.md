---
title: "検索範囲指定 --include/--exclude"
weight: 9
id:      84f5a6be6bf996076c64
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
[8日目]: https://qiita.com/kaz-utashiro/items/8783c2fd0cc4315b9a3d
[前回]: https://qiita.com/kaz-utashiro/items/8783c2fd0cc4315b9a3d

これは[grepleチュートリアル]の9日目です。[前回]は `--inside` と `--outside` オプションを使って、検索する対象の範囲を指定する方法について紹介しました。今回は、その続きで `--include` と `--exclude` オプションについて紹介します。

## 例外条件を指定したい

`--inside` と `--outside` は、全体の中から、どこを検索対象にするかという観点で使いました。それに対して `--include` と `--exclude` は、どこを検索対象から外すかという観点で使います。

`--outside` オプションを使って、寿司ネタ領域から**まぐろ**を検索しています。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/7cd85a9d-a6c6-6846-db6a-1c071454e811.png)

でも、まぐろは好物だけど、ヅケはあまり好きではなくて、ネギも勘弁して欲しいなあということで、**漬けまぐろ**と**ねぎまぐろ**を除外したいと思いました。

この場合 `--exclude` オプションに除外したい文字列を与えることで、それに対するマッチを抑制することができます。

```sh
greple -n --outside '^\S+' まぐろ sushi.txt --exclude 漬けまぐろ --exclude ねぎまぐろ
```

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/05c5d572-68dd-8bbb-cfdf-419c32404f14.png)

ヅケとネギはハイライトされなくなりました。でも、選択肢は変わりませんでした。

文字列には正規表現を使用することができるので `--exclude '(漬け|ねぎ)まぐろ'` と書くこともできます。加えて、お子様セットも年齢制限があるので除外しましょう。この場合は単なる文字列ではなく、「お子様セット」ではじまる行全体を指定したいので `^お子様セット.*` と指定します。

`sh
greple -n --outside '^\S+' まぐろ sushi.txt --exclude '(漬け|ねぎ)まぐろ' --exclude '^お子様セット.*'
`
![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/ae1d7430-d2f9-2562-3d29-5cf2be99fb07.png)

お子様セットは候補に出てこなくなりました。

## --inside/--outside と --include/--exclude の使い分け

流れとしては `--inside/--outside` で検索対象範囲を拾い出して、`--include/--exclude` で絞り込むという使い方になります。

上の例で、`--exclude` の代わりに `--outside` を使うことはできません。前回書いたように `--inside` と `--outside` で指定した範囲は和集合として扱われるので、結果として全体に戻ってしまいます。

この例では、`--outside` を一度しか使っていないので、そこを `--exclude` にしても結果は変わりません。単独で使う場合は、どちらを使っても同じ結果になります。

## まとめ

前回の `--inside/outside` に加えて `--include/exclude` オプションについて紹介しました。

TeX や roff など、マークアップを使った文書ファイルを校正しようとする場合、マークアップ命令やコメント部分は対象から外して、純粋に文章の部分だけを処理する必要があります。

また、原稿の中には自分で書いた文章以外に、引用文であったり、別の文書や書籍のタイトル、固有名詞など、ローカルなルールを適用すべきではない部分もあります。それらを例外として処理対象から外すことができないと実用的なツールとはなりません。greple の機能は、そのような経験から進化してきました。

greple のオプションは、なるべく grep に合わせるようにしているのですが、`--include` と `--excude` については、まったく違う意味になるので注意してください。

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

- https://github.com/kaz-utashiro/greple
- https://metacpan.org/dist/App-Greple
