library(ggplot2)
  
## Loading and preprocessing the data
#unzip("activity.zip")
#my_data <- read.csv("activity.csv")


## What is mean total number of steps taken per day?
stepbyday <- aggregate(my_data$steps, list(my_data$date), sum)
names(stepbyday) <- c("day", "steps")

meanbyday <- mean(stepbyday$steps, na.rm=TRUE)
print(meanbyday)
medianbyday <- median(stepbyday$steps, na.rm=TRUE)
print(medianbyday)

## What is the average daily activity pattern?
stepbyinterval <- aggregate(my_data$steps, list(my_data$interval), mean, na.rm=TRUE)
names(stepbyinterval) <- c("interval", "meansteps")

for (i in 1:length(stepbyinterval$interval))
{
  value <- stepbyinterval$interval[i]
  stepbyinterval$interval2[i] <- paste(unlist(c(rep("0", 4 - nchar(as.character(value))), value)), collapse="")
  stepbyinterval$interval2[i]  <- as.POSIXct(stepbyinterval$interval2[i], format="%H%M",  origin = "1970-01-01")
}

plot(as.POSIXct(stepbyinterval$interval2, origin="01/01/1970"), stepbyinterval$meansteps, type="l", xlab="Hour", ylab="Average step number in interval")



## Imputing missing values
my_data2 <- my_data

sum(is.na(my_data2$steps))

naposition <- which(is.na(my_data2$steps))
for (i in naposition) {
  my_data2$steps[i] <- stepbyinterval$meansteps[match(my_data2$interval[i], stepbyinterval$interval)]

  }

sum(is.na(my_data2$steps))

stepbyday2 <- aggregate(my_data2$steps, list(my_data2$date), sum)
names(stepbyday2) <- c("day", "steps")

meanbyday2 <- mean(stepbyday2$steps, na.rm=TRUE)
medianbyday2 <- median(stepbyday2$steps, na.rm=TRUE)




## Are there differences in activity patterns between weekdays and weekends?


my_data2$daytype[weekdays(as.Date(my_data2$date)) %in% c("samedi", "dimanche")] <- "weekend"
my_data2$daytype[is.na(my_data2$daytype)] <- "weekday"
my_data2$daytype <- as.factor(my_data2$daytype)

stepbyinterval2 <- aggregate(my_data2$steps, list(my_data2$interval, my_data2$daytype), mean, na.rm=TRUE)
names(stepbyinterval2) <- c("interval", "daytype", "meansteps")

g <- ggplot(stepbyinterval2, aes(x=interval, y = meansteps))
g + geom_line() + facet_grid(. ~daytype)
