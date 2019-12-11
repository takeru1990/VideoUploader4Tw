#!/bin/bash
# Nintendo Playthrough のダイジェストを Twitter に載せるスクリプト
# [FILE PATH] と [FILE NAME] を引数に取る
 
# 動画をアップロード．成功するまで繰り返す
until log=`sh PATH_TO_KOTORIOTOKO/tweet.sh -f $1 $2`;do sleep 1;done
 
# "=" で区切って4番目を取り出す
# log にはこんなのが入ってる想定:
# mid=1192595741362905093 at=2019/11/08 11:17:28 id=1192596963826339840
id=`echo $log | cut -d = -f4`
 
# make twimgurl.txt if not exit
touch ~/Downloads/np1m.txt
 
# make GET param
twName="YOUR TWITTER SCREEN NAME"
prefix="https://publish.twitter.com/oembed?url=https://twitter.com/"$twName"/status/"
param=$prefix$id
 
# 埋め込みコードのHTML部だけを取得
# jq で要素 "html" を取得
# recode でHTMLエンティティを変換
# sed で \ を削除
xml=`GET $param | jq ".html" | recode html | sed 's:\\\\::g'`
 
# 動画のURLを取得してファイルに書き込む
# parsrx でXMLを解析
echo $xml | parsrx | grep -m1 href | cut -d " " -f 2 >>~/Downloads/np1m.txt
 
exit 0
