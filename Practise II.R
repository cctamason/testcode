library(memisc)
library(plyr)
library(foreign)

setwd("C:/Users/dell-pc/Dropbox/Tutoring/Char")
main<-as.data.set(spss.system.file('main_2ndentry with dates.sav'))

spss2date <- function(x) as.Date(x/86400, origin = "1582-10-14")
main$intdate <- spss2date(main$intdate)

main$uniqueid <- paste(main$hhid, "_", main$intdate, sep="")

HHmem <- as.data.set(spss.system.file('Q11.sav'), stringsAsFactors=FALSE)

# length(unique(HHmem$slno)) # 403
# length(unique(main$slno)) # 402
# HHmem$slno[!(HHmem$slno %in% main$slno)]
# slno = 225 - hhid = 236 pairing is not in main
# slno = 394 - hhid = 236 in both
# HHmem[HHmem$slno==394,]
# main$hhid[main$slno==394]
# main$hhid <- as.numeric(main$hhid)
# main$slno <- as.numeric(main$slno)
# main[,c("slno","hhid")]

HHmem_merge <- merge(HHmem, main[,c("uniqueid", "slno")], by="slno")

# ------------------------------------------------------------------

x1_data <- read.csv2("X-1 Choleraphone distribution 31Jul15.csv")
x1_data <- x1_data[which(!(is.na(x1_data$HHID))),]

x1_data$base_date <- as.Date(x1_data$Date.of.baseline, "%d.%m.%y")
x1_data$with_date <- as.Date(x1_data$Date.of.withdrawl.or.move, "%d.%m.%y")
x1_data$uniqueid <- paste(x1_data$HHID, "_", x1_data$base_date, sep="")

# set current_date to day data was downloaded
current_date <- "2015-08-15"
x1_data$with_date[is.na(x1_data$with_date)] <- current_date
x1_data$interval_check <- NA

# x1_data$uniqueid[!(x1_data$uniqueid %in% main$uniqueid)]

# for (i in 1:10) { do something that involves i}
# i <- j <- 1 

final_x1_data <- data.frame()  

for (i in 1:length(unique(x1_data$HHID))){
  
  subset <- x1_data[which(x1_data$HHID==unique(x1_data$HHID)[i]),]
  subset <- subset[order(subset$base_date),]  
    
  for (j in 1:(nrow(subset)-1)) {
    subset$interval_check[j] <- subset$with_date[j] < subset$base_date[j+1]
  }

  subset$interval_check[j+1] <- TRUE
  final_x1_data <- rbind(final_x1_data, subset)
    
}

# final_x1_data[which(final_x1_data$interval_check==F),]


# ---------------------------------------------------------------------------------

monthly2<-read.csv2("C5_Monthlysurvey2.csv", stringsAsFactors=FALSE)
monthly2$date <- as.Date(paste(monthly2$year, "-", monthly2$month, "-", monthly2$day, sep=""))

# monthly2[,c("hh_id", "date")]

monthly2$uniqueid <- NA
monthly2$uniqueid[which(monthly2$hh_id==monthly2$hh_id[1])] <- 
  
  final_x1_data$uniqueid[which((monthly2$hh_id[1]==final_x1_data$HHID) &   
          (monthly2$date[1] >= final_x1_data$base_date[which(final_x1_data$HHID==monthly2$hh_id[1])] & 
          (monthly2$date[1] <= final_x1_data$with_date[which(final_x1_data$HHID==monthly2$hh_id[1])])))      
]
                    


