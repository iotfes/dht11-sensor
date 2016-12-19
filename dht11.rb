# coding: utf-8
#----------------------------------------------------------------------
# dht11.rb
# DHT11温湿度センサから温度と湿度を取得し、Cumulocityへアップするスクリプト
# usage: $ sudo ruby dht11.rb
# Last update: 2016/12/19
# author: Sho KANEMARU
#----------------------------------------------------------------------
$LOAD_PATH.push('.')
require 'json'
require 'net/http'
require 'uri'
require 'base64'
require 'dht-sensor-ffi'
#require 'addressable/uri'

#------------ 設定ファイル読み込み ------------
confFileName = "./config.yml"
config = YAML.load_file(confFileName)

# デバイスID (Cumulocityが払い出したID)
DEVICEID = config["deviceId"]
# CumulocityへのログインID
USERID = config["userId"]
# Cumulocityへのログインパスワード
PASSWD = config["password"]
# GPIOのPIN番号
GPIO_PIN = config["gpioPin"]
# CumulocityのURL
URL = config["url"] + "/measurement/measurements/"

#------------ 温湿度データをセンサから取得  ------------
day = Time.now
time = day.strftime("%Y-%m-%dT%H:%M:%S.000+09:00")
puts time

val = DhtSensor.read(GPIO_PIN, 11) # pin=4, sensor type=DHT-22/DHT-11
#puts val.temp               # => 21.899999618530273 (temp in C)
#puts val.temp_f             # => 71.4199993133545 (temp in F)
#puts val.humidity

#------------ 温湿度データをJSONに整形  ------------
data_temperature = {
  :DHT11_TemperatureMeasurement => {
    :T => {
      :value => val.temp,
      :unit => "C"
    }
  },
  :time => time,
  :source => {
    :id => DEVICEID
  },
  :type => "DHT11_Measurement"
}

data_humidity = {
  :DHT11_HumidityMeasurement => {
    :T => {
      :value => val.humidity,
      :unit => "%"
    }
  },
  :time => time,
  :source => {
    :id => DEVICEID
  },
  :type => "DHT11_Measurement"
}

puts "temp: #{val.temp}, humid: #{val.humidity}"

# URLからURIをパース
uri = URI.parse(URL)
#uri = Addressable::URI.parse(URL)

https = Net::HTTP.new(uri.host, uri.port)
https.set_debug_output $stderr
#https.use_ssl = false # HTTPSは使用しない
https.use_ssl = true # HTTPSを使用する

# httpリクエストヘッダの追加
initheader = {
  'Content-Type' =>'application/vnd.com.nsn.cumulocity.measurement+json; charset=UTF-8; ver=0.9',
  'Accept'=>'application/vnd.com.nsn.cumulocity.measurement+json; charset=UTF-8; ver=0.9',
  'Authorization'=>'Basic ' + Base64.encode64("#{USERID}:#{PASSWD}")
}

# httpリクエストの生成、送信(温度)
request = Net::HTTP::Post.new(uri.request_uri, initheader)
payload = JSON.pretty_generate(data_temperature)
request.body = payload
puts "hoge 3"
p request
response = https.request(request)
#response = Net::HTTP.new(uri.host, uri.port).start {|https| https.request(request) }

# 返却の中身を見てみる
puts "------------------------"
puts "code -> #{response.code}"
puts "msg -> #{response.message}"
puts "body -> #{response.body}"

# httpリクエストの生成、送信(湿度)
request = Net::HTTP::Post.new(uri.request_uri, initheader)
payload = JSON.pretty_generate(data_humidity)
request.body = payload
response = https.request(request)
 
# 返却の中身を見てみる
puts "------------------------"
puts "code -> #{response.code}"
puts "msg -> #{response.message}"
puts "body -> #{response.body}"


