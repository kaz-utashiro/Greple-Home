---
title: "関数インタフェース"
weight: 17
id:      09a5f5cf08ce314e2add
private: false
---

## ランタイム関数

greple には、関数を指定することができるオプションがいくつもあります。プログラムから抜き出してみると、これだけありました。

> `--begin`, `--end`, `--prologue`, `--epilogue`
> `--print`, `--callback`, `--uniqsub`
> `--block`, `--inside`, `--outside`, `--include`, `--exclude`
> `--if`, `--of`, `--pf`
> `--colormap`
> `--le`

ずいぶんとたくさんあります。中には `--inside/outside`、`--include/exclude`、`--block` など、今までに説明してきたものも含まれています。今回は、これらのオプションで使われている関数の定義と利用方法について紹介します。

## 関数の使い方

ここで言う関数とは、Perl のサブルーチンのことです。greple は Perl で実装されていて、モジュールや初期設定ファイルの中に Perl のコードを記述することができます。そこで定義された関数をコマンド行から呼び出すことを可能にするのがこれらのオプションです。

### 関数の定義

関数は一般的に次のような形式で定義します。

```perl
sub hello {
    my %arg = @_;
    my $filename = delete $arg{&FILELABEL};
    say "Hello $filename";
}
```

パラメータがある場合には配列 `@_` に key-value 形式で渡されるので、連想配列 `%arg` に代入すると、ラベルでアクセスできるようになります。`FILELABEL` というラベルは特別で、ファイル名を渡すために使われます。扱うファイルが存在しない場合には、この項目はありません。ファイル名やパラメータを扱う必要がなければ、最初の2行は必要ないので、何もすることはありません。

### 関数の呼び出し

上で定義した関数は、コマンドラインから次のように呼び出すことができます。

    greple --begin hello ...

ただ、関数名を指定するだけです。

パラメータを渡す場合は、次のように `key` あるいは `key=value` の形式で与えます。

    greple --begin 'hello(debug,message=こんにちは,count=2)' ...

括弧が含まれていると、シェルの解釈を防ぐためにクォートしなければならないので、次のような呼び出し形式も可能です。

    greple --begin hello=debug,message=こんにちは,count=2

パラメータに値が指定されていなければ 1 が渡されるので、この場合、関数 `hello` には、

    ( "debug", 1, "message", "こんにちは", "count", "2" )

というリストが渡されます。

## 実行例

ファイルを処理する前に実行する関数を指定するオプション `--begin` を例にとって実際に実行してみます。

上の関数を `~/.greplerc` 内で定義しておくと、次のように使うことができます。最初に `Hello sushi.txt` というメッセージが表示されています。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/4cb19ddc-f8d5-e44c-e10b-61550a268ad4.png)

関数の定義をもう少し複雑にして、渡されたパラメータを使用するようにしてみましょう。

```perl
sub hello {
    my %arg = ( message => "Hello", count => 1, @_ );
    my $filename = delete $arg{&FILELABEL};
    say "debug mode" if $arg{debug};
    say "$arg{message} $filename" for 1 .. $arg{count};
}
```

パラメータを指定して実行すると、次のような結果になります。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/e9b379b7-e80b-0efe-116a-90d5f4dff104.png)

### データへのアクセス

関数が呼ばれる時、ファイルに含まれるデータ全体が、変数 `$_` に保持されています。内容を参照するだけでなく、変数の値を変更すると、その結果に対して処理が行われます。

寿司メニューを処理する`寿司`関数を定義してみます。

```perl
sub 寿司 {
    my %arg = @_;
    my $filename = delete $arg{&FILELABEL};
    if ($arg{逆順}) {
        $_ = join '', reverse /.*\n/g;
    }
    if ($arg{入れ替え}) {
        use List::Util qw(shuffle);
        my $寿司 = qr/(?<= )\S+/;
        my @寿司 = shuffle /$寿司/g;
        s/$寿司/pop @寿司/ge;
    }
}
```

何もしなければこうです。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/d080f19c-7841-1e7e-4aa1-af6c9fde3d46.png)

`--begin 寿司=逆順` を指定するとこのようになります。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/3378dd58-27a0-8d68-5f0f-5e9e7d401cc0.png)

`--begin 寿司=入れ替え` を指定するとこうなりました。うどんセットにうどんが入ってません。困ります。

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/36551/9a31378d-2df7-501d-9ea1-a57d7a3cecf0.png)

## まとめ

`--begin` オプションを例にとって、関数の定義と利用の仕方について紹介しました。このように、利用者やモジュールの開発者が作成した関数をコマンド行から自由に呼び出すことで、様々な機能を柔軟に利用することが可能になります。

このコマンドオプションと関数のインタフェースは、元々 greple を実装するために作られたものですが、その後 `Getopt::EX` という独立したモジュールとして実装されていて、他の Perl スクリプトからも利用することができます。それに含まれる `Getopt::EX::Long` は、広く使われている `Getopt::Long` と互換性があるため、単にモジュール宣言を置き換えるだけで利用可能です。

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

- https://github.com/kaz-utashiro/greple
- https://metacpan.org/dist/App-Greple
