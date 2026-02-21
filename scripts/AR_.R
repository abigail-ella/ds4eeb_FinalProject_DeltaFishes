#working with Peter tidy data

install.packages("janitor")

# load libraries -----
library(tidyverse)
library(janitor)
library(chron)

# load and tidy data -----
dt1 <- readRDS("C:/Delta raw data/dt1.rds")
dt2 <- readRDS("C:/Delta raw data/dt2.rds")
dt3 <- readRDS("C:/Delta raw data/dt3.rds")
dt4 <- readRDS("C:/Delta raw data/dt4.rds")
dt5 <- readRDS("C:/Delta raw data/dt5.rds")

# what do we have? -----
## trawl 78-01 ------
(temp1 <- head(dt1)) # first half of data
range(dt1$SampleDate) # trouble with dates! should be 1978-2001, based on head/tail()
str(temp1) # SampleDate, SampleTime as chr; DO, Turbidity, SpecificConductance as logi?
# consider filtering by factors:
# MethodCode (KDTR, MWTR), GearConditionCode, WeatherCode, FlowDebris, SpecialStudy
# consider filtering by value:
# TowDuraction, Volume
# consider filtering by taxa:
# select fishes only

## trawl 02-24 ------
(temp2 <- head(dt2)) # second half of data
range(dt2$SampleDate) # more date formatting issues; note that data are NOT arranged by date

#unable to find %>%, try loading dplyr
library(dplyr)

## taxonic details -----
(temp4 <- head(dt4)) # taxonomic details; use to filter dt1, dt2 & dt3 for fishes
dt4 %>% filter(Class == "Osteichthyes") # Sebastes auriculatus, Embiotoca lateralis, Oligocottus maculosus ARE Actinopterygii!
dt4 %>% filter(Phylum == "Chordata") %>% select(CommonName, NonNative, Family, Genus, Species)

# pull all IEP fish codes out to help with filtering for fish data only (ie no inverts)
(fish_codes <- 
    dt4 %>% 
    filter(Phylum == "Chordata",
           Species != "<NA>") %>%  # fishes identified to species only
    distinct(IEPFishCode))

## seine data ----
(temp3 <- head(dt3)) # beach seine data only
range(dt3$SampleDate) # should start in 1976...
levels(dt3$MethodCode) # yep, seine only
str(dt3) # SampleDate, SampleTime as chr; 
# consider filtering by factors:
# GearConditionCode, WeatherCode, SiteDisturbance, AlternateSite, SpecialStudy
# Gear...: 1=good sample, 2=fair, 3=poor, 9=fish gilled in trawl net, not caught properly;
#          seems to reference condition of the sample (fish), not the gear--unimportant?
# consider filtering by value:
# Volume (there are some extreme values)
# consider filtering by taxa: (fishes only)
# consider filtering by region_code:
# 1= Lower Sacramento River, 2= North Delta, 3= Central Delta, 4= South Delta, 5= San Joaquin River, 6= Bay Area, 7= Sacramento River


seine_all_var <-
  dt3 %>% 
  # select fishes only (includes empty hauls--seines w no fishes of any spp)
  filter(IEPFishCode %in% levels(fish_codes[2,])) %>% 
  # provide columns w good names
  clean_names() %>% 
  # fix date & time variables, originally as chr
  mutate(date = mdy(sample_date), 
         time = time(sample_time), 
         .keep = "unused") %>% 
  # reorder columns
  relocate(date:time, .before = method_code)

## location data ----
(temp5 <- head(dt5)) # lat lon data for Location & StationCode

# select variables, levels, ranges, etc -----
summary(seine_all_var)

# filter by:
# circum that may compromise data qual? (time, gear_condition, weather_code, 
# site_disturbance, alternate_site, [seine] volume, special_study)

# do, turbidity, specific_conductance (outliers?)


# SCRATCH -----
# I'm putting  # infront of the scratch code until I decide if I want to use it
#dt3[7000:7070,] %>% select(Location, SampleDate, IEPFishCode, CommonName)

#dt3 %>% filter(Phylum != "Chordata") %>% select(Location, SampleDate, IEPFishCode, CommonName) %>% view()
#dt3 %>% distinct(CommonName)

#invert_common_name <- c("Siberian prawn", "Estuarine jellyfish", "Black Sea jellyfish", "comb jelly", "red-eye medusa", "giant bell jelly", "Cnidarian unknown","Moerisia sp.", "Pacific sea nettle", "Egg yolk jellyfish", "Heptacarpus sp.", "Crangon sp.", "moon jellyfish", "Mud shrimp")

#dt3 %>% 
#  filter(CommonName %in% invert_common_name) # finds all rows w listed invertebrates NOT EXHAUSTIVE!
#invert_sample <-
 # dt3 %>% 
  #filter(CommonName %in% invert_common_name) %>% 
  #slice_sample(n = 100)

# create a subsample of the beach seine data (dt3) with lots of inverts to test
#dt3_sample <-
 # full_join(invert_sample, 
  #          slice_sample(dt3, n = 100)) %>% 
#  slice_sample(prop = 1) %>% # randomizes the order of the rows
 # print() # at least 50% of these should be invertebrates (could be slightly >50%)

#dt3_sample %>% 
 # filter(IEPFishCode %in% fishes)
#test <- c("LARBAS", "MISSIL", "RAIKIL")
#dt3_sample %>% filter(IEPFishCode %in% test)
#typeof(test)
#typeof(fishes)
#dt3_sample_fishes <-
#  dt3_sample %>% 
 # filter(IEPFishCode %in% levels(fishes[2,])) %>% 
  #print()
#dim(dt3_sample_fishes)


#End of scratch-------