## 1. The American Community Survey distributes downloadable data about United States communities. 
## Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
## and load the data into R. The code book, describing the variable names is here:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
## How many properties are worth $1,000,000 or more?

fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl,destfile="data.csv",method="curl")
data<-read.csv("data.csv")

print(length(which(data$VAL==24)))

## 3. Download the Excel spreadsheet on Natural Gas Aquisition Program here:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx
## Read rows 18-23 and columns 7-15 into R and assign the result to a variable called "dat"
## What is the value of sum(dat$Zip*dat$Ext,na.rm=T)?

fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileUrl,destfile="data.xlsx",method="curl")
library(xlsx)
colIndex<-7:15
rowIndex<-18:23
dat<-read.xlsx("data.xlsx",sheetIndex=1,colIndex=colIndex,rowIndex=rowIndex)

print(sum(dat$Zip*dat$Ext,na.rm=T))

## 4. Read the XML data on Baltimore restaurants from here:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml
## How many restaurants have zipcode 21231?

fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
library(XML)
doc <- xmlTreeParse(sub("s", "", fileUrl), useInternal = TRUE)
#doc<-xmlTreeParse(fileUrl,useInternal=TRUE)
rootNode<-xmlRoot(doc)
print(length(which(xpathSApply(rootNode,"//zipcode",xmlValue)=="21231")))

## 5.The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv
## using the fread() command load the data into an R object "DT"
## The following are ways to calculate the average value of the variable
## "pwgtp15"" broken down by sex. Using the data.table package, 
## which will deliver the fastest user time?

library(data.table)
DT <- fread("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv")

## 1
print(system.time(DT[,mean(pwgtp15),by=SEX]))
## 2
print(system.time(sapply(split(DT$pwgtp15,DT$SEX),mean)))

## 3
print(system.time(tapply(DT$pwgtp15,DT$SEX,mean)))

## 4
print(system.time(mean(DT[DT$SEX==1,]$pwgtp15)))
print(system.time(mean(DT[DT$SEX==2,]$pwgtp15)))
