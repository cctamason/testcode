#Creating unique ids for C5 data
setwd("C:\\Users\\zrc340\\Desktop\\Dropbox\\C5 data\\C5 Field Operations data\\Folder Amal")
#file name is updated biweekly
dropoutlist<- read.csv2("X-1 Choleraphone distribution 31Jul15.csv", stringsAsFactors=FALSE)

#set missing values as 0  

dropoutlist[is.na(dropoutlist)]<-0


#check that all replicates have n-1 withdrawal dates
dropoutlist$check<-ifelse(dropoutlist$HHID>0, 
      paste(dropoutlist$HHID,".", dropoutlist$Date.of.withdrawl.or.move, sep =""), 
      dropoutlist$HHID=="NA")
anyDuplicated(dropoutlist$check)

#create unique ID using HHID and dates enrolled
dropoutlist$uniqueID<-ifelse(dropoutlist$HHID>0, 
     paste(dropoutlist$HHID,".", dropoutlist$Date.of.baseline, sep =""), 
     dropoutlist$HHID=="NA")
#check for duplicates
anyDuplicated(dropoutlist$uniqueID)

#create dates variable in a workable format in dropout list
dropoutlist$DateBaseline_new<- as.Date(dropoutlist$Date.of.baseline, "%d.%m.%y")
dropoutlist$DateMoveWithdraw_new<- as.Date(dropoutlist$Date.of.withdrawl.or.move, "%d.%m.%y")

#Create date variables in monthly excel file (separate columns for day month year)?
#must load "creating joint monthly visit file1" first
MonthlyAll$Dateofvisit<-paste(MonthlyAll$day,MonthlyAll$month,MonthlyAll$year)
MonthlyAll$Dateofvisit1<-as.Date(MonthlyAll$Dateofvisit, "%d%m%y")


#Assign monthly visit unique ID, where HHID is the same and date of visit falls between dates of enrollement
#MonthlyAll$uniqueID<-paste(dropoutlist$HHID,".", dropoutlist$Date.of.baseline

##use merge function
merge(MonthlyAll,dropoutlist, by=c("uniqueID"))
#create unique ids for cases where dates fall between enrollment (baseline) and withdrawl
#create unique id for HHIDs that have never been reused


MonthlyAll$uniqueID<-if(MonthlyAll$hh_id==dropoutlist$HHID & 
                          MonthlyAll$date>dropoutlist$DateBaseline_new & 
                          dropoutlist$DateMoveWithdraw_new == 0, dropoutlist$uniqueID)

 if((MonthlyAll$hh_id==dropoutlist$HHID & 
                   MonthlyAll$Dateofvisit1> dropoutlist$DateBaseline_new & 
                     MonthlyAll$Dateofvisit1 < dropoutlist$DateMoveWithdraw_new, 
                   dropoutlist$uniqueID) 
  
