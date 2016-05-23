# CO medicaid beneficiary visualizations
#
# Created by: Raibatak Das
# Date: May 2016

library(ggplot2)
#setwd("~/consulting/active-projects/dqa-visualization/dqa-viz/code/")

# Import medicaid demographic data
medicaid.data = read.csv("../data/co-medicaid-demographics.csv")

## TO DO:
# Reorder age-groups to a more natural order
# Stream plots

# Plot 1. Distribution of beneficiary categories by year
png("../plots/category-by-year-1.png", width=720, height=480)
ggplot(data = medicaid.data,
       aes(x=year, y=count, fill=category)) +
  geom_bar(stat = "identity") +
  scale_fill_brewer(type="qual", palette="Set1") +
  scale_x_continuous(breaks=c(2001:2009)) +
  theme_bw()
dev.off()

# Plot 2. Distribution of beneficiary age groups by year
png("../plots/age-by-year-1.png", width=720, height=480)
ggplot(data = medicaid.data,
       aes(x=year, y=count, fill=age)) +
    geom_bar(stat = "identity") +
    scale_fill_brewer(type="qual", palette="Set1") +
    scale_x_continuous(breaks=c(2001:2009)) +
    theme_bw()
dev.off()
