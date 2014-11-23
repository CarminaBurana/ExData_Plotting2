library(plyr) 
library(reshape2)
library(ggplot2)

# Set the working directory
setwd("~/Exploratory-Data-Analysis/Project_2")

# Read the EPA's National Emission Inventory - PM2.5 Emissions Data
NEI <- readRDS("summarySCC_PM25.rds")
# Read the Source Classification Code Table
SCC <- readRDS("Source_Classification_Code.rds")

# Subset ON-ROAD emissions in Baltimore
onRoadEmmissionsInBaltimore <- subset(NEI, fips == "24510" & type =="ON-ROAD", c("Emissions", "year","type"))
# Sum emissions by Year
onRoadEmmissionsInBaltimore <- aggregate(Emissions ~ year, onRoadEmmissionsInBaltimore, sum)

# Open plot file
png(filename = "plot5.png", width = 640, height = 640, units="px")

# Plot On-Road PM2.5 Emissions in Baltimore
p <- ggplot(data = onRoadEmmissionsInBaltimore, aes(x = year, y = Emissions)) 
p <- p + geom_line() 
p <- p + geom_point(size = 4, shape = 21, fill = "white") 
p <- p + geom_text(aes(label = round(Emissions, 0)), size = 6, hjust = 0.5, vjust = 2, colour = "blue")
p <- p + xlab("Year") 
p <- p + ylab("Emissions (Tons)") 
p <- p + ggtitle("Motor Vehicle PM2.5 Emissions - Baltimore, 1999-2008")

print(p)

#  Conclude drawing on graphic device
dev.off()