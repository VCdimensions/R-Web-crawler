##爬取公開資訊觀測站營收資料

rm(list=ls())
gc()

library(RCurl)
library(XML)

#參數
year <- 2015
month <- 3
stkno<- 3008

year_roc <- 2015-1911
yyymm <- year_roc*100+month
month_string <- substr(as.character(yyymm),4,5)



#設定連結頁面
url<- paste("http://mops.twse.com.tw/mops/web/t05st10_ifrs?encodeURIComponent=1&run=Y&step=0&yearmonth=",yyymm,
            "&TYPEK=sii&co_id=",stkno,"&off=1&year=",year_roc,"&month=",month_string,"&firstin=true",sep = "")

#本來就是utf-8不需再用iconv轉
#將網頁原始碼載入R
html <- getURL(url,.encoding = 'utf-8')

#轉換為XML函數包要求的爬蟲格式
html <- htmlParse(html,encoding="utf-8")

#載入營收資訊科目標題
#刪掉tbody改/才不會null
revenue_data_title <- xpathApply(html,"//table[@class='hasBorder']//tr/th",xmlValue)
revenue_data_title <- revenue_data_title[3:length(revenue_data_title)]

#載入營收科目數據
revenue_data_number <- xpathApply(html,"//table[@class='hasBorder']//tr/td",xmlValue)

#合併資料
revenue_data_data <- cbind(revenue_data_title,revenue_data_number)
  
  
  