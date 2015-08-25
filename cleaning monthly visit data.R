#Cleaning monthly visit data
setwd("C:/Users/zrc340/Desktop/Dropbox/C5 data/C5 Monthly Visits data")
Mar15_2015<-read.csv("C5_monthly_survey_v5_results_feb6tomar15_2015 downloaded apr17.csv")
write.csv2(Mar15_2015, file="C5_monthly_survey_v5_results_feb6tomar15_2015 downloaded apr17 2.csv")
