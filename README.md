# uda-cha/VagrantFiles

## これはなに？

自分用のVagrantfile集です。仮想化プラットフォームはVirtualBoxのみで動作を確認しています。

## 使い方

1. VirtualBoxをインストール
2. Vagrantをインストール
3. 適当なディレクトリにこのリポジトリをダウンロードする(gitから)
```
PS > git clone https://github.com/uda-cha/VagrantFiles.git
```
4. 使いたい仮想マシンのディレクトリに移動して`vagrant up`
```
PS > cd CentOS7
PS > vagrant up
```

## 設定ファイル

だいたい以下の二つのファイルに分離しています。基本的に編集が必要なのは上のファイルだけです。上のファイルには変数だけを書き、下のファイルにはその変数を読み込んで行う処理だったり、そのOS共通の設定だったりを書いています。
- `Vagrantfile`
- `Vagrantfile.common`

### 仮想マシン全体の設定

`Vagrantfile`のハッシュ`@allhosts`直下でハッシュをネストし、仮想マシンを一台ずつ定義します。このネストされたハッシュのキー(`vm1`や`vm2`など)が、仮想化プラットフォーム上から見える仮想マシン名の一部に使われます。例えばVirtualBoxでは`<カレントディレクトリ名>_vm1_<乱数>`などという名前で作成されると思います。

仮想マシン一台だけでいいなら`vm2`をその値ごと丸ごと削除してください。仮想マシンを3台、4台と増やしたいなら、`vm3`、`vm4`と設定をコピって増やしてください。別に`vmX`という名前でなければならないわけではないので、好きな名前に変更しても構いません。

### 各仮想マシンごとの設定

`Vagrantfile`に記載した変数は`Vagrantfile.common`から読み込まれて処理されます。`Vagrantfile.common`で使われているメソッドは以下のVagrant公式に説明があります。
https://www.vagrantup.com/docs/vagrantfile/

以下、分かりにくいところを記載します。

#### `hostname`
仮想マシンのOSに設定されるホスト名です。仮想化プラットフォームに設定される仮想マシン名とは別です。

#### `network_type`

その仮想マシンがどのような形式でネットワークに接続するかを仮想化プラットフォームに設定します。
詳細はVagrant公式を参照してください。
https://www.vagrantup.com/docs/networking/
https://www.vagrantup.com/docs/virtualbox/networking.html

#### `command`

仮想マシン構築後に仮想マシン内で自動的に実行してほしいコマンドを配列で記載します。全てroot権限で実行されます。全てのコマンド実行後、仮想マシンは必ず再起動するよう設定してあります(コマンドを一つも実行しなかった場合も再起動します)。

## おまけ `alpine_30_vms`について

30台の軽量Linuxを立ち上げるVagrantfileです。

