# plot2.R - this script produces plot2.png showing a decrease in PM[2.5] in Baltimore from 1999-2008

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

# get only the data for balitmore
baltimore_emissions_DT <- NEI_DT[NEI_DT$fips == "24510"]
baltimore_emissions_by_year <- baltimore_emissions_DT[,list(Emissions=sum(Emissions)), by='year']

## Question 2: Have the total PM[2.5] Emissions decreased in Baltimore from 1999-2008

# save it to a 480x480 pixel png file
small_data_png_file_name = "plot2.png"
png(height=480, width=480, file=small_data_png_file_name)

plot(baltimore_emissions_by_year, col="red", main=expression('Total PM'[2.5]* ' Emissions in Baltimore between 1999-2008'), xlab="Year", ylab=expression('Totatl Emissions (PM'[2.5]*')'), pch=19)
reg1 <- lm(baltimore_emissions_by_year$Emissions~baltimore_emissions_by_year$year)
abline(reg1, col="blue")

# close png file
dev.off() 

## Answer:      Yes the total PM[2.5] Emissions have decreased in Baltimore between 1999-2008


