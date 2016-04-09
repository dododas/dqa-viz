# DQA Visualization
#
# Plausibility visualization: False positive test results across multiple
# sites.
#
# Created by: Raibatak Das
# Apr 2016

library(reshape2)
library(magrittr)
library(dplyr)
library(ggplot2)
#setwd("~/consulting/active-projects/dqa-visualization/dqa-viz/code/")

## 1. Simulate data

# Simulation parameters
n.obs = 60
# number of sites
normal.sites = 10
anomalous.sites = 2
n.sites = normal.sites + anomalous.sites

# data distribution parameters
logmu.normal = log(0.01)
logmu.anomalous = log(0.03)
logsigma = 0.1
lsigma.min = 0.05
lsigma.max = 0.2

# Draw random samples
sim.data = matrix(nrow=n.obs, ncol=n.sites)
for (i in 1:normal.sites){ # normal sites
    mu = rlnorm(1, logmu.normal, logsigma)
    lsigma = runif(1, min=lsigma.min, max=lsigma.max)
    sim.data[,i] = rlnorm(n.obs, meanlog=log(mu), sdlog=lsigma)
}
for (j in (i+1):n.sites){ # anomalous sites
    mu = rlnorm(1, logmu.anomalous, logsigma)
    lsigma = runif(1, min=lsigma.min, max=lsigma.max)
    sim.data[,j] = rlnorm(n.obs, meanlog=log(mu), sdlog=lsigma)
}

sim.data = sim.data[, sample(ncol(sim.data))] # randomize columns
sim.data = cbind(1:60, sim.data) # add observation period
sim.data %<>% as.data.frame() # convert to data frame
names(sim.data) = c("obs.period", paste0("site-", 1:n.sites)) # rename columns

#2. Plot data

# Convert to long form for plotting
plot.data = melt(sim.data, id.vars="obs.period",
                 variable.name="site", value.name="fp.rate")

# Generate site-wise summary
data.summary = plot.data %>%
    group_by(site) %>%
    summarize(mean.fp.rate = mean(fp.rate))

# Plot mean error rate
png("../plots/anomaly-by-site-1.png", width=720, height=480)
ggplot(data.summary, aes(x=site, y=mean.fp.rate, colour=mean.fp.rate)) +
    geom_point(size=3, alpha=0.5) +
    scale_color_gradient(guide=F, high="red") +
    ylab("false positive diagnoses (%)") +
    theme_bw() +
    theme(axis.text.x = element_text(angle=45, vjust=0.5, size=12)) +
    ggtitle("Data from 2010-2015")
dev.off()

# Variation: mean error rates as bar chart
png("../plots/anomaly-by-site-2.png", width=720, height=480)
ggplot(data.summary, aes(x=site, y=mean.fp.rate,
                         colour=mean.fp.rate, fill=mean.fp.rate)) +
    geom_bar(stat="identity", width=0.3, alpha=0.7) +
    scale_fill_gradient(guide=F, high="red") +
    scale_color_gradient(guide=F, high="red") +
    ylab("false positive diagnoses (%)") +
    theme_bw() +
    theme(axis.text.x = element_text(angle=45, vjust=0.5, size=12)) +
    ggtitle("Data from 2010-2015")
dev.off()

# Boxplot summaries
png("../plots/anomaly-by-site-3.png", width=720, height=480)
ggplot(plot.data, aes(x=site, y=fp.rate)) +
    geom_boxplot() +
    ylab("false positive diagnoses (%)") +
    theme_bw() +
    theme(axis.text.x = element_text(angle=45, vjust=0.5, size=12)) +
    ggtitle("Data from 2010-2015")
dev.off()

# All data jittered
png("../plots/anomaly-by-site-4.png", width=720, height=480)
ggplot(plot.data, aes(x=site, y=fp.rate, colour=fp.rate)) +
    geom_jitter(width=0.2, aes(alpha=0.5)) +
    scale_color_gradient(guide=F, high="red") + scale_alpha(guide=F) +
    ylab("false positive diagnoses (%)") +
    theme_bw() +
    theme(axis.text.x = element_text(angle=45, vjust=0.5, size=12)) +
    ggtitle("Data from 2010-2015")
dev.off()
