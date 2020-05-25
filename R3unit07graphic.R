# Unit 7: R2unit07graphic.R
# best R version 3.4.4
#####
rm(list=ls())
###
############################## < 1. basic graphic > #####################
# [1] simple plots --------------------------------------------------- #
if (!require(ggplot2)) {
  install.packages("ggplot2")
  library(ggplot2)
} # ggplot2
str(diamonds)
# histogram
hist(diamonds$carat, main = "Carat Histogram", xlab = "Carat")
hist(diamonds$price, main = "Price Histogram", xlab = "Price")
# 
# scatter plot: y ~ x or (x, y)
plot(price ~ carat, data = diamonds, main="plot: y~x")
plot(diamonds$carat, diamonds$price, main="plot: (x, y)")
plot(diamonds$carat, diamonds$price, xlab="carat", ylab="price")
#
# boxplot
boxplot(diamonds$carat)
boxplot(diamonds$price, xlab="price")
#
boxplot(diamonds$carat, diamonds$depth)
boxplot(diamonds[, c("carat", "depth")])
boxplot(diamonds)
# cf: summary(diamonds) 
# factor attributes: boxplot(diamonds[, c("cut", "color")])
#
# [2] ggplot2 ------------------------------------------- #
# geom_histogram, geom_density, geom_point
ggplot(data = diamonds) + geom_histogram(aes(x = carat))
ggplot(data = diamonds) + geom_density(aes(x = carat), fill = "grey50")
ggplot(diamonds, aes(x = carat, y = price)) + geom_point()
# ggplot(diamonds) + geom_point(aes(x = carat, y = price))
# create a ggplot object for common use by the subsequent layers 
g <- ggplot(diamonds, aes(x = carat, y = price))
g + geom_point(aes(color = color))
#
# create the 2-dimensional layout of panels: facet_wrap vs. facet_grid
g + geom_point(aes(color = color)) + facet_wrap(~ color)
g + geom_point(aes(color = color)) + facet_wrap(cut ~ color)
# g + geom_point(aes(color = color)) + facet_wrap(~ cut + color)
#
g2 <- g + geom_point(aes(color = color))
g2 + facet_grid(~ clarity)
g2 + facet_grid(cut ~ clarity)
g2 + facet_grid(cut ~ clarity + color)
g2 + facet_grid(cut + clarity ~ color)
# geom_histogram + facet_wrap
ggplot(diamonds, aes(x = carat)) + geom_histogram() + facet_wrap(~ color)
ggplot(diamonds, aes(x = carat)) + geom_histogram() + facet_wrap(~ clarity)
# ggplot(diamonds, aes(x = carat)) + geom_histogram(bins=20) + facet_grid(~ clarity)
#
# geom_boxplot
ggplot(diamonds, aes(y = carat, x = 1)) + geom_boxplot()
ggplot(diamonds, aes(y = carat, x = cut)) + geom_boxplot()
# 
# geom_violins:
ggplot(diamonds, aes(y = carat, x = 1)) + geom_violin()
ggplot(diamonds, aes(y = carat, x = cut)) + geom_violin()
ggplot(diamonds, aes(y = carat, x = cut)) + geom_boxplot() + geom_violin()
# ggplot(diamonds, aes(y = carat, x = cut)) + geom_violin() + geom_boxplot()
#
############################## < 2. ggplot2 & lubridate > ###############
# geom_histogram, geom_density, geom_point
View(diamonds)
(g <- ggplot(data = diamonds) + geom_histogram(bins = 30, aes(x = carat)))
g + geom_histogram(breaks = seq(0, 3, by=.1), fill = "green", aes(x = carat)) + xlim(c(0, 3))
g + geom_histogram(bins = 50, color = "blue", fill = "yellow", aes(x = carat))
ggplot(data = diamonds) + geom_histogram(bins = 50, na.rm = TRUE, aes(x = carat)) + xlim(c(0, 3))
#
ggplot(data = diamonds) + geom_density(aes(x = carat), fill = "red")
ggplot(data = diamonds) + geom_density(aes(x = carat), fill = "red", na.rm = TRUE) + xlim(c(0, 3))
#
ggplot(diamonds, aes(x = carat, y = price)) + geom_point()
g <- ggplot(diamonds, aes(x = carat, y = price))
g + geom_point(aes(color = color))
#
# facet_wrap vs. facet_grid
g + geom_point(aes(color = color)) + facet_wrap(~ cut)
g + geom_point(aes(color = color)) + facet_wrap(clarity ~ cut)
g + geom_point(aes(color = color)) + facet_grid(clarity ~ cut)
#
ggplot(diamonds, aes(x = carat)) + geom_histogram(bins = 50, fill = "red") + facet_wrap(~ cut)
# geom_boxplot:
ggplot(diamonds, aes(y = carat, x = 1)) + geom_boxplot(fill = "yellow")
ggplot(diamonds, aes(y = carat, x = cut)) + geom_boxplot(color = "blue", fill = "yellow")
# geom_violins:
ggplot(diamonds, aes(y = carat, x = cut)) + geom_violin(fill = "green")
# ========================================================================== #
#
?economics
str(economics)
head(economics)
ggplot(economics, aes(x = date, y = pop)) + geom_line()
#
if (!require(lubridate)) {
  install.packages("lubridate")
  library(lubridate)
} # lubridate
# Transform date => (year, month)
economics$year <- year(economics$date)
head(month(economics$date), 10)
economics$month <- month(economics$date, label=TRUE)
head(economics, 10)
#
# selection by which
econ2010 <- economics[which(economics$year >= 2010), ]
head(econ2010)
str(econ2010)
typeof(econ2010$year)
#
# divide data into clusters by: group
g <- ggplot(econ2010, aes(x=month, y=pop))
g + geom_line(aes(color=year))  # connect points of the same month
g + geom_line(aes(color=year, group=year))  # connect points of the same year
factor(econ2010$year)
(g1 <- g + geom_line(aes(color=factor(year), group=year)))
g + geom_line(aes(color=factor(year), size=1.2, group=year))
#
# enhance the visualized details
(g2 <- g1 + scale_color_discrete(name="Year"))
(g3 <- g2 + labs(title="Population Growth", x="Month", y="Population"))
#
if (!require(scales)) {
  install.packages("scales")
  library(scales)
} # scales
g4 <- g3 + scale_y_continuous(labels = comma)
g4
#
# several themes are available --------------------------------- #
if (!require(ggthemes)) {
  install.packages("ggthemes")
  require(ggthemes)
} # ggthemes
g2 <- ggplot(diamonds, aes(x=carat, y=price)) +
  geom_point(aes(color=color))
g2
g2 + theme_economist() + scale_colour_economist()
#
g2 + theme_excel() 
g2 + theme_excel() + scale_colour_excel()
#
g2 + theme_tufte()
g2 + theme_wsj()
###