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
dt3 %>% 
  filter(IEPFishCode %in% levels(fish_codes[2,]))

(temp4 <- head(dt4)) # taxonomic details; use to filter dt1 & dt2 for fishes
dt4 %>% filter(Class == "Osteichthyes") # Sebastes auriculatus, Embiotoca lateralis, Oligocottus maculosus ARE Actinopterygii!
dt4 %>% filter(Phylum == "Chordata") %>% select(CommonName, NonNative, Family, Genus, Species)
(fish_codes <- 
    dt4 %>% 
    filter(Phylum == "Chordata",
           Species != "<NA>") %>%  # fishes identified to species only
    distinct(IEPFishCode))

(temp5 <- head(dt5)) # lat lon data for Location & StationCode

# select variables, levels, ranges, etc -----



# SCRATCH -----

dt3[7000:7070,] %>% select(Location, SampleDate, IEPFishCode, CommonName)

dt3 %>% filter(Phylum != "Chordata") %>% select(Location, SampleDate, IEPFishCode, CommonName) %>% view()
dt3 %>% distinct(CommonName)

invert_common_name <- c("Siberian prawn", "Estuarine jellyfish", "Black Sea jellyfish", "comb jelly", "red-eye medusa", "giant bell jelly", "Cnidarian unknown","Moerisia sp.", "Pacific sea nettle", "Egg yolk jellyfish", "Heptacarpus sp.", "Crangon sp.", "moon jellyfish", "Mud shrimp")

dt3 %>% 
  filter(CommonName %in% invert_common_name) # finds all rows w listed invertebrates NOT EXHAUSTIVE!
invert_sample <-
  dt3 %>% 
  filter(CommonName %in% invert_common_name) %>% 
  slice_sample(n = 100)

# create a subsample of the beach seine data (dt3) with lots of inverts to test
dt3_sample <-
  full_join(invert_sample, 
            slice_sample(dt3, n = 100)) %>% 
  slice_sample(prop = 1) %>% # randomizes the order of the rows
  print() # at least 50% of these should be invertebrates (could be slightly >50%)

dt3_sample %>% 
  filter(IEPFishCode %in% fishes)
test <- c("LARBAS", "MISSIL", "RAIKIL")
dt3_sample %>% filter(IEPFishCode %in% test)
typeof(test)
typeof(fishes)
dt3_sample_fishes <-
  dt3_sample %>% 
  filter(IEPFishCode %in% levels(fishes[2,])) %>% 
  print()
dim(dt3_sample_fishes)
