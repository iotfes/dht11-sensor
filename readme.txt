#----------------------------------------------------------------------
# dht11.rb
# DHT11温湿度センサから温度と湿度を取得し、Cumulocityへアップするスクリプト
# usage: $ sudo ruby dht11.rb
# Last update: 2016/12/19
# author: Sho KANEMARU
#----------------------------------------------------------------------

○DHTセンサのrubyライブラリを仕様するには、下記が必要。
- bcm2835をインストール (コンパイルが必要)
-- http://www.airspayce.com/mikem/bcm2835/

$ tar zxvf bcm2835-1.xx.tar.gz
$ cd bcm2835-1.xx
$ ./configure
$ make
$ sudo make check
$ sudo make install

$ sudo gem install dht-sensor-ffi
