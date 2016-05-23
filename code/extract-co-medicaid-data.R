# Extract CO medicaid beneficiary demographic characteristics
#
# Created by: Raibatak Das
# Date: May 2016

library(XLConnect)
library(reshape2)
library(magrittr)

# Initialize empty data frame
medicaid.data = data.frame(year = numeric(),
                           age = character(),
                           category = character(),
                           count = integer())

# Import data from "xxxxAllBenes_CO.xls" files
# xxxx is the year from 2001 through 2009
# these files were downloaded from:
# https://www.cms.gov/Research-Statistics-Data-and-Systems/Computer-Data-and-Systems/MedicaidDataSourcesGenInfo/Medicaid-Analytic-eXtract-MAX-Rx.html
years = c(2001:2009)
for (year in years){
  filename = paste0("../data/co-medicaid-data/", year, "AllBenes_CO.xls")
  data.source = loadWorkbook(filename=filename)
  categories = readWorksheet(data.source, sheet="Table 2", header=F,
                             startRow = 6, endRow = 6,
                             startCol = 3, endCol = 7)
  ages = readWorksheet(data.source, sheet="Table 2", header=F,
                       startRow = 10, endRow = 18,
                       startCol = 1, endCol = 1)
  counts = readWorksheet(data.source, sheet="Table 2", header=F,
                         startRow = 10, endRow = 18,
                         startCol = 3, endCol = 7)
  # Combine into a "wide" data frame
  data = data.frame(age=ages, counts)
  colnames(data) = c("age", categories)
  # Transform to "long" form
  data %<>% melt(variable.name="category", value.name="count")
  # Add year as a variable
  data["year"] = year
  # Append to full data frame
  medicaid.data %<>% rbind(data[c("year", "age", "category", "count")])
}

# Save data as csv file
write.csv(medicaid.data, "../data/co-medicaid-demographics.csv")
