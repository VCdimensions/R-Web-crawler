##爬取台灣證券交易所個股日本益比
rm(list=ls())
gc()

library(RCurl)
library(XML)

#設定連結頁面
url<-"http://www.twse.com.tw/ch/trading/exchange/BWIBBU/BWIBBU_d.php"

#將網頁原始碼載入R
html<-getURL(url, .encoding="big5")

#轉換字碼
html<-iconv(html,'big5','utf8')

#轉換XML函數包要求的爬蟲格式
html<-htmlParse(html,encoding='utf-8',)

#利用Xpath路徑表達式爬取資料
data <- xpathSApply(html,"//div[@id='tbl-containerx']/table/tbody/tr/td[@class='basic2']",xmlValue)

#轉換為矩陣
data<-matrix(data,ncol=5,byrow=T)


