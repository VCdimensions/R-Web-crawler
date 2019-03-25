###############################
year = seq(1990,2015,1)
month = seq(1,12,1)

data = data.frame()

for(i in year){
  for(j in month){
da = read.csv(sprintf("http://www.twse.com.tw/ch/trading/exchange/FMTQIK/FMTQIK2.php?STK_NO=&myear=%4d&mmon=%02d&type=csv",i,j),skip = 1,header = T,col.names = c("date","tradeOfnum","tradeOfamt","trade","TWII","updown"),colClasses = c("character","character","character","character","character","numeric"))                             
da$tradeOfnum = gsub(",","",da$tradeOfnum)
da$tradeOfamt = gsub(",","",da$tradeOfamt)
da$trade = gsub (",","",da$trade)
da$TWII = gsub(",","",da$TWII)
da = da[,c(1:5)]
data = rbind(data,da)
  }
}


data = data[-grep("»¡©ú*",data$date),]
data$date = paste0(as.numeric(substr(data$date,1,regexpr("/",data$date)-1)) +1911,substr(data$date,regexpr("/",data$date)+1,regexpr("/",data$date)+2))
data$tradeOfnum = as.numeric(data$tradeOfnum)
data$tradeOfamt = as.numeric(data$tradeOfamt)
data$trade = as.numeric(data$trade)
data$TWII = as.numeric(data$TWII)



