# Unit 6: R2unit06transformSAC.R
#####
rm(list=ls())
###
############################## < 1. read & save > #####################
theURL <- "http://www.jaredlander.com/data/TomatoFirst.csv"
theFile <- "R2unit06TomatoFirst.csv"
download.file(url = theURL, destfile = theFile)
#
# read.table -------------------------------------------------------- #
tomato <- read.table(file = theFile, header = TRUE, sep = ",")
head(tomato)
str(tomato)
tomato$Source
#
# character vector <=> factor
tomato2 <- read.table (file = theFile, header = TRUE, sep = ",", stringsAsFactors = FALSE)
str(tomato2)
tomato2$Source
#
# save objects as a binary file ------------------------------------- #
?save.image
save(tomato, tomato2, file = "tomato.rdata")
rm(tomato, tomato2)
# Error! the object does not exist: head(tomato)
#
load("tomato.rdata")
head(tomato)
#
unlink("tomato.rdata") # clean it up
saveRDS(tomato, file = "tomato.rds")
# save unnamed objects: ?saveRDS
tomatoCopy <- readRDS("tomato.rds")
edit(tomatoCopy)
#
unlink("tomato.rds")
#
# read unstructured text files -------------------------------------- #
aVector <- readLines("R2unit06codeSample.cpp")
# Warning: aVector <- readLines("R3unit06codeSample.cpp",encoding="BIG5")
str(aVector)
writeLines(aVector, "copy.cpp")
( fname <- dir(pattern = "^[c]") )
#
unlink(fname)
#
# variable name --> character string
( fname <- deparse(substitute(aVector)) )
saveRDS(aVector, file = paste0(fname,".rds"))
saveRDS(aVector, file = paste0(fname,".txt"), ascii = TRUE)
# compare file sizes: binary vs. text
file.info( dir(pattern = "^[aV]") )["size"]
#
unlink( dir(pattern = "^[aV]") )
#
############################## < 2. sort & aggregate > ################
x <- c(1,1,3:1,1:4,3)
y <- c(9,9:1)
z <- c(2,1:9)
( raw.data <- rbind(x, y, z) )
colnames(raw.data) <- LETTERS[1:10]
str(raw.data)
# 3x10 matrix: class(raw.data)
# order OR sort.list ------------------------------------------------ #
x
order(x)
# indices of elements to form an ordered list
# a guide to sort the others
x[order(x)]
( sortbyX <- raw.data[, order(x)] )
( sortbyY <- raw.data[, order(y)] )
#
# sorted by two: ties of 1st argument are broken by 2nd argument
order(x,y)
raw.data[c("x","y"),][,order(x,y)]
( sortbyXY <- raw.data[, order(x,y)] )
( sortbyXZ <- raw.data[, order(x,z)] )
# sortbyX
( sortbyXYZ <- raw.data[, order(x,y,z)] )
( sortbyXZY <- raw.data[, order(x,z,y)] )
# sortbyXZ
#
# sorted in decreasing order ---------------------------------------- #
( sortbyZ <- raw.data[, order(z)] )
( sortby_Z <- raw.data[, order(z, decreasing=T)] )
( sortby_X_Y <- raw.data[, order(x,y, decreasing=T)] )
#
( sortby_Z2 <- raw.data[, order(-z)] )
( sortby_X_Y2 <- raw.data[, order(-x,-y)] )
( sortbyX_Y <- raw.data[, order(x,-y)] )
#
identical(sortby_Z, sortby_Z2)
all(sortby_X_Y == sortby_X_Y2)
#
# Follow an ordering from outside
obey <- c(5:1,10,7:9,6)
raw.data[, order(obey)]
# hybird ordering
raw.data[, order(x, obey)]
raw.data[, order(obey, x)]
## rearrange another vector in order
( x <- c(5:1, 6:8, 10:9) )
( y <- (x + 1)^2 )
( o <- order(x) )
y[o]
rbind(x[o], y[o])
#
# setting of na.last ------------------------------------------------- #
a <- c(4, 4, 4, NA, 1)
b <- c(4, NA, 2, 7, 1)
( z <- cbind(a, b) )
# default: na.last = TRUE
( o <- order(a, b) ); z[o, ]
( o <- order(a, b, na.last = FALSE) ); z[o, ]
( o <- order(a, b, na.last = NA) ); z[o, ]
#
# =====================< practice by yourself >========================
# Practice by yourself
# (1) Use sort.list for another data set.
# (2) Compare different sorting methods used by sort.list.
# ?sort.list
# ms <- c("shell","quick","radix")
# for (m in ms) { print(m); print( system.time( sort.list(10^8:1, na.last = NA, method = m)) ) }
# =================================================================== #
#
if (!require(ggplot2)) {
  install.packages("ggplot2")
  library(ggplot2)
} # ggplot2::diamonds
data(diamonds)
head(diamonds)
?diamonds
str(diamonds)
#
if (!require(stats)) {
  install.packages("stats")
  library(stats)
} # stats::aggregate
#
# group by + aggregate function ---------------------------------- #
# formula: aggegate column(s) ~ group-by columns
# data: dataset
# FUN: aggregate function
View(diamonds)
aggregate(formula = price ~ cut, data = diamonds, FUN = mean)
aggregate(price ~ cut + color, diamonds, mean)
# group by multiple attributes to aggregate other attributes
# SQL query: SELECT cut, color, AVG(price)
#            FROM diamonds
#            GROUP BY cut, color
aggregate(cbind(price, carat) ~ cut, diamonds, mean)
# group by for aggregate multiple attributes
# SQL query: SELECT cut, AVG(price), AVG(carat)
#            FROM diamonds
#            GROUP BY cut
aggregate(cbind(p.avg = price, c.avg = carat) ~ cut + color, diamonds, mean)
aggregate(cbind(count = price) ~ cut + color, diamonds, function(x){ NROW(x) })
# identical(nrow(diamonds), NROW(diamonds))
# identical(nrow(1:5), NROW(1:5))
#
# =====================< practice by yourself >========================
# Practice by yourself
# (1) Apply group-by and aggregate functions to a dataset
# e.g., tomato
# (2) Try the package: plyr
# =================================================================== #
if (!require(plyr)) {
  install.packages("plyr")
  library(plyr)
} # plyr::ddply, llply, dlply, ldply
#
############################## < 3. SAC & Munging > #####################
# Split-Apply-Combine
aggregate(formula = price ~ cut, data = diamonds, FUN = mean)
# SQL query: SELECT cut, AVG(price)
#            FROM diamonds
#            GROUP BY cut
# learning SQL:
browseURL("https://www.w3schools.com/sql/sql_groupby.asp")
#
aggregate(cbind(p.avg = price) ~ cut + color, diamonds, mean)
# multiple attributes to group by & rename
# SQL query: SELECT cut, color, AVG(price) as average.price
#            FROM diamonds
#            GROUP BY cut, color
aggregate(cbind(price, carat) ~ cut, diamonds, mean)
# multiple attributes to aggregate
# SQL query: SELECT cut, ________, ________ <== fill the blanks by yourself
#            FROM diamonds
#            GROUP BY cut
aggregate(cbind(p.avg = price, c.avg = carat) ~ cut + color, diamonds, mean)
# SQL query: SELECT cut, color, ________, ________ <== fill the blanks by yourself
#            FROM diamonds
#            GROUP BY cut, color
#
# what is the semantic of '+': group by --> + --> mean
aggregate(price + carat ~ cut, diamonds, mean)
aggregate(price + 1000 ~ cut + color, diamonds, mean)
# SQL query: SELECT cut, color, AVG(price) + 1000
#            FROM diamonds
#            GROUP BY cut, color
#
# count the number of rows & the number of unique rows ------------- #
aggregate(cbind(count = price) ~ cut, diamonds, FUN = function(x){ NROW(x) })
# SQL query: SELECT cut, COUNT(price) as count
#            FROM diamonds
#            GROUP BY cut
aggregate(cbind(count = price) ~ cut, diamonds, FUN = function(x){ NROW(unique(x)) })
# SQL query: SELECT cut, COUNT(distinct price) as count
#            FROM diamonds
#            GROUP BY cut
#
# apply each of the aggregate functions
if (!require(plyr)) {
  install.packages("plyr")
  library(plyr)
} # plyr::each
aggregate(cbind(price, carat) ~ cut, diamonds, each(mean, median))
# apply multiple aggregate functions to multiple attributes
# SQL query: SELECT cut, AVG(price), MEDIAN(price), AVG(carat), MEDIAN(carat)
#            FROM diamonds
#            GROUP BY cut
combF <- each(min,median,max)
combF(sample(100, replace=T))
aggregate(cbind(price, carat) ~ cut, diamonds, combF)
#
# =====================< practice by yourself >========================
# Which is its semantic?
# Query1: a multiple of three averages OR
# Query2: the average of xyz products
aggregate(cbind(volume = x*y*z) ~ cut, diamonds, mean)
# Query1: SELECT AVG(x)*AVG(y)*AVG(z) as volume
#         FROM diamonds
#         GROUP BY cut
# Query2: SELECT AVG(x*y*z) as volume
#         FROM diamonds
#         GROUP BY cut
# Hint:
group_fair <- subset(diamonds, cut == "Fair")[, c("x","y","z")]
head(group_fair)
( method1 <- prod(colMeans(group_fair)) )
( method2 <- mean(apply(group_fair,1,prod)) )
# xyzBYcut <- aggregate(cbind(x,y,z) ~ cut, diamonds, mean)
# bbb <- data.frame(xyzBYcut$cut,volume = apply(xyzBYcut[,2:4],1,prod))
# which method? bbb[bbb$xyzBYcut.cut == "Fair",]$volume
# =================================================================== #
############################## < 4. Split-Apply-Combine: plyr > ##########
# Apply the same functions to the dataset "tomato"
#
theURL <- "http://www.jaredlander.com/data/TomatoFirst.csv"
theFile <- "R2unit06TomatoFirst.csv"
download.file(url = theURL, destfile = theFile)
tomato <- read.table(file = theFile, header = TRUE, sep = ",")
View(tomato)
# multiply the columns of each row and then take the average
( ans <- aggregate(formula=cbind(multiple=Sweet*Acid*Color)~Source,data=tomato,FUN=mean) )
( ccc <- aggregate(cbind(counts=Sweet*Acid*Color)~Source,tomato,function(x) NROW(x)) )
# remember: function(x) NROW(unique(x))
#
( sname <- ccc[which.max(ccc$counts), ]$Source )
( tgroup <- tomato[which(tomato$Source==sname), c("Sweet","Acid","Color")] )
# Query1: a multiple of three averages OR
# Query2: the average of xyz products
method1 <- NULL # <== replace with your codes
method2 <- NULL # <== replace with your codes
# prod(colMeans(tgroup))
# mean(apply(tgroup,1,prod))
#
c(method1, method2) == ans[which(ans$Source==sname), ]$multiple
# How to get all the answers of each method?
query1 <- NULL # <== replace with your codes
# bySource <- aggregate(cbind(Sweet,Acid,Color) ~ Source, tomato, mean)
# data.frame(bySource$Source,volume = apply(bySource[,2:4],1,prod))
query2 <- ans
#####
# plyr ------------------------------------------------------------ #
if (!require(plyr)) {
  install.packages("plyr")
  library(plyr)
} # plyr
View(baseball)
head(baseball)
?baseball
browseURL("http://blog.ilc.edu.tw/blog/index.php?op=printView&articleId=31804&blogId=198")
# ab: number of times at bat
# h: hits, times reached base because of a batted, fair ball without error by the defense
# bb: base on balls (walk)
# hbp: hits by pitch
# sf: sacrifice flies
#
# data cleaning: NA removal
# baseball$sf[baseball$year < 1954] <- 0
any(is.na(baseball$sf))
# baseball$hbp[is.na(baseball$hbp)] <- 0
any(is.na(baseball$hbp))
# at least 50 time at bat
baseball50 <- baseball[baseball$ab >= 50, ]
head(baseball50)
#
# OBP: On Base Percentage = (h + bb + hbp) / (ab + bb + hbp + sf)
baseball50$OBP <- with(baseball50, (h + bb + hbp)/(ab + bb + hbp + sf))
# the same as, but better than:
# (baseball50$h + baseball50$bb + baseball50$hbp)/(baseball50$ab + baseball50$bb + baseball50$hbp + baseball50$sf)
tail(baseball50)
# learning SQL:
browseURL("https://oracle-base.com/articles/misc/with-clause")
# WITH baeball50 AS (
#      SELECT *, (h+bb+hbp)/(ab+bb+hbp+sf) AS OBP
#      FROM   baseball
#      WHERE  ab >= 50
# Query 1:
( bbb <- aggregate(cbind(volume=x*y*z)~cut,aggregate(cbind(x,y,z)~cut,diamonds,mean),mean) )
( ddd <- with(aggregate(cbind(x,y,z)~cut,diamonds,mean),x*y*z) )
# all(bbb$volume == ddd)
#####
# (1) ddply ------------------------------------------------------- #
# Split data frame, apply function, and return results in a data frame
# calculate Career OBP in function: return the column as a result
getCOBP <- function(data) {
  # data <- subset(baseball50,id==baseball50[1,]$id)
  c(COBP = with(data, sum(h + bb + hbp)/sum(ab + bb + hbp + sf)))
} # getCOBP
careerOBP <- ddply(baseball50, .variables = "id", .fun = getCOBP)
head(careerOBP)
# ?ddply
# cf: average OBP by year vs. career OBP
YOBP <- aggregate(cbind(YOBP=OBP)~id,baseball50,mean)
head(YOBP)
#
careerOBP_ <- careerOBP[order(careerOBP$COBP, decreasing = TRUE), ]
head(careerOBP_, 10)
head(YOBP[order(YOBP$YOBP,decreasing=T),],10)
sum(careerOBP$COBP > YOBP$YOBP) / dim(careerOBP)[1]
# Does it make sense?
#####
# (2) llply == lapply  --------------------------------------------- #
# Split list, apply function, and return results in a list.
( theList <- list(A = matrix(1:8, 4), B = 1:5, C = matrix(1:4, 2), D = 5) )
( ansA <- lapply(theList, sum) )
class(ansA)
#
( ansB <- llply(theList, sum) )
identical(ansA, ansB)
#
# (3) laply vs. {llply, lapply}  ----------------------------------- #
# Split list, apply function, and return results in an array
( ansC <- laply(theList, sum) )
class(ansC)
identical(ansC, ansA)
#
# (4) dlply ---------------------------------------------- #
# Split data frame, apply function, and return results in a list
ansD <- dlply(baseball50, "id", nrow)
str(ansD)
head(ansD)
class(baseball50)
class(ansD)
# reversed: ldply
(ansE <- ldply(theList,sum) )
###