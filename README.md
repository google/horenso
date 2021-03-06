# ほー連想：探しやすいコードで漢字直接入力

English is [here](https://github.com/google/horenso/wiki/Horenso-quick-intro)

【ほー連想】は連想式漢字直接入力システムです。私はかな漢字変換入力システムに不満を感じていたから開発しました。

### 漢字直接入力のメリット
1. 字のコードを一旦覚えておくと、そのコードを打つと**必ず同じ漢字が出て来ます。**学習データが失われたり、パソコンを買い替えたり、OSを切り替えたりしても入力ツールの振る舞いが変わりません。
2. 「きしゃ」など、漢字表記が多い読みを入力する場合、**長い候補リストで希望の漢字を探さなくても良いです。**
3. 漢字の入力には、原則として**三打鍵**、平仮名片仮名などに**二打鍵で入れられます。**尚、漢字の三鍵のコードを入れたら、漢字がすぐさま出て来て、確定操作などは要りません。
4. ユーザー辞書の管理は不要です。

### 他の漢字直接入力システムに比べて【ほー連想】の長所
1. JIS x 0213の全漢字に対応する予定で、対応するとしても三打鍵を超える入力コードを必要としません。規格の全漢字を網羅しているので**極わめて特殊な文章（例：漢文）を自然に入力することが出来ます。**
2. 対応漢字が多い為、交ぜ書きや部首合成など**補助入力法を必要としません。**
3. 部首鍵と読み鍵の規則を覚えておくと、漢字コードを調べる時間が激減します。つまり**漢字コードが“発見し易く”工夫されています。**
4. 台湾の常用國字に対応しているので、中国語を入力することもできます。中国語モードで起動すると、同じコードでも日本の新字体の代わりに台湾の字体が出て来ます。CAPSLOCKをオンにすると簡体字を入力することも出来ます。
5. かな入力コードが一般のローマ字かな入力と殆んど変わりません。

入力デモンストレーションがご覧になれます！

* [日本語モード](https://www.youtube.com/watch?v=HyS-QgPbiEw)
* [中国語モード](https://www.youtube.com/watch?v=lubfuBun_zE)

![入力スクリーンショット](https://raw.githubusercontent.com/google/horenso/master/sample.png)

## 起動方法 (Windows)

`hrs`スクリプトはWindowsが未対応ですが、漢直Win用の変換テーブルが用意してあります。**漢直Win+ほー連想**環境を用意するには：

1. [漢直Win](https://github.com/kanchoku/kw/releases)をダウンロードして、zipを展開します。
2. [ほー連想のテーブルファイル](https://github.com/google/horenso/releases)をダウンロードして、漢直Winのダイレクトリーにコピーします。
3. [kanchoku.ini](https://github.com/kanchoku/kw/blob/master/kanchoku.ini)の、`tableFile=t.tbl`という行を`tableFile=hrs.tbl`に書き替えます。
4. `;outputUnicode=1`の`;`を削除する必要があるかもしれません。

これで、漢直Winの使い方と`hrs`の使い方が大体同じですが、漢直Winの場合はCaps Lockの代わりに、`a`を２回打って、カタカナモード・ひらがなモードのトグルができます。

## 起動方法 (Linux, Mac)

`hrs`はターミナルで使える漢字直接入力のための単純なツール

#### 現代日本語モードで使う

    ./hrs

#### 言語（どの標準字体を優先するか）を指定する

    HORENSO_LANG=jpn ./hrs    # 日本語モード（既定）
    HORENSO_LANG=cht ./hrs    # 中国語繁体字モード

#### キーボード配列を指定する

    ./hrs                          # 日本語配列 (既定）
    HORENSO_KB_LAYOUT=enu ./hrs    # US配列

リターンを押す度にテキストをコピーしたりどこかに送信するには`COPY_TOOL`の環境変数を指定します。リターンを押すと、この`COPY_TOOL`が起動され`STDIN`にテキストが書き込まれます。例：Mac OS Xの場合、これを`pbcopy`に設定すると便利です。

    COPY_TOOL=pbcopy ./hrs

`Term/ReadKey.pm`が見付からないと言うようなエラーが出る場合、cpanから
`Term::ReadKey`モジュールをインストールしてください。
（<http://www.cpan.org/modules/INSTALL.html>をご参照ください）

## コードの覚え方：かな

一般のローマ字入力と大して変わりません。
コードは二打鍵：子音+母音になります。
小文字(CAPS off)にすると平仮名、大文字(CAPS on)にすると片仮名になります。

例えば、

    a  -> あ
    ta -> た
    da -> だ
    du -> づ
    zi -> じ
    wa -> わ
    wi -> ゐ
    wo -> を
    vu -> ゔ
    ha -> は
    hi -> ひ

一般のローマ字入力と違うコード

    fu -> ふ　（ｈｕを打つには人差指が苦労するので例外としてｆｕにします）
    q  -> っ　（小さいつ）
    Q  -> ッ
    l  -> ん
    L  -> ン
    ,A -> ヵ　（小さいカ）
    ,E -> ヶ
    k7 -> きゃ
    k8 -> きゅ
    k9 -> きょ

## コードの覚え方：漢字

漢字入力の為の全コードは三打鍵になっています。

**一鍵目は部首を指定します。**

アルファベット小文字か、「`;,./`」のどれかになります。

**二鍵目は発音を指定します。**

発音とは代表的と思われる音読み、国字や音読みがない漢字は訓読みです。使用可能なキーは[`aiueo`]の母音を除けば一鍵目のキーと同じです。

**三鍵目は適当に割り当てられている、使用頻度の高い字ならやや打ち易いキーです。**

二鍵目を打った後は三鍵目の候補が表示されるので、二鍵目を正しく入れたら三鍵目は画面を見るだけで調べられます。

三鍵目はアルファベット大小文字に加えて「`;,./+<>?`」です。ということは三鍵目を打つ際はシフトを使う可能性がありますが、殆んどのシフトコードは漢字の部首変形（氵罒）や異体字旧字（發、亞）などです。

部首のキーを調べるには、下記の表をご参照ください。

    鍵  部首
    ---------------------------------------------------
    b   一 丨 丶 丿 乙 亅  【二画】二 亠 人
    c   儿 入 八 冂 冖 冫 几 凵 刀 力 勹 匕 匚 匸 十 卜
    d   卩 厂 厶 又  【三画】口 ツ
    f   囗 土 士 夂 夊 夕 大 女 子 宀 寸 小 尢
    g   尸 屮 山 巛 工 己 巾 干 幺 广 廴 廾
    h   弋 弓 彐 彡 彳  【四画】心
    j   戈 戶 手 支 攴 文 斗 斤 方 无 日 曰 月
    k   木 欠 止 歹 殳 毋 比 毛 氏 气
    m   水
    n   火 爪 父 爻 爿 片 牙 牛 犬【五画】玄
    p   玉 瓜 瓦 甘 生 用 田 疋 疒
        癶 白 皮 皿 目 矛 矢 石
    r   示 禸 禾 穴 立 竹  【六画】米
    s   糸 缶 网 羊 羽 老 而 耒 耳 聿
    t   肉 臣 自 至 臼 舌 舛 舟 艮 色 艸
    v   虍 虫 血 行 衣
    w   襾  【七画】見 角 言 谷 豆 豕
    x   豸 貝 赤 走 足 身 車
    y   辛 辰 辵 邑 酉 釆 里
    z 【八画】金
    ;   長 門 阜 隶 隹 雨 靑 非【九画】面 革 韋 韭 音
    ,   頁 風 飛 食 首 香【十画】馬 骨 高 髟 鬥
    .   鬯 鬲 鬼 【十一画】魚 鳥 鹵
    /   鹿 麥 麻 黃【十二画以上】黍 黑 黹 黽 鼎 鼓 鼠
        鼻 齊 齒 龍 龜 龠

印刷可能な[部首鍵＋読み鍵 早わかり表](https://goo.gl/VFhoRF)もご利用になってください。

**註：**有名な字典でも部首が互いに喰い違っている漢字があります。例えば、全だと、𠆢と記されている字典があれば、入と記されている字典もあります。こんな時は試行錯誤で部首鍵を当てて見るか、コードファイル（code/**）で検索する必要があります。

上記の表を暗記しないとなかなか上手に入力が出来ないかもしれませんが、使用頻度が高い部首から記憶していきましょう。例えば、《水氺氵》に当たるｍは意外と覚え易くて便利です。続いて《艹艸》に当たるｕを覚えておきましょう。

二鍵目は読み鍵ですが、読み方を考えて、五十音順によって下記の範囲のどれに相当するか調べてください。

    鍵  最初の読み方  例（カナ）   例（漢字）
    ------------------------------------------
    b   ア～          イン　エイ   因　衛
    c   エキ～        エキ　エツ   液　越
    d   カイ～        ガク         学
    f   カン～        カン         観
    g   キ～          キュウ       吸
    h   キヨ～        ギョウ       業
    j   ケ～          ゲン         原
    k   コ～                       呼
    l   コク～        コク　コン   国　今
    m   シ～                       治
    n   シヤ～        シュウ       周
    p   シヨ～                     処
    q   シン～                     新
    r   セキ～                     戚
    s   ソウ～                     藻
    t   タイ～                     体
    v   チヨ～        テイ　ツイ   定　追
    w   テン～        デン　ド     電　度　峠
    x   トク～        ドク         読　独
    y   ハン～        バン　ヒョウ 盤　表
    z   フ～          ベイ         米
    ;   ホ～          ホン　ボク   本　僕
    ,   マ～          ミ　ヤ       味　夜
    .   ラ～          ラン　リョウ 乱　量
    /   ル～          ロウ　ワ     楼　和

印刷可能な[部首鍵＋読み鍵 早わかり表](https://goo.gl/VFhoRF)もご利用になってください。

一鍵目と同じく、曖昧な時は試行錯誤をしましょう。例えば、日の音読みはジツかニチ
のどれかになりますが、ｍとｘの両方を試すのを忘れないでください。（実際のコード
は`jxj`）。

例をもう一つ挙げると「蘇」の読み方はソで、五十音順ではセキより後でソウより前に
配当されるので、二鍵目はｒです。フルコードは`urp`。

### サンプル入力文

入力してみましょう：「カナ漢字変換を行わず日本語が楽々書けます。」

    字　コード　解説
    ----------------
    カ　KA
    ナ　NA
    漢　mf,     部首：氵《ｍ》読み：カン《ｆ》
    字　fme     部首：子《ｆ》読み：ジ《ｍ》
    変　fzf     部首：夂《f》読み：ヘン《ｙ》
    換　jfo     部首：扌《ｊ》読み：カン《ｆ》
    を　wo
    行　vkv     部首：行《ｖ》読み：コウ《ｋ》
    わ　wa
    ず　zu
    日　jxj     部首：日《ｊ》読み：ニチ《ｘ》
    本　k;d     部首：木《ｋ》読み：ホン《；》
    語　wkr     部首：言《ｗ》読み：ゴ《ｋ》
    が　ga
    楽　kdk     部首：木《ｋ》読み：ガク《ｄ》
    々　dwu     部首：口《ｄ》読み：ドウ《ｗ》
                部首と読みは「同」と同じと考えてください
    書　jpf     部首：日《ｊ》読み：ショ《ｐ》
    け　ke
    ま　ma
    す　su
    。　.:      US配列の時は .'

### ファイルの説明

_hrs_

実際に入力を行うツールで、ターミナルで実行できます。Windowsは未対応です。

_stats_

コード割り当て情況を表示するスクリプト。`HORENSO_LANG`の環境変数を設定して実行す
ることができます。

_code/**_

コードデータベース。行ごとに字と相対する入力コードがあります。コードを調べるには、このファイルを検索する方法もあります。未導入のJIS X 0213漢字も含まれていて、入力コードの代りにUCSコードポイントが明記されています。

コードの右記に注があります。Tabで区切られて、英文字で注の種類が記されているので、入力ソフトで処理したり表示させたりすることが出来ると考えています。注の種類は下記の通りです：

    英文字  例      意味
    y       yビ     読み鍵を決めた読み方
    hy      hyミ    この読みは違うキーに相対するけれど、この読みでコードを探し
                    てもおかしくない
    b       b氵     部首鍵を決めた部首
    hb      hb足    部首ではないけど、字の部品の一つで、部首だと思い込んでもお
                    かしくない。例：促の部首は亻だけれど、「足」が右辺にあるの
                    で「hb足」との注が付いている
    yk      yk      読みが分からない人が多い（読み困難）
    ktj     ktj语   簡体字モード（中国語モードでCAPSをオンする場合）で優先する
                    字体
    sjt     sjt寿   日本語モードで優先する字体（sjtは新字体という意味）
    itj     itj澁   その他の異体字や旧字（どのモードでも優先されないけど入力可）
    i       i和咊龢 関連する異体字や旧字（itjと書き替える予定）
    (無)            其の他、コードを編集している人の為のメモ書き

### TODOや問題点

* 今後もコードを調整する可能性がありますが、おおよそ９９％のコードが定着していると考えられます。
* ちゃんとしたＩＭＥや練習アプリはまだ作られていませんが、協力してくださる方がいらっしゃれば有難いです。
* 中国語モードを提供していますが台湾で認められている常用漢字（［次］常用國字標準字體表）の内、おおよそ5600字は未対応です。
