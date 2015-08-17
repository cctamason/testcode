# Author: Matthew Phelps
#Desc: Calculate number of people living in each household at baseline

# Intro -------------------------------------------------------------------

rm(list = ls())
graphics.off()
mac <- "/Users/Matthew/Google Drive/Copenhagen\\Bangladesh - Cholera\\Map Stuff"
pc <- "C:/Users/wrz741/Dropbox/C5 Baseline data/Pre-double entry"
setwd(pc)
rm(mac, pc)

setwd("C:/Users/zrc340/Desktop/Dropbox/C5 data/C5 Baseline data/Pre-double entry")
library(plyr)
library(memisc) # read .spss files

#load question 11
HH_member_info<-as.data.set(spss.system.file('Q11.sav'), stringsAsFactors=FALSE)
HH_member_info47<-as.data.set(spss.system.file('Q11.sav'), stringsAsFactors=FALSE) #correct file name
HH_member_info69<-as.data.set(spss.system.file('Q11.sav'), stringsAsFactors=FALSE) #correct file name

#load baseline main datasets
main<-as.data.set(spss.system.file('main.sav'))
main47<-as.data.set(spss.system.file('main.sav')) #correct file name
main69<-as.data.set(spss.system.file('main.sav')) #correct file name

# make it easier to work with in R. 
# Please change "x" to a variable name that makes sense for you!
#household member info converted to data frame
Q11 <-as.data.frame(HH_member_info) 
Q11_47<-as.data.frame(HH_member_info47) 
Q11_69<-as.data.frame(HH_member_info69) 

baseline1<-as.data.frame(main) 
baseline47<-as.data.frame(main47) 
baseline69<-as.data.frame(main69) 

###CHECKPOINT: make sure ages make sense
summary(Q11$q11_4)
count(Q11$q11_4==999) # one 999, is adult, no need to change
summary(Q11_47$q11_4)
summary(Q11_69$q11_4)

# make dummy variable for each age range so counting will be easier
Q11$child_U5 <- ifelse(Q11$q11_4 < 5, 1, 0)
Q11$child_5_17 <- ifelse(Q11$q11_4 >= 5 & Q11$q11_4 <18, 1, 0)
Q11$adult <- ifelse(Q11$q11_4 > 18, 1, 0)

Q11_47$child_U5 <- ifelse(Q11_47$q11_4 < 5, 1, 0)
Q11_47$child_5_17 <- ifelse(Q11_47$q11_4 >= 5 & Q11$q11_4 <18, 1, 0)
Q11_47$adult <- ifelse(Q11_47$q11_4 > 18, 1, 0)

Q11_69$child_U5 <- ifelse(Q11_69$q11_4 < 5, 1, 0)
Q11_69$child_5_17 <- ifelse(Q11_69$q11_4 >= 5 & Q11$q11_4 <18, 1, 0)
Q11_69$adult <- ifelse(Q11_69$q11_4 > 18, 1, 0)

# For each unique "slno" in df "x", sum the number of adults, children U5 and children 5-17.
# Change "slno" to "hhid" if you wish to count based on HHID.
Q11subset <- ddply(Q11, .(slno),
      summarize,
      adults = sum(adult),
      children_U5 = sum(child_U5),
      children_5_17 = sum(child_5_17))

Q11_47subset <- ddply(Q11_47, .(slno),
                   summarize,
                   adults = sum(adult),
                   children_U5 = sum(child_U5),
                   children_5_17 = sum(child_5_17))

Q11_69subset <- ddply(Q11_69, .(slno),
                   summarize,
                   adults = sum(adult),
                   children_U5 = sum(child_U5),
                   children_5_17 = sum(child_5_17))

#merge age group subset with baseline data
baseline1<- merge(Q11subset,baseline1, by = "slno")
View(baseline$children_U5)
baseline47<- merge(Q11_47subset,baseline47, by = "slno")
baseline69<- merge(Q11_69subset,baseline69, by = "slno")

# Add HHID variable to make our final dataset.
#HH_members <- merge(Q11[,c(1,10)], x2, by = "slno")


# check to make sure summation works as expected. Returns "TRUE" if it works
sum(Q11$child_U5) == sum(baseline1$children_U5)
sum(Q11$child_5_17)== sum(baseline1$children_5_17)
sum(Q11$adult)== sum(baseline1$adults)

sum(Q11_47$child_U5) == sum(baseline47$children_U5)
sum(Q11_47$child_5_17)== sum(baseline47$children_5_17)
sum(Q11_47$adult)== sum(baseline47$adults)

sum(Q11_69$child_U5) == sum(baseline69$children_U5)
sum(Q11_$child_5_17)== sum(baseline69$children_5_17)
sum(Q11$adult)== sum(baseline69$adults)

#create total household members variable
baseline$total_HH_members<-baseline$children_5_17+baseline$children_U5+baseline$adults


