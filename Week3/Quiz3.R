## 1. The American Community Survey distributes downloadable data about United States communities. 
## Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
## and load the data into R. The code book, describing the variable names is here:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
## Create a logical vector that identifies the households on greater than 10 acres who sold more than $10,000 
## worth of agriculture products. Assign that logical vector to the variable agricultureLogical. 
## Apply the which() function like this to identify the rows of the data frame where the logical vector is TRUE.
## which(agricultureLogical)
## What are the first 3 values that result?

fileUrl="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl,destfile="data.csv",method="curl")
data<-read.csv("data.csv")
agricultureLogical<-data$ACR==3 & data$AGS==6

head(which(agricultureLogical==TRUE),3)

## 2. Using the jpeg package read in the following picture of your instructor into R
## https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg
## Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data? 
## (some Linux systems may produce an answer 638 different for the 30th quantile)

library(jpeg)
fileUrl="https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(fileUrl,destfile="data.jpg",method="curl")
image<-readJPEG("data.jpg",native=TRUE)

print(quantile(image,probs=c(0.3,0.8)))

## 3.Load the Gross Domestic Product data for the 190 ranked countries in this data set:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
## Load the educational data from this data set:
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
## Match the data based on the country shortcode. How many of the IDs match? Sort the data frame 
##in descending order by GDP rank (so United States is last). What is the 13th country in the resulting data frame?
## Original data sources:
## http://data.worldbank.org/data-catalog/GDP-ranking-table
## http://data.worldbank.org/data-catalog/ed-stats

fileUrl1="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
fileUrl2="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileUrl1,destfile="data1.csv",method="curl")
download.file(fileUrl2,destfile="data2.csv",method="curl")

all_content=readLines("data1.csv")
real<-all_content[6:195]
data1=read.csv(textConnection(real),header=FALSE)

library(plyr)
data1<-rename(data1,c("V1"="C_Code","V2"="Rank","V4"="C_name","V5"="GPD"))
data1<-subset(data1,select=c(1,2,4,5))

data2<-read.csv("data2.csv")

mergedData=merge(data1,data2,by.x="C_Code",by.y="CountryCode")
new<-arrange(mergedData,desc(Rank))

print(length(mergedData[,"C_Code"]))

print(new[[13,"C_name"]])


## 4. What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?

s=split(mergedData$Rank,mergedData$Income.Group)
print(lapply(s,mean)[2])
print(lapply(s,mean)[3])


## 5. Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. How many countries
## are Lower middle income but among the 38 nations with highest GDP?

library(Hmisc)
mergedData$group=cut2(mergedData$Rank,g=5)
sub=filter(mergedData,mergedData$Income.Group=="Lower middle income")
result=filter(sub,sub$group==levels(sub$group)[1])
print(length(result[,"Rank"]))