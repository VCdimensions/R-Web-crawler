##爬取台灣證券交易所個股每日成交資訊

rm(list = ls())
gc()

library(RCurl)
library(XML)

#設定爬取股票代碼
stkno<-2030

#設定年月
year<-2015
month <- 4
yyyymm<-year*100+month
month_srting <- substr(as.character(yyyymm),5,6)

#設定連結頁面
url<-paste("http://www.twse.com.tw/ch/trading/exchange/STOCK_DAY/genpage/Report",yyyymm,"/",yyyymm,"_F3_1_8_",stkno,".php?STK_NO=",stkno,"&myear=",
  year,"&mmon=",month_srting,sep="")
#將網頁原始碼載入R
html<-getURL(url,.encoding = 'big5')

#轉換字碼
html<-iconv(html,'big5','utf-8')

#轉換為XML函數包要求爬蟲格式
html<-htmlParse(html,encoding='utf-8')

#利用Xpath路徑表達式爬蟲資料
data<-xpathSApply(html,"//tr[@class='basic2']/td",xmlValue)

#轉為矩陣
data<-matrix(data,ncol=9,byrow=T)


