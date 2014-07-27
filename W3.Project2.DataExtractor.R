## This file will be included in all plots and is in charge of downloading and extracting the data needed to do the plots
## when it's complete two variables will be accessible
##   NEI - data from the summarySCC_PM25.rds
##   SCC - data from the Source_Classification_Code.rds file

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


# Have the total PM[2.5] Emissions decreased from all sources from 2000-2008
year_list <- c(1999, 2002, 2005, 2008)

filtered_emmisions_by_year <- emissions_by_year[year %in% year_list]

plot(filtered_emmisions_by_year, col="red", main=expression('Total PM'[2.5]*' By Year'), xlab="Year", ylab=expression('Totatl Emissions (PM'[2.5]*')'))
reg1 <- lm(filtered_emmisions_by_year$Emissions~filtered_emmisions_by_year$year)
abline(reg1, col="blue")

