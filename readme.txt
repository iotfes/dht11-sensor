#----------------------------------------------------------------------
# dht11.rb
# DHT11温湿度センサから温度と湿度を取得し、Cumulocityへアップするスクリプト
# usage: $ sudo ruby dht11.rb
# Last update: 2017/01/25
# author: Sho KANEMARU
#----------------------------------------------------------------------

○前提
- ruby version2.2以上がインストールされていること
-- (例)
 $ ruby -v
 ruby 2.2.4p230 (2015-12-16 revision 53155) [armv7l-linux-eabihf]

○セットアップ方法
- config.ymlに記入
----------------
# デバイスID (Cumulocityが払い出したID)
deviceId: "******"
# CumulocityへのログインID
userId: "******"
# Cumulocityへのログインパスワード
password:  "******"
# GPIOのPIN番号 (例：4)
gpioPin: **
# CumulocityのURL
url: "******"
----------------

- ruby-devパッケージをインストール
$ sudo apt-get install ruby-dev

- DHTセンサのrubyライブラリをインストール
-- bcm2835をインストール (コンパイルが必要)
--- http://www.airspayce.com/mikem/bcm2835/

$ tar zxvf bcm2835-1.xx.tar.gz
$ cd bcm2835-1.xx
$ ./configure
$ make
$ sudo make check
$ sudo make install
$ sudo gem install dht-sensor-ffi

○起動方法
$ sudo ruby dht11.rb
