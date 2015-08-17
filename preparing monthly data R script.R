setwd("C:/Users/zrc340/Desktop/Dropbox/C5 data/C5 Monthly Visits data")
Round1<-read.csv("C5_monthly_survey_v3_results.csv")
Round1_5<-read.csv("C5_monthly_survey_v4_results.csv")
Round2<-read.csv("C5_monthly_survey_v5_results 23-1-15.csv")
library(xlsx)
#exporting data for editing columns (see phd, c5, analysis)
write.xlsx(Round2, "C:/Users/zrc340/Desktop/Dropbox/C5 data/C5 Monthly Visits data/C5_Monthlysurvey2.xlsx")

#loading new data sets
setwd("C:/Users/zrc340/Desktop/Dropbox/C5 data/C5 Monthly Visits data/Columns fixed")
Round1<-read.csv2("C5_Monthlysurvey1_fixed_columns.csv")
Round1_5<-read.csv2("C5_Monthlysurvey1_5_fixed_columns.csv")
Round2<-read.csv2("C5_Monthlysurvey2_fixed_columns.csv")

#merging data sets #more work needed
total <- rbind(Round1, Round1_5, Round2)
