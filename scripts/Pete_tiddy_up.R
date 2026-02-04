# load and tidy data

dt1 <- readRDS("~/Documents/projects/ds4eeb/ds4eeb/final_proj/Pete_local_data/dt1.rds")
dt2 <- readRDS("~/Documents/projects/ds4eeb/ds4eeb/final_proj/Pete_local_data/dt2.rds")
dt3 <- readRDS("~/Documents/projects/ds4eeb/ds4eeb/final_proj/Pete_local_data/dt3.rds")
dt4 <- readRDS("~/Documents/projects/ds4eeb/ds4eeb/final_proj/Pete_local_data/dt4.rds")
dt5 <- readRDS("~/Documents/projects/ds4eeb/ds4eeb/final_proj/Pete_local_data/dt5.rds")

# SCRATCH -----
temp <- head(dt1, 20)

library(tidyverse)
library(janitor)

temp <- head(dt1, 20)
