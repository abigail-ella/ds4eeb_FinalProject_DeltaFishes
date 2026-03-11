# working with Peter tidy data
# install.packages("ggpubr")
# install.packages("janitor")
# install.packages("car")
# load libraries -----
library(tidyverse)
library(janitor)
library(chron)
library (stringr)
library(janitor) 
library (stringr)
library(stats)
library(car)
library(ggplot2)
library(ggpubr)
library(ggeffects)
### give him a dag
## identify which beach sein sites that have been used the most consistently 

# load the tidy data
dt1 <- readRDS("C:/Delta raw data/dt1.rds")
dt2 <- readRDS("C:/Delta raw data/dt2.rds")
dt3 <- readRDS("C:/Delta raw data/dt3.rds")
dt4 <- readRDS("C:/Delta raw data/dt4.rds")
dt5 <- readRDS("C:/Delta raw data/dt5.rds")

head(dt1)
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
#goal separate date, make a talbe with date location, station code and the 11 variabes in temp 4

#now()
#print(now())
# okay trying for location, station code, date, fishiD, common name from dt1

p_1 <- dt1 %>% 
  select(Location,StationCode,SampleDate,SampleTime, IEPFishCode,CommonName) # pick out columns of interest
print(p_1)
# see whats missing
missing_data<- which(is.na(p_1$CommonName))
print(missing_data)
library(dplyr)

# First join by IEPFishCode
## taxonic details -----

p_2 <- p_1 %>%
 #join by IEPFishCode
  left_join(
  dt4 %>%select(IEPFishCode, Genus),
by = "IEPFishCode",
relationship = "many-to-many" # added this to silence the many to many relationship between x and y
) %>% 
  rename(genus_code= Genus) %>% 
#join by CommonName
left_join(
  dt4 %>% select(CommonName, Genus),
  by="CommonName",
  relationship = "many-to-many"
) %>% 
  rename(genus_name = Genus) %>% 
  # makes a new column using information from the two columns just created
  mutate(genus= coalesce(genus_code,genus_name))
 
head(p_2)

print(head(p_2))
# remove helper columns
p_2[c("genus_code", "genus_name")]<-list(NULL)
print(p_2)

# get a month and year column separate

library(lubridate)

p_2 <- p_2 %>%
  mutate(
    SampleDate = mdy(SampleDate),   # convert to Date (month/day/year)
    month = month(SampleDate),
    year = year(SampleDate))
view(p_2)
print(p_2)

# Get NonNative column
p_2 <- p_2 %>%
  #join by IEPFishCode
  left_join(
    dt4 %>%select(IEPFishCode, NonNative),
    by = "IEPFishCode",
    relationship = "many-to-many" # added this to silence the many to many relationship between x and y
  ) %>% 
  rename(non_native_code= NonNative) %>% 
  #join by CommonName
  left_join(
    dt4 %>% select(CommonName, NonNative),
    by="CommonName",
    relationship = "many-to-many"
  ) %>% 
  rename(non_native_name = NonNative) %>% 
  # makes a new column using information from the two columns just created
  mutate(NonNative= coalesce(non_native_code,non_native_name))
# remove helper columns
p_2[c("non_native_name", "non_native_code")]<-list(NULL)

# Adding Latitude using the station code refrence

p_2 <- p_2 %>%
  #join by Station code
  left_join(
    dt5 %>%select(StationCode, Latitude),
    by = "StationCode",
    relationship = "many-to-many" # added this to silence the many to many relationship between x and y
  )
# Adding Longitude using the station code refrence

p_2 <- p_2 %>%
  #join by Station code
  left_join(
    dt5 %>%select(StationCode, Longitude),
    by = "StationCode",
    relationship = "many-to-many" # added this to silence the many to many relationship between x and y
  )

################### new stuff
### Test some linear models, similar to those we worked in class, to see if year type can explain the year-to-year differences in migration timing (eg day of 10% accumulation).
### That analysis, with and without 1977 (outlier), would be a great contribution to the final proj!
## Get the graph first then do the model

std_colors <- c("darkblue", "green", "red")

pctl_days %>% 
  ggplot(
    # color points according to threshold (10, 50, 90%)
    aes(x = wy, y = wd, color = percentile)
  ) +
  geom_point() +
  geom_smooth(data = pctl_days_red,
              # show linear trends
              method = "lm",
              se = TRUE) +
  labs(title = "Chinook Salmon Outmigration Timing",
       subtitle = "1977 excluded from trend analyses",
       x = "Water Year",
       y = "Day of the Water Year",
       color = "Percentile") +
  scale_color_manual(values = std_colors) +
  theme_bw()

### fish colors -----
#### Oncorhynchus -----
pctl_days %>% 
  ggplot(
    # color points according to threshold (10, 50, 90%)
    aes(x = wy, y = wd, color = percentile)
  ) +
  geom_point(size = .8) +
  scale_color_fish(discrete = TRUE,
                   option = "Oncorhynchus_tshawytscha",
                   alpha = 0.8) +
  geom_smooth(data = pctl_days_red,
              alpha = 0.2,
              # show linear trends
              method = "lm",
              se = TRUE) +
  labs(title = "Chinook Salmon Outmigration Timing",
       subtitle = "1977 excluded from trend analyses",
       x = "Water Year",
       y = "Day of the Water Year",
       color = "Percentile") +
  theme_bw()

library(brms)
#### run model -----
# Day of the water year as a funciton of water year
m.d_10.wy <- 
  brm(data = percentile_days, #Givethemodel the percentile_days data
      # Choose agaussian(normal)distribution
      family= gaussian,
      # Specify the modelhere.
      day_10 ~ 1+ wy,
      # Here's where you specify parameters for executing the Markovchains
      # We'reusing similartothedefaults,except we set cores to 4 so the analys is runs fasterthanthedefaultof1
      iter = 2000, warmup= 1000, chains= 4, cores=4,
      # Setting the "seed"determines which randomnumbers will get sampled.
      # In this case, it makes the randomness of the Markovchain runs reproducible
      # (so that both of us get the exact same results when running the model)
      seed = 4)
      # Save the fit the dmodel object as output-helpful for reloading in the output later
      #file = "m.d_10.wy") not sure where I want to save it

summary(m.d_10.wy)
plot(m.d_10.wy)
# run model for 50% of the salmon caught that year
m.d_50.wy <- 
  brm(data = percentile_days, #Givethemodel the percentile_days data
      # Choose agaussian(normal)distribution
      family= gaussian,
      # Specify the modelhere.
      day_50 ~ 1+ wy,
      # Here's where you specify parameters for executing the Markovchains
      # We'reusing similartothedefaults,except we set cores to 4 so the analys is runs fasterthanthedefaultof1
      iter = 2000, warmup= 1000, chains= 4, cores=4,
      # Setting the "seed"determines which randomnumbers will get sampled.
      # In this case, it makes the randomness of the Markovchain runs reproducible
      # (so that both of us get the exact same results when running the model)
      seed = 4)

summary(m.d_50.wy)
# run model for 90% of the salmon caught that year
m.d_90.wy <- 
  brm(data = percentile_days, #Givethemodel the percentile_days data
      # Choose agaussian(normal)distribution
      family= gaussian,
      # Specify the modelhere.
      day_90 ~ 1+ wy,
      # Here's where you specify parameters for executing the Markovchains
      # We'reusing similartothedefaults,except we set cores to 4 so the analys is runs fasterthanthedefaultof1
      iter = 2000, warmup= 1000, chains= 4, cores=4,
      # Setting the "seed"determines which randomnumbers will get sampled.
      # In this case, it makes the randomness of the Markovchain runs reproducible
      # (so that both of us get the exact same results when running the model)
      seed = 4)

summary(m.d_90.wy)
# plot m.d_10.wy
plot(m.d_10.wy)
# plot m.d_50.wy
plot(m.d_90.wy)
#plot(m.d_90.wy)
plot(m.d_90.wy)
