#!/bin/bash

# このコマンドは devbox shell の内部で利用する必要があります

# このコマンドを実行する前に以下を実行しておく必要があります
# devbox add rbenv openssl libyaml zlib

# このコマンドを実行した後に以下のコマンドでrubyのバージョン確認を行えます
# source ~/.bashrc
# ruby -v

# rbenv install -l を実行できるようにするために ruby-buildをインストール
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

# ruby コマンドを利用できるようにするために .bashrc へ追記する
touch ~/.bashrc
echo 'PATH=$PATH:$HOME/bin:/home/devbox/.rbenv/versions/3.2.0/bin' >> ~/.bashrc

# devbox add openssl で追加した openssl を利用して ruby 3.2.0 をインストールをする
RUBY_CONFIGURE_OPTS="--with-openssl-dir=/usr/local/$(devbox info openssl)" rbenv install 3.2.0
