##爬取公開資訊觀測站內部投資人比例
#網站位置http://mops.twse.com.tw/mops/web/stapap1_all
#此資訊在chrome瀏覽器中無法直接看出URL，所以必須開IE來檢視原始檔，且並非使用referer獲得URL，而是用要求URL來獲得

rm(list=ls())
gc()

library(RCurl)
library(XML)


#######參數
Startyear <- 2015 - 1911
Endyear <- 2016 - 1911
Startmonth <- 7
Endmonth <- 12
#######

stkname <- read.csv("台股股票代碼.csv",header=F)
#選出代碼為4個的上市股票的函數
public = function(x){     
  ww = sapply(x,nchar)
  x = x[which(ww==4),]
  return(x)
}
stkname <- public(stkname)
#創建台股近5年內部人投資比例矩陣
INSIDER_DATA <- list()

p <- 1
for(stkno in stkname){
    Sys.sleep(sample(25:35,1))
    y <- matrix(numeric(0),nrow = 3)
  for(year in Startyear:Endyear){
      Sys.sleep(sample(5:15,1))
      w <- matrix(numeric(0),nrow = 3)
      if(year==105){Startmonth=1;Endmonth=6}else{Startmonth=7;Endmonth=12}
    for(month in Startmonth:Endmonth){
      
    #設定連結頁面
    url<- sprintf("http://mops.twse.com.tw/mops/web/ajax_stapap1?co_id=%4s&encodeURIComponent=1&firstin=true&month=%02d&step=0&TYPEK=sii&year=%3d",stkno,month,year)
    
    #本來就是utf-8不需再用iconv轉
    #將網頁原始碼載入R
   
    posibleerror1 <- tryCatch({  html <- getURL(url,.encoding = 'utf-8')}, warning = function(w){w}, error = function(e){ e},finally = {NULL})
    if(inherits(posibleerror1,"error")){print(paste(stkno,"error"));next}
    
    #轉換為XML函數包要求爬蟲格式
    html<-htmlParse(html,encoding='utf-8')
    
    #抓出有用資訊
    insiderData <- xpathApply(html,"//body/center/table[@class='noBorder'][3]//tr[5]",xmlValue)
    insiderData <- strsplit(as.character(insiderData),"\n")
    posibleerror2 <- tryCatch({ insiderData <- insiderData[[1]][c(2,5,8)]}, warning = function(w){w}, error = function(e){ e},finally = {NULL})
    if(inherits(posibleerror2,"error")){print(paste(stkno,"error"));next}
    insiderData <- gsub(",","",insiderData)
    insiderData <- gsub("%","",insiderData)
    insiderData <- gsub(" {2,}","",insiderData)
    insiderData <- as.numeric(insiderData)
    
    w <- cbind(w,insiderData)

    }
      
    y <- cbind(y,w)
      
  }
    
    INSIDER_DATA[[p]] <- y
    print(stkno)
    p = p + 1
    
}


#匯出list到csv
cat(sapply(INSIDER_DATA, toString), file = "insider_ratio.csv", sep="\n")


