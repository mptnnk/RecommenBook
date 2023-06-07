# RecommenBook（レコメンブック）

### サイトテーマ
本を読んだ経験を共有しよう<br>
気になる本を楽しく探そう<br>
<br>
本を読んだ感想を投稿し、共有できるレビューサイトです。<br>
投稿やジャンルから検索して気になる本を探すことができます。<br>

### テーマを選んだ理由
本を読み終わった後に感想や考察を共有できれば<br>
より一層、読書の経験が楽しくなるのではないか、<br>
または読書に興味がわく方がおられるのではないかと思い、選びました。<br>
<br>
複数の企業様による読書時間に関する実態調査において、<br>
新型コロナウイルスの蔓延前より読書時間が増えた、と回答する方が増えた<br>
という調査結果が確認できました。<br>
<br>
しかし、喜ばしいことではありますが、コロナによる外出自粛がなくなり、<br>
今後は習慣的に読書をする方は減る可能性が高いだろうと思い、<br>
読書を継続するきっかけになるアプリを制作しようと考えました。<br>
<br>
そこで、本は読み終わった直後に感想が共有しづらいことに注目しました。<br>
例えば映画は、誰かと一緒に映画館に行くか、自宅などで同時に鑑賞する場合は<br>
一緒に観た人とすぐに感想を共有でき、二次的な楽しみ方ができますが、<br>
本の場合は、他の誰かと同じタイミングで同じ本を読み終えることは、あまりありません。<br>
<br>
このアプリでは、同じ本を読んだ人と感想を共有したり、<br>
好みが似ている人の読書履歴を見て、読んでみたい本を見つける機会を提供します。<br>
今まであまり読書されていなかった方にも、誰かの感想をチェックしたり、<br>
他ユーザーの「読みたい本」「読んだ本」を参考にすることで、
面白そうな本を簡単に見つけられるようにしたいと考えています。<br>

### ターゲットユーザ
- 年齢　20代〜60代
- 性別　問わない
- 読書が好きな人、感想を共有したい人
- 本を読んでみたいけど興味のある本をどうやって見つけるか迷っている人

### 主な利用シーン
- 読んだ本をおすすめしたい、感想を共有したいとき
- 次に読む本を気になるジャンルなどから探したいとき

## ER図
![RecommenBook_ER図【加筆修正】](https://github.com/mptnnk/RecommenBook/assets/121846198/d0008117-ab2c-4ee9-83d3-f768e1e4e56f)

## 開発環境
- OS：Linux(CentOS)
- mac OS Ventura 13.3.1
- 言語：HTML,CSS,JavaScript,Ruby(3.1.2),SQL
- フレームワーク：Ruby on Rails 6.1.7.3
- JSライブラリ：jQuery
- IDE：Cloud9

## 使用素材
- 外部のAPIを使用させていただきます。<br>
- 楽天ブックス書籍検索API https://webservice.rakuten.co.jp/documentation/books-book-search