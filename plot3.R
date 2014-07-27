# plot3.R - this script produces a chart plot3.png created using ggplot2
# that shows the total PM[2.5] in Baltimore broken down by type from 1999-2008

setwd("F:/Dogbert/Coursera/DataScience/04_ExploritoryDataAnalysis/W3")
library(ggplot2)

download_file_name <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
raw_data_file_name <- 'W3.Project2.Data.zip'

if(!file.exists(raw_data_file_name)) {
  download.file(download_file_name, destfile=raw_data_file_name, method='curl')
  unzip(raw_data_file_name)
  
  data_file_name <- 'summarySCC_PM25.rds'
  code_file_name <- 'Source_Classification_Code.rds'
  
  NEI <- readRDS(data_file_name)
  SCC <- readRDS(code_file_name)
} else {
  print("Data downloaded and extracted. Check NEI and SCC for data records.")
}

# pop this sucker int a data table for easy grouping
library(data.table)
NEI_DT <- data.table(NEI)

# get only the data for balitmore
baltimore_emissions_DT <- NEI_DT[NEI_DT$fips == "24510"]

# use data.table to group by year and type, summing the total Emissions
baltimore_emissions_by_year_type <- baltimore_emissions_DT[,list(Emissions=sum(Emissions)), by=c('year','type')]

## Question 3: Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
## which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City?
## Which have seen increases in emissions from 1999-2008? 

## Use the ggplot2 plotting system to make a plot answer this question.

# save it to a 480x960 pixel png file
small_data_png_file_name = "plot3.png"

# doubled the width to lay it out nice
png(height=480, width=960, file=small_data_png_file_name)

g1 <- ggplot(baltimore_emissions_by_year_type, aes(x=year, y=Emissions)) + geom_point()
g1 + 
  facet_grid(. ~ type) + 
  geom_smooth(method=lm) + ggtitle(expression("Total PM"[2.5]*" in Baltimore from 1999-2008")) +
  ylab(expression("Total Emissions (PM"[2.5]*')')) 

# close png file
dev.off() 

## Answer In Baltimore it appears that NONROAD, NONPOINT and ON-ROAD have seen a decrease in PM[2.5], while POINT has seen an increase.


