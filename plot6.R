library(plyr) 
library(reshape2)
library(ggplot2)
library(gridExtra)

# Set the working directory
setwd("~/Exploratory-Data-Analysis/Project_2")

# Read the EPA's National Emission Inventory - PM2.5 Emissions Data
NEI <- readRDS("summarySCC_PM25.rds")
# Read the Source Classification Code Table
SCC <- readRDS("Source_Classification_Code.rds")

#Subset ON-ROAD motor vehicle emmmissions for Los Angeles and Baltimore 
onRoadEmissions <- subset(NEI, (fips == "06037" | fips == "24510") & type =="ON-ROAD", c("Emissions", "year","fips"))

# Melt data for reshaping
onRoadEmissions <- melt(onRoadEmissions, id = c("year", "fips"), measure.vars = c("Emissions"))
# Reshape by summing emissions by fips (city/county) and year
onRoadEmissions <- dcast(onRoadEmissions, fips + year ~ variable, sum)

# Open plot file
png(filename = "plot6.png", width = 640, height = 640, units="px")

# Draw the plot comparing On-Road PM2.5 emissions for the two counties.
p6a <- ggplot(data = onRoadEmissions, aes(x = year, y = Emissions, group = fips, colour = fips)) 
p6a <- p6a + geom_line() 
p6a <- p6a + geom_point(size = 4, shape = 21, fill = "white") 
p6a <- p6a + geom_text(aes(label = round(Emissions, 0)), size = 4, hjust = 0.5, vjust = -1.5, colour = "blue")
p6a <- p6a + ylim(0, 5000)
p6a <- p6a + xlab("Year") + ylab("Emissions (Tons)") 
p6a <- p6a + ggtitle("6a. On-Road Motor Vehicle PM2.5 Emissions: Los Angeles vs. Baltimore")
p6a <- p6a + scale_colour_hue(name = "County",
                              breaks = c("06037", "24510"),
                              labels =c("Los Angeles", "Baltimore"))

# Create new data frame to hold emission change percentages by time interval for the two locations
changes <- data.frame(interval = character(), percent = numeric(), fips = character())

# Compute Change Percentage for each period of time and location
#
# The data set we iterate over (onRoadEmissions):
#
#    fips year  Emissions
# 1 06037 1999 3931.12000
# 2 06037 2002 4273.71020
# 3 06037 2005 4601.41493
# 4 06037 2008 4101.32100
# 5 24510 1999  346.82000
# 6 24510 2002  134.30882
# 7 24510 2005  130.43038
# 8 24510 2008   88.27546

i <- 1
while(i < nrow(onRoadEmissions))
{
  int <- paste(onRoadEmissions[i, 2], onRoadEmissions[i+1, 2], sep = "-")
  p <- abs(((onRoadEmissions[i + 1, 3] - onRoadEmissions[i, 3]) / onRoadEmissions[i, 3]) * 100)
  f <- onRoadEmissions[i, 1]
  
  changes <- rbind(changes, data.frame(interval = int, percentage = p, fips = f))
  
  i <- i + 1
  # Skip change computation between lines 4 and 5 
  # (different counties, does not make sense to compute percentage of change for them)
  if (i == 4) { i = i + 1 }
}

#  Draw plot comparing On-Road PM2.5 emission CHANGES by time interval for the two counties.
p6b <- ggplot(data = changes, aes(x = interval, y = percentage, fill = fips)) 
p6b <- p6b + geom_bar(stat = "identity", position = position_dodge())
p6b <- p6b + ggtitle("6b. Emission Change Percentages by Time Interval: Los Angeles vs. Baltimore")
p6b <- p6b + xlab("Time Interval")
p6b <- p6b + ylab("Emission Change Percentage (%)")
p6b <- p6b + scale_fill_discrete("County", labels = c("Los Angeles","Baltimore"))

#  Arrange the two plots on same grid
grid.arrange(p6a, p6b, nrow = 2, ncol = 1)

#  Conclude drawing on graphic device
dev.off()