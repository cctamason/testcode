## Run "creating a joint baseline file" first

setwd("C:/Users/zrc340/Desktop/Dropbox/C5 data/C5 Baseline data")
library(memisc)
library(plyr)
#quintiles

main2<-as.data.set(spss.system.file('main2.sav'))

baseline$q12d[is.na(baseline$q12d)]<-0


baseline$Monthly_income<- baseline$q12 + baseline$q12a2 - baseline$q12a1 + 
  (baseline$q12a3/12)-(baseline$q12a4/12)- baseline$q12d

baseline$monthly_income_percapita<-baseline$Monthly_income/()

View(baseline$Monthly_income)

#shared facilities (water q17, kitchen q31, latrines q35) 0=all shared, 1=2of3 shared, 2= 1of3 shared
baseline<- within(baseline, shared_facilities<- ifelse(q17==1& q31 >=1 & q35==1, 0, 
                                                       ifelse(q17==0& q31 >=1 & q35==1, 1,
                                                       ifelse(q17==1& q31 >=1 & q35==0, 1,
                                                       ifelse(q17==1& q31 ==0 & q35==1, 1,
                                                       ifelse(q17==0& q31 >=1 & q35==0, 2,
                                                       ifelse(q17==0& q31 ==0 & q35==1, 2,
                                                       ifelse(q17==1& q31 ==0 & q35==0, 2,))

#create column with income quintiles, note: probs=0:5/5 is same as c(.2,.4,.6,.8,1)
baseline$income_quintile<-as.integer(cut(baseline$Monthly_income, quantile(baseline$Monthly_income, 
                                                                           probs=0:5/5, include.lowest=TRUE)))
  
#asset calculation
baseline$asset_score<- (as.numeric(baseline$q9_1) + as.numeric(baseline$q9_2) + as.numeric(baseline$q9_3) +
                          as.numeric(baseline$q9_5) + as.numeric(baseline$q9_7) + as.numeric(baseline$q9_8) +
                          as.numeric(baseline$q9_9) + as.numeric(baseline$q9_15) + as.numeric(baseline$q9_16) +
                          as.numeric(baseline$q9_18)+ ((as.numeric(baseline$q9_6) + as.numeric(baseline$q9_10) +
                          (as.numeric(baseline$q9_11) + as.numeric(baseline$q9_12))*2) + 
                          ((as.numeric(baseline$q9_13) + as.numeric(baseline$q9_19))*3)
                          +baseline$shared_facilities
)

View(baseline$asset_score)

#create column with asset quintiles, note: probs=0:5/5 is same as c(.2,.4,.6,.8,1)
baseline$asset_quintile<-as.integer(cut(baseline$asset_score, quantile(baseline$asset_score, 
                                                                       probs=0:5/5, include.lowest=TRUE)))
table(baseline$asset_quintile)

#create quintile variable called income_quintile within baseline
baseline <- within(baseline, income_quintile <- as.integer(cut(Monthly_income, 
                    quantile(Monthly_income, probs=0:5/5), include.lowest=TRUE)))




#water source by quintile
ddply(main_w_water_use, c("q14a"),
      summarise,
      count = length(q14a[q13==1 & quintile==1]), length(q14a[q13==1 & quintile==2]),length(q14a[q13==1 & quintile==3]),
      length(q14a[q13==1 & quintile==4]),
      length(q14a[q13==1 & quintile==5]))



