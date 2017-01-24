## 1. Register an application with the Github API here 
## https://github.com/settings/applications. Access the API 
## to get information on your instructors repositories 
##(hint: this is the url you want 
## "https://api.github.com/users/jtleek/repos"). 
## Use this data to find the time that the datasharing repo 
##was created. What time was it created?
## This tutorial may be useful 
## (https://github.com/hadley/httr/blob/master/demo/oauth2-github.r). 
## You may also need to run the code in the base R package and not R studio.

library(httr)
oauth_endpoints("github")

## my own app name, key & secret
myapp <- oauth_app("getting_cleaning_data",
          key = "e2e48934bf077c937784",
          secret = "c589017217bd1da6f5607cf1eafc5e97e45394e8")
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
result<-content(req)
for (i in 1:length(result)){
  if (result[[i]]$name=="datasharing"){
    print(result[[i]]$created_at)
  }
}

## 2. The sqldf package allows for execution of SQL commands on R data frames. 
## We will use the sqldf package to practice the queries we might send with 
## the dbSendQuery command in RMySQL.
## Download the American Community Survey data and load it into an R object 
## called "acs"
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv

## Which of the following commands will select only the data for the probability 
## weights pwgtp1 with ages less than 50?

fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl,destfile="data.csv",method="curl")
acs<-read.csv("data.csv")

answer2<-sqldf("select pwgtp1 from acs where AGEP<50")
print(answer2)

## 3.Using the same data frame you created in the previous problem, 
## what is the equivalent function to unique(acs$AGEP)
answer3<-sqldf("select distinct AGEP from acs")
print(answer3)

## 4. How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page:
# http://biostat.jhsph.edu/~jleek/contact.html
# (Hint: the nchar() function in R may be helpful)
con=url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode=readLines(con)
close(con)
print(paste(nchar(htmlCode[10]),nchar(htmlCode[20]),nchar(htmlCode[30]),nchar(htmlCode[100])))

## 5. Read this data set into R and report the sum of the numbers in the fourth of the nine columns.
## https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for
## Original source of the data: http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for
## (Hint this is a fixed width file format)
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
download.file(fileUrl,destfile="data.for",method="curl")
a<-read.fwf("data.for",widths=c(12,7,7,6,7,6,7,6,7),skip=4)
print(sum(sapply(a[4],as.numeric)))
