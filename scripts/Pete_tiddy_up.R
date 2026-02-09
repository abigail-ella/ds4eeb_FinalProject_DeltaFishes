# load libraries -----
library(tidyverse)
library(janitor)

# load and tidy data -----
dt1 <- readRDS("~/Documents/projects/ds4eeb/ds4eeb/final_proj/Pete_local_data/dt1.rds")
dt2 <- readRDS("~/Documents/projects/ds4eeb/ds4eeb/final_proj/Pete_local_data/dt2.rds")
dt3 <- readRDS("~/Documents/projects/ds4eeb/ds4eeb/final_proj/Pete_local_data/dt3.rds")
dt4 <- readRDS("~/Documents/projects/ds4eeb/ds4eeb/final_proj/Pete_local_data/dt4.rds")
dt5 <- readRDS("~/Documents/projects/ds4eeb/ds4eeb/final_proj/Pete_local_data/dt5.rds")

# what do we have? -----
(temp1 <- head(dt1)) # first half of data
range(dt1$SampleDate) # trouble with dates! should be 1978-2001, based on head/tail()
str(temp1) # SampleDate, SampleTime as chr; DO, Turbidity, SpecificConductance as logi?
# consider filtering by factors:
# MethodCode (KDTR, MWTR), GearConditionCode, WeatherCode, FlowDebris, SpecialStudy
# consider filtering by value:
# TowDuraction, Volume
# consider filtering by taxa:
# select fishes only

(temp2 <- head(dt2)) # second half of data
range(dt2$SampleDate) # more date formatting issues; note that data are NOT arranged by date

(temp3 <- head(dt3)) # beach seine data only
levels(dt3$MethodCode)
str(dt3) # SampleDate, SampleTime as chr; 
# consider filtering by factors:
# GearConditionCode, WeatherCode, SiteDisturbance, AlternateSite, SpecialStudy
# consider filtering by value:
# Volume
# consider filtering by taxa:
# select fishes only

(temp4 <- head(dt4)) # taxonomic details; use to filter dt1 & dt2 for fishes
(fishes <- 
    dt4 %>% 
    filter(Class == "Actinopterygii",
           IEPFishCode != "<NA>") %>% 
    distinct(IEPFishCode))

(temp5 <- head(dt5)) # lat lon data for Location & StationCode

# select variables, levels, ranges, etc -----



# SCRATCH -----

temp
