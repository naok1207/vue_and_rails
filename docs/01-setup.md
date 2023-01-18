# セットアップ

## devbox 関連
### devbox のインストール
```sh
curl -fsSL https://get.jetpack.io/devbox | bash
```

### devbox のセットアップ
```sh
devbox init
```

### nodejs のインストール
```sh
devbox add nodejs
```

### devcontainer で起動
```
devbox generate devcontainer
```
vscodeで`Reopen in Container`を選択し、devcontainerで起動

※ dockerを事前に起動する必要がある
メリット: ローカル環境のライブラリを不意に利用してしまうことを防ぐことができる

### ここまでの参考
https://dev.classmethod.jp/articles/devbox-node-development/

## vue 関連
### yarn をインストール
vscodeで新たなシェルを開いて行う
```
devbox add yarn
```

追加したライブラリを現在起動中のshellに反映する
```
hash -r
```

※ devcontainerの中でそのまま `devbox add` を使用することができます

### viteでvueのテンプレートを作成
```
npm init vite@latest
```

### vue を起動
```
yarn install
yarn dev
```

## rails 関連
### ruby 3.2.0 のインストール準備
#### 準備 1
```
devbox add rbenv openssl libyaml zlib
```

```
devbox shell
```

#### 準備 2
`rbenv install -l`を利用できるようにする
```
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
```

#### 準備 3
opensslのバージョンを確認する
```
devbox info openssl
```

#### 準備 4
rubyのバージョン確認用のコマンドを定義する
```
touch ~/.bashrc
echo 'PATH=$PATH:$HOME/bin:/home/devbox/.rbenv/versions/3.2.0/bin' >> ~/.bashrc
```

一度shellを立ち上げ直す
```
exit
devbox shell
```

### ruby 3.2.0 をインストール
opensslのバージョンは準備の際に確認したものを指定する
```
RUBY_CONFIGURE_OPTS="--with-openssl-dir=/usr/local/openssl-3.0.7" rbenv install 3.2.0
```
1 line command
```
RUBY_CONFIGURE_OPTS="--with-openssl-dir=/usr/local/$(devbox info openssl)" rbenv install 3.2.0
```

確認
```
ruby -v
```

### postgresql をインストール
```
devbox add postgresql
devbox shell
```
```
initdb
devbox services start
```

### rails インストール
```
gem install rails
```

```
bundle install
bundle config set path 'vendor/bundle'
```

`esbuild` の場合
```
rails new server -d=postgresql --css=tailwind --skip-jbuilder -M -T -j esbuild --skip-bundle
```

`vite`の場合
```
rails new server -d=postgresql --skip-jbuilder -M -T --skip-bundle
```

`tzinfo-data`のエラーが発生するので以下のように`Gemfile`を修正
```diff Gemfile:server/Gemfile
+ gem "tzinfo-data"
- gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
```

コマンドで修正
```
sed -i 's/gem "tzinfo-data", platforms: %i\[ mingw mswin x64_mingw jruby \]/gem "tzinfo-data"/g' server/Gemfile
```

**追加コマンド**
```
cd server
bundle install
bundle binstubs bundler
```

**rails作成をまとめたスクリプト**
bin/setup-rails.sh

### esbuildのセットアップ + typescriptの導入
未検証
docs/02-typescript-esbuild.md

### videのセットアップ + typescriptの導入
検証済み
docs/03-typescript-vite.md
