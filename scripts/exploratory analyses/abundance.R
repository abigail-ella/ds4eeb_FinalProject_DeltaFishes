# combo_trawl ----
# 'combo_trawl' from Abbie's code (see DeltaFishes.qmd)
# note that these include both MWTR and KDTR
# added unique 'sample_code'
trawls <- combo_trawl %>% 
  mutate(across(c(Location:StationCode), as.factor),
         date = mdy(SampleDate),
         .keep = "unused") %>% 
  clean_names() %>% 
  group_by(date, sample_time, station_code) %>% 
  mutate(sample_id = cur_group_id()) %>% 
  ungroup() %>% 
  relocate(date, .after = station_code)

temp <-
  trawls %>% 
  group_by(sample_id, organism_code) %>% 
  summarise(total_count = sum(count, 
                              na.rm = TRUE),
            .groups = "drop") %>% 
  pivot_wider(names_from = organism_code,
              values_from = total_count,
              values_fill = 0) %>% 
  dplyr::select(sample_id, CHN, RBT) %>% 
  ungroup()
  
# totals ----
# totals for each unique trawl...
trawl_sum <-
  inner_join(trawls, temp, by = "sample_id") %>% 
  dplyr::select(sample_id, CHN, RBT,
                location, region_code, station_code, date, sample_time,
                method_code, water_temp) %>% 
  arrange(sample_id) %>% 
  distinct()

# effort ----
# control for effort (# of trawls)

trawl_indices <- 
  trawl_sum %>% 
  mutate(year = year(date)) %>% 
  group_by(year) %>% 
  summarise(total_chn = sum(CHN),
            total_rbt = sum(RBT),
            n = n(),
            # index of abundance (total fish/number of trawls)
            Chinook = sum(CHN)/n,
            Steelhead = sum(RBT)/n) %>% 
  pivot_longer(cols = c(Chinook, Steelhead),
               names_to = "species",
               values_to = "index")

# plot ----
ggplot(trawl_indices,
       aes(x = year, y = index, color = species)) +
  geom_point() +
  facet_wrap(~ species, ncol = 1, scales = "free_y") +
  labs(x = "Year", y = "Abundance Index") +
  theme_bw()

# SCRATCH ----
# 'salmonid_trawl' from Abbie's code (see DeltaFishes.qmd)
# these data include only those events in which a salmon or steelhead was captured

salmonids <- salmonid_trawl[, c(1:4, 8, 13, 14, 25, 31, 32, 37, 39)] %>%
  mutate(
    across(c(Location:StationCode,OrganismCode,RaceByLength), as.factor),
    date = mdy(SampleDate), 
    .keep = "unused") %>% 
  clean_names() %>% 
  relocate(date, .after = station_code)

# create new data frame w unique number for every unique combo station, date, time
salmonids <-
  salmonids %>% 
  group_by(date, sample_time, station_code) %>% 
  mutate(sample_id = cur_group_id()) %>% 
  ungroup() %>% 
  relocate(sample_id, .after = sample_time)

# check
head(salmonids)

# chinook catch (summed across sizes, runs) for each sampling event
chn_summary <- 
  salmonids %>%
  filter(organism_code == "CHN") %>% 
  group_by(sample_id) %>%
  summarise(catch = sum(count), .groups = "drop") %>%
  left_join(
    salmonids %>% 
      dplyr::select(sample_id, location, region_code, station_code, date, water_temp, turbidity) %>% 
      distinct(),
    by = "sample_id"
  ) %>% 
  mutate(year = year(date),
         month = month(date)) %>% 
  print()

nrow(distinct(chn_summary)) # check

# steelhead catch (summed across sizes, runs) for each sampling event
rbt_summary <- 
  salmonids %>%
  filter(organism_code == "RBT") %>% 
  group_by(sample_id) %>%
  summarise(catch = sum(count), .groups = "drop") %>%
  left_join(
    salmonids %>% 
      dplyr::select(sample_id, location, region_code, station_code, date, water_temp, turbidity) %>% 
      distinct(),
    by = "sample_id"
  ) %>% 
  mutate(year = year(date),
         month = month(date)) %>% 
  print()

nrow(distinct(rbt_summary)) # check

ggplot(chn_summary,
       aes(x = as.factor(year), y = log(catch))) +
  geom_boxplot() +
  labs(title = "Chinook MWTR Counts",
       x = "Year", y = "Counts (log n)")
  theme_bw()

test <- 
  tibble(sample_id = c(1,1,1,2,3,3,4,5),
       org_code = c("CHN", "CHN", "RBT", 
                    "CHN", 
                    "SEN", "CHN",
                    "RBT",
                    "SEN"),
       FL = sample.int(129, 8),
       count = c(2, rep(1,7))
       )
test %>% 
  group_by(sample_id, org_code) %>% 
  summarise(total_count = sum(count, na.rm = TRUE), .groups = "drop") %>% 
  pivot_wider(names_from = org_code, values_from = total_count, values_fill = 0)
