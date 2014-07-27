# plot6.R - this plots the PM[2.5] Emmission totals for all Vehical related sources in Baltimore vs Las Angeles County from 1999-2008

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
library(xts)
NEI_DT <- data.table(NEI)

# get list of ids for sectors that have motor Vehicles
SCC_vehicles_id_list <- SCC[grepl("Vehicles", SCC$EI.Sector, ignore.case=TRUE),"SCC"]

# filter the emissions data based on those ids in Baltimore
baltimore_vs_lac_emissions_for_vehicles <- NEI_DT[NEI_DT$SCC %in% SCC_vehicles_id_list & NEI_DT$fips %in% c("06037","24510"),]

# use data.table to group by year summing the total Emissions
baltimore_vs_lac_emissions_for_vehicles_by_year <- baltimore_vs_lac_emissions_for_vehicles[,list(Emissions=sum(Emissions)), by=c('year','fips')]

# lets put some rational names on the data instead of the fips number =P
baltimore_vs_lac_emissions_for_vehicles_by_year$fips_name <- unlist(lapply(baltimore_vs_lac_emissions_for_vehicles_by_year$fips, function(x) if (x == "06037") {"Los Angeles County"} else {"Baltimore"}))

## Question 6: Compare emissions from motor vehicle sources in Baltimore City with emissions from motor 
## vehicle sources in Los Angeles County, California (fips == "06037"). 
## Which city has seen greater changes over time in motor vehicle emissions?

# save it to a 480x720 pixel png file
small_data_png_file_name = "plot6.png"

png(height=480, width=720, file=small_data_png_file_name)

g1 <- ggplot(baltimore_vs_lac_emissions_for_vehicles_by_year, aes(x=year, y=Emissions)) + geom_point()
g1 + 
  scale_y_log10() +
  facet_grid(fips_name ~ .) +
  geom_smooth(method=lm) + 
  ggtitle(expression("Relative Total PM"[2.5]*" vehicle Emissions in Baltimore vs Los Angeles County from 1999-2008")) +
  ylab(expression("Total Emissions (PM"[2.5]*') *log scale')) 

# close png file
dev.off() 

## Answer It appears that Baltimore had the greatest change. It decreased by a larger ammount in relative terms to the Los Angeles County increase. 
## To show this easily I graphed each to log scale as the absolute change in Los Angeles County was greater, but it's percentage change was smaller.
