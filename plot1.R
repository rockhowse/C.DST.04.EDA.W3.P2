# plot1.R - this script produces the graph plot1.png showing a decrease in emissions for all sorces from 1999-2008

setwd("F:/Dogbert/Coursera/DataScience/04_ExploritoryDataAnalysis/W3")

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
emmisions_by_year <- NEI_DT[,list(Emissions=sum(Emissions)), by='year']

## Question 1: Have the total PM[2.5] Emissions decreased from all sources from 1999-2008

# have to filter using only the specific years
# don't have to filter... the data only includes these years
# year_list <- c(1999, 2002, 2005, 2008)
# filtered_emmisions_by_year <- emissions_by_year[year %in% year_list]

# save it to a 480x480 pixel png file
small_data_png_file_name = "plot1.png"
png(height=480, width=480, file=small_data_png_file_name)

plot(emmisions_by_year, col="red", main=expression('Total PM'[2.5]*' Emissions For All Sources'), xlab="Year", ylab=expression('Totatl Emissions (PM'[2.5]*')'), pch=19)
reg1 <- lm(emmisions_by_year$Emissions~emmisions_by_year$year)
abline(reg1, col="blue")

# close png file
dev.off() 

## Answer:      Yes the PM[2.5] Emissions have decreased from all sources between 1999-2008


