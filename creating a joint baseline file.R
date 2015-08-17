#cleaning baseline
wd<-"C:\\Users\\zrc340\\Desktop\\Dropbox\\C5 data"
setwd(paste("wd","wdmain",sep="")
wdmain <- "\\C5 Baseline data\\Pre-double entry"
wd47<-"\\C5 Baseline data\\Double-entered data\\set 3 received 13-7-15\\wateruse47_spss\\1stEntry"

setwd(paste(base_working_dir, working_dir, sep=""))

setwd("C:\\Users\\zrc340\\Desktop\\Dropbox\\C5 data\\C5 Baseline data\\Double-entered data")
library(memisc)
library(plyr)


#load baseline main datasets

##How to see which columns are the same/what is missing from the different datasets?##

#will need to change file names and locations once double entry is finished
setwd("C:\\Users\\zrc340\\Desktop\\Dropbox\\C5 data\\C5 Baseline data\\Pre-double entry")
main<-as.data.set(spss.system.file('main_2ndentry with dates.sav'),stringsAsFactors=FALSE)
setwd("C:\\Users\\zrc340\\Desktop\\Dropbox\\C5 data\\C5 Baseline data\\Double-entered data\\set 3 received 13-7-15\\wateruse47_spss\\1stEntry")
main47<-as.data.set(spss.system.file('1stEntry47_main.sav'),stringsAsFactors=FALSE) 
setwd("C:\\Users\\zrc340\\Desktop\\Dropbox\\C5 data\\C5 Baseline data\\Pre-double entry\\round 2, 69 observations")
main69<-as.data.set(spss.system.file('main_1stEntry.sav'),stringsAsFactors=FALSE) 

#convert to dataframes
main<-as.data.frame(main)
main47<-as.data.frame(main47)
main69<-as.data.frame(main69)

##create readable dates
setwd("C:\\Users\\zrc340\\Desktop\\Dropbox\\C5 data\\C5 Baseline data")

spss2date <- function(x) as.Date(x/86400, origin = "1582-10-14")

main$intdate <- spss2date(main$intdate)
main47$intdate <- spss2date(main47$intdate)
main69$intdate <- spss2date(main69$intdate)#no dates entered yet, waiting for data entry


#create unique id in main baseline files
main$uniqueID<-paste(main$hhid,".",main$intdate)
View(main$uniqueID)
main47$uniqueID<-paste(main47$hhid,".",main47$intdate)
main69$uniqueID<-paste(main69$hhid,".",main69$intdate)

setwd("C:/Users/zrc340/Desktop/Dropbox/C5 data/C5 Baseline data/Pre-double entry")

#number of people per household
#load question 11
HH_member<-as.data.set(spss.system.file('Q11.sav'), stringsAsFactors=FALSE)
HH_member47<-as.data.set(spss.system.file('Q11.sav'), stringsAsFactors=FALSE) #correct file name
HH_member69<-as.data.set(spss.system.file('Q11.sav'), stringsAsFactors=FALSE) #correct file name



# make it easier to work with in R. 
#household member info converted to data frame
Q11 <-as.data.frame(HH_member) 
Q11_47<-as.data.frame(HH_member47) 
Q11_69<-as.data.frame(HH_member69) 

#add unique id onto q11
mainUID<-main[c("uniqueID","slno")]
Q11<-merge(Q11, mainUID, by="slno", incomparables = NA)
mainUID47<-main47[c("uniqueID","hhid")]
mainUID69<-main69[c("uniqueID","hhid")]

mainUID47<-main47[c("uniqueID","hhid")]
Q11_47<-merge(Q11_47, mainUID47, by="hhid", incomparables = NA)

mainUID69<-main69[c("uniqueID","hhid")]
Q11_69<-merge(Q11_69, mainUID69, by="hhid", incomparables = NA)

#combine all Q11s
Q11_all<-cbind(Q11,Q11_47,Q11_69)

###CHECKPOINT: make sure ages make sense
summary(Q11_all$q11_4)
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
sum(Q11_69$child_5_17)== sum(baseline69$children_5_17)
sum(Q11_69$adult)== sum(baseline69$adults)


  #create water use data set with separate spss file
#Will need to change directories and file names once data is double entered
setwd("C:\\Users\\zrc340\\Desktop\\Dropbox\\C5 data\\C5 Baseline data")
water_use1<-as.data.set(spss.system.file('q13_18.sav'), stringsAsFactors=FALSE)
setwd("C:\\Users\\zrc340\\Desktop\\Dropbox\\C5 data\\C5 Baseline data\\Double-entered data\\set 3 received 13-7-15\\wateruse47_spss\\1stEntry")
water_use47<-as.data.set(spss.system.file('1stEntry47_Q13_18.sav'), stringsAsFactors=FALSE)
setwd("C:\\Users\\zrc340\\Desktop\\Dropbox\\C5 data\\C5 Baseline data\\Pre-double entry\\round 2, 69 observations")
water_use69<-as.data.set(spss.system.file('q13_18_1stEntry.sav'), stringsAsFactors=FALSE) 

#set water use files as dataframes
water_use1<-data.frame(water_use1)
water_use47<-data.frame(water_use47)
water_use69<-data.frame(water_use69)

#add unique id onto water use
mainUID<-main[c("uniqueID","slno")]
water_use1<-merge(water_use1, mainUID, by="slno", incomparables = NA)

water_use47<-merge(water_use47, mainUID47, by="hhid", incomparables = NA)
water_use69<-merge(water_use69, mainUID69, by="hhid", incomparables = NA)

#create water user group code

#go into spss files and search for "showar" in 14_oth. Change corresponding q14 to 888
View(water_use1)
#erase rows 304 and 305
water_use1=water_use1[-305,]
water_use1=water_use1[-304,]

#all 777 answers to q14 are now ground tank (with bucket)

#combine all water use data sets
water_useAll<-cbind(water_use1,water_use47,water_use69)

#####now can do coding for wateruse all instead of each water use data set

#----------------------------------------------------------------------------
#use with()  for the following so i don't have to repeat datafram names$
#recode q14 so that 1 = pipe/tap, 2= hand pump, 3= well with bucket
as.numeric(water_use1$q14)
water_use1$q14_recoded<- ifelse(water_use1$q14==1,1, ifelse(water_use1$q14==2,1, ifelse(water_use1$q14==3,2,                       
                               ifelse(water_use1$q14==4,2, ifelse(water_use1$q14==5,3, 
                               ifelse(water_use1$q14==777,3, ifelse(water_use1$q14==888, NA, 0)))))))

water_use47$q14_recoded<- ifelse(water_use47$q14==1,1, ifelse(water_use47$q14==2,1, ifelse(water_use47$q14==3,2,                       
                                ifelse(water_use47$q14==4,2, ifelse(water_use47$q14==5,3, 
                                ifelse(water_use47$q14==777,3, ifelse(water_use47$q14==888, NA, 0)))))))

water_use69$q14_recoded<- ifelse(water_use69$q14==1,1, ifelse(water_use69$q14==2,1, ifelse(water_use69$q14==3,2,                       
                               ifelse(water_use69$q14==4,2, ifelse(water_use69$q14==5,3,        
                               ifelse(water_use69$q14==777,3, ifelse(water_use69$q14==888, NA, 0)))))))

#recode 14a WASA=1; deep tube well/submersible =2,3 <-2 ; well/shallow tube well = 4,5; there are 2 777s w/o specification in dataset (both taps with tanks)
water_use1$q14a_recoded<- ifelse(water_use1$q14a==1,1, ifelse(water_use1$q14a==2,2,                       
                                ifelse(water_use1$q14a==3,2, ifelse(water_use1$q14a==4,3, 
                                ifelse(water_use1$q14a==5,3, ifelse(water_use1$q14a==777, NA, 0))))))

#How to rewrite so that I don't have to always repeat the dataframe name? #following doesn't work
water_use47$q14a_recoded<- within(water_use47,ifelse(q14a==1,1, ifelse(q14a==2,2,                       
                             ifelse(q14a==3,2, ifelse(q14a==4,3, 
                              ifelse(q14a==5,3, ifelse(q14a==777, NA, 0)))))))

#recode q15 is there a tank? 1=yes, 0=no
water_use1$q15_recoded<-ifelse(water_use1$q15>=1,1,0)

#is a bucket needed to withdraw water? 1=yes, 0=no
water_use1$use_bucket<-ifelse(water_use1$q15==5|water_use1$q14a==777|water_use1$q14a==4,1,0)

#combine baseline and water_use
#Create new subset for primary water source
source1_1<-ddply(water_use1, .(slno),
                 summarize,
                 use_bucket=sum(use_bucket),
                 have_tank=sum(q15_recoded),
                 point_of_access=sum(q14_recoded),
                 sourcewater=sum(q14a_recoded))
                 
source1_47                 
  

View(source1_1)
source1_2

baseline1_w_water_use <- merge(water_use1, baseline1, by="slno") #this needs to be redone, slno works for file 1, 

#second set (47) has no slno; however, second set does not have repeated HHIDs, so it can be merged by hhids
baseline2_w_water_use merge(water_use2, baseline2, by="hhid")


# if desired storage capacity need to do for baseline data sets 1 and 2
#water_storage<-as.data.set(spss.system.file('Q24_Q30.sav'))
#ddply(water_storage, c("q26"),
      summarise,
      count = sum(q26[hhid==hhid]))
#create calculation for total storage capacity (volume*number of containers); this may have been done already in a separate file
#if needed q19_drinkwater<-as.data.set(spss.system.file('q19.sav'))
#ddply(q19_drinkwater,c("hhid"),
      summarise,
      count = length(hhid[q19==19.1 & q19_1==1]))

#add column for number of household members, need to do for baseline data sets 1 and 2
q11_HH_mem<-as.data.set(spss.system.file('Q11.sav'))
#count duplicates



#combine data sets to baseline
baseline<-rbind.data.frame(baseline1, baseline47, baseline69)

#create total household members variable
baseline$total_HH_members<-baseline$children_5_17+baseline$children_U5+baseline$adults


#first create new columns so all columns are the same to rbind
#following were changed in SAV files
#baseline1$q67_5_6<-NA
#baseline1$q67_4_12<-NA
#baseline1$q67_4_13<-NA
#baseline1$q67_4_14<-NA
#baseline1$q67_4_15<-NA
#baseline1$q67_3_9<-NA
#baseline1$q67_3_10<-NA
#baseline1$q50_a_north<-NA
#baseline1$q50_a_east<-NA
#baseline1$q55_oth<-NA

#baseline2$listing<-NA
#baseline2$slno<-NA
#baseline2$q49_5<-NA
#baseline2$q49_6<-NA







#variables to include
#Q6 rooms in house
#Q9_1 electricity
#Q10 by whome is the house occupied, 1=nuclear family, 2=multiple families, 
         #3=unrelated persons, 4= nuclear family with one or more related persons, 777=other
#12 income, use other R file for income calculation

#see "R script for wealth quintiles and water use by quintiles"

