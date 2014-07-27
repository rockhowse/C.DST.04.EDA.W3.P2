# plot4.R - this plots the PM[2.5] totals for all Combustion Coal related sectors from 1999-2008

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

# get only the data for the Combustion + Coal sectors
# pull out the SCC ids of combustion coal sector records
SCC_comb_coal_id_list <- SCC[grepl("Comb", SCC$EI.Sector, ignore.case=TRUE) & grepl("Coal", SCC$EI.Sector, ignore.case=TRUE),"SCC"]

# filter the emissions data based on those ids
us_emissions_for_combustion_coal <- NEI_DT[NEI_DT$SCC %in% SCC_comb_coal_id_list,]

# use data.table to group by year and type, summing the total Emissions
us_emissions_by_year_type <- us_emissions_for_combustion_coal[,list(Emissions=sum(Emissions)), by=c('year')]

## Question 2: Have the total PM[2.5] Emissions decreased in Baltimore from 1999-2008

# save it to a 480x960 pixel png file
small_data_png_file_name = "plot4.png"

# doubled the width to lay it out nice
png(height=480, width=960, file=small_data_png_file_name)

g1 <- ggplot(us_emissions_by_year_type, aes(x=year, y=Emissions)) + geom_point()
g1 + 
  geom_smooth(method=lm) + ggtitle(expression("Total PM"[2.5]*" in the US for all Combustion Coal Sectors from 1999-2008")) +
  ylab(expression("Total Emissions (PM"[2.5]*')')) 

# close png file
dev.off() 

## Answer It appears that the PM[2.5] levels in the US have decreased between 1999-2008

