# CO medicaid beneficiary visualizations
#
# Created by: Raibatak Das
# Date: May 2016
# Last modified: Jun 2016

library(dplyr)
library(magrittr)
library(RColorBrewer)
library(ggplot2)
#setwd("~/consulting/active-projects/dqa-visualization/dqa-viz/code/")

# Import medicaid demographic data
medicaid.data = read.csv("../data/co-medicaid-demographics.csv")

# Rename and reorder age-groups to a more natural order
levels(medicaid.data$age)
medicaid.data %<>%
  mutate(age = as.character(age)) %>%
  mutate(age = ifelse(age=="5 and younger", "<5", age)) %>%
  mutate(age = ifelse(age=="85 and older", ">85", age)) %>%
  mutate(age = factor(age, levels = c("<5", "6-14", "15-20", "21-44", "45-64",
                                     "65-74", "75-84", ">85", "Unknown")))

# Extract counts in each age grop by year
age.counts = medicaid.data %>%
  group_by(year, age) %>%
  summarise(n = sum(count))

# Reorder categories
levels(medicaid.data$category)
medicaid.data %<>%
  mutate(category = as.character(category)) %>%
  mutate(category = ifelse(category == "Other/ Unknown", "Unknown", category)) %>%
  mutate(category = factor(category, levels = c("Children", "Adults", "Aged",
                                                "Disabled", "Unknown")))

# Extract counts in each category by year
category.counts = medicaid.data %>%
  group_by(year, category) %>%
  summarise(n = sum(count))

# Plot category counts - stacked bar chart
png("../plots/category-by-year-1.png", width=720, height=480)
ggplot(category.counts, aes(x=year, y=n, fill=category)) +
  geom_bar(stat = "identity", width=0.5, alpha=0.85) +
  scale_fill_brewer(type="div", palette="RdYlGn", direction=-1,
                    guide = guide_legend(reverse=T)) +
  scale_x_continuous(breaks=c(2001:2009)) +
  ylab("patient count") +
  scale_y_continuous(breaks=c(0, 2e5, 4e5, 6e5),
                     labels=c("0", "0.2 M", "0.4 M", "0.6 M")) +
  theme_bw()
dev.off()

# Use faceting to show individual categories
png("../plots/category-by-year-2.png", width=720, height=720)
category.counts %>%
  mutate(category = factor(category, levels=rev(levels(category)))) %>%
  ggplot(aes(x=year, y=n, color=category)) +
  geom_line() +
  geom_point(shape=1, size=3, stroke=1.5, colour="white") +
  geom_point() +
  scale_color_brewer(type="div", palette="RdYlGn", guide = F) +
  facet_grid(category ~ ., scales="free_y") +
  scale_x_continuous(breaks=c(2001:2009)) +
  ylab("patient count") +
  theme_bw()
dev.off()

# Plot counts in beneficiary age groups by year
png("../plots/age-by-year-1.png", width=720, height=480)
ggplot(age.counts, aes(x=year, y=n, fill=age)) +
  geom_bar(stat = "identity", width=0.5, alpha=0.8) +
  scale_fill_brewer(type = "seq", palette="YlOrRd", guide = guide_legend(reverse=T)) +
  scale_x_continuous(breaks=c(2001:2009)) +
  ylab("patient count") +
  scale_y_continuous(breaks=c(0, 2e5, 4e5, 6e5),
                     labels=c("0", "0.2 M", "0.4 M", "0.6 M")) +
  theme_bw()
dev.off()

# Use faceting to show individual age groups
png("../plots/age-by-year-2.png", width=720, height=720)
age.counts %>%
  mutate(age = factor(age, levels=rev(levels(age)))) %>%
  ggplot(aes(x=year, y=n, color=age)) +
  geom_line() +
  geom_point(shape=1, size=3, stroke=1.5, colour="white") +
  geom_point() +
  scale_color_brewer(type = "seq", palette="YlOrRd", direction = -1, guide = F) +
  facet_grid(age ~ ., scales="free_y") +
  scale_x_continuous(breaks=c(2001:2009)) +
  ylab("patient count") +
  theme_bw()
dev.off()
