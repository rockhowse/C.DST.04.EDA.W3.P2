# plot5.R - this plots the PM[2.5] Emmission totals for all Vehical related sources in Baltimore from 1999-2008

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

# get list of ids for sectors that have motor Vehicles
SCC_vehicles_id_list <- SCC[grepl("Vehicles", SCC$EI.Sector, ignore.case=TRUE),"SCC"]

# filter the emissions data based on those ids in Baltimore
baltimore_emissions_for_vehicles <- NEI_DT[NEI_DT$SCC %in% SCC_vehicles_id_list & NEI_DT$fips == "24510",]

# use data.table to group by year summing the total Emissions
baltimore_emissions_for_vehicles_by_year <- baltimore_emissions_for_vehicles[,list(Emissions=sum(Emissions)), by=c('year')]

## Question 2: Have the total PM[2.5] Emissions decreased in Baltimore from 1999-2008

# save it to a 480x480 pixel png file
small_data_png_file_name = "plot5.png"
png(height=480, width=480, file=small_data_png_file_name)

g1 <- ggplot(baltimore_emissions_for_vehicles_by_year, aes(x=year, y=Emissions)) + geom_point()
g1 + 
  geom_smooth(method=lm) + ggtitle(expression("Total PM"[2.5]*" vehicle Emissions in Baltimore from 1999-2008")) +
  ylab(expression("Total Emissions (PM"[2.5]*')')) 

# close png file
dev.off() 

## Answer It appears that the PM[2.5] Emissions for vehicles in Baltimore have decreased from 1999-2008
