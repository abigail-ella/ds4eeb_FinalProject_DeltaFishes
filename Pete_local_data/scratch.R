# pivot wide -----
# pivot attemp, checking w row totals, fail
temp <- 
  seine_long %>% 
  pivot_wider(names_from = common_name, 
              values_from = count,
              values_fn = sum,
              values_fill = 0) %>% 
  select(-c(iep_fish_code, 'No catch')) %>% 
  clean_names() %>% 
  filter(date == "1976-05-28" & station_code == "AM001S") %>% 
  mutate(total = rowSums(across(11:12), 
                         na.rm = T), 
         .after = "date") %>% 
  select(-c(1, 2, 6:11)) %>% 
  print()

colnames(temp)

# tracing errors
seine %>% filter(date == "1976-05-28" & station_code == "AM001S") %>% 
  mutate(total = chinook_salmon + largemouth_bass, .after = "date")

seine %>% filter(date == "1976-05-28" & station_code == "AM001S") %>% 
  mutate(total = sum(chinook_salmon:largemouth_bass), .after = "date")

seine %>% filter(date == "1976-05-28" & station_code == "AM001S") %>% 
  mutate(total = sum(8:9), .after = "date")

temp2 <-
  seine %>% filter(date == "1976-05-28" & station_code == "AM001S") %>% 
  select(c(3, 4, 8:10)) %>% 
  print()

temp2 %>% mutate(total = chinook_salmon + largemouth_bass + western_mosquitofish)
# yes!
temp2 %>% mutate(total = sum(3:5))
# no!
temp2 %>% mutate(total = sum(chinook_salmon:western_mosquitofish))
# no!

temp2 %>% 
  mutate(total = rowSums(across(3:5)))
temp2 %>% 
  rowwise() %>% 
  mutate(total = sum(c_across(3:5), na.rm = TRUE)) %>% 
  ungroup()

# model df -----
# includes 2 stations, 3 dates, multiple spp, 'sample'=unique station.by.date
df <- 
  tibble(station_code = c(rep("AM001S", 4), rep("SB001M", 4)),
       date = ymd(c(rep("1976-05-28", 5), "1976-06-01", "1976-06-02", "1977-06-02")),
       water_temp = as.numeric(c(rep(20.6, 5), "NA", 21.1, 21.1)),
       common_name = c("chinook_salmon", rep("largemouth_bass", 3), "western_mosquitofish", 
                       "no_catch",
                       "chinook_salmon", "western_mosquitofish"),
       count = as.integer(c(rep(1, 5), "NA", 2, 3))
       ) %>% 
  mutate(sample = paste0(station_code, sep="_", date)) %>% 
  print()

df %>% pivot_wider(names_from = common_name, 
                   values_from = count,
                   values_fn = sum,
                   values_fill = 0) %>% 
  select(c(1,2,5:8))
  
df2 <-
  df %>%
  group_by(sample, date, station_code) %>%
  summarise(
      effort = n_distinct(sample), # should equal 1
      .groups = "drop"
    ) %>% 
  # add year bc want to organize by year?
  mutate(year = year(date)) %>% 
  print()

# effort = number of times annually in df a site has been sampled
df2 %>% group_by(station_code) %>% summarise(effort = sum(effort))

# effort ----

# calc the number of seine hauls at each site for each year
effort <-
  seine_long %>% 
  group_by(station_code, year = year(date)) %>% 
  summarise(seine_hauls = n_distinct(station_code, date))


df3 <-
  seine_long %>% 
  mutate(sample = paste0(station_code, sep = "_", date)) %>% 
  group_by(sample, date, station_code) %>% 
  summarise(
    effort = n_distinct(sample),
    .groups = "drop"
  ) %>% 
  mutate(year = year(date)) %>% 
  group_by(station_code, year) %>% 
  summarise(effort = sum(effort)) %>% 
  print()

df3 %>% filter(station_code == "AM001S") %>% 
  ggplot(aes(x = year, y = effort)) +
  geom_point() +
  theme_bw()
df3 %>% filter(station_code == "SR043W") %>% 
  ggplot(aes(x = year, y = effort)) +
  geom_point() +
  theme_bw()

ggplot(df3,
       aes(x = year, y = effort, fill = station_code)) +
  geom_bar(position = "stack", stat = "identity") +
  theme_bw()

# looking at df3, let's see what 'effort' looks like for station AM001S in 1976
# total effort should be 6 (unique seine hauls)
seine_long %>% 
  filter(station_code == "AM001S" & year(date) == "1976")
# excellent! 
# for another check, let's try XC001N in 2021 (effort should be 8)
seine_long %>% 
  filter(station_code == "XC001N" & year(date) == "2021") %>% 
  summarise(unique_events = n_distinct(date))

seine_long %>% 
  filter(station_code == "XC001N" & year(date) == "2021") %>% 
  distinct(date)


  mutate(month = month(date),
         day = day(date)) %>% 
  n_distinct(date)

df %>% summarize(unique_count = n_distinct(date))

# date.by.station ----
head(seine_all_var)
temp <-
  seine_all_var %>% group_by(station_code, date) %>% 
  mutate(sample = paste0(station_code, date)) %>% 
  relocate(sample, .before = station_code) %>% 
  select(sample, date, station_code, region_code, water_temp, common_name, count) %>% 
  mutate(year = year(date), .after = sample) %>% 
  print()

# pivot wide ----
# nope!
temp[1:20,] %>% 
  pivot_wider(#id_cols = sample,
              names_from = common_name,
              values_from = count,
              values_fn = sum,
              values_fill = 0) %>% 
  clean_names()

df <- temp %>% group_by(station_code, year) %>% summarise(n = n()) %>% print()

df %>% group_by(station_code) %>% summarise(n = n()) %>% print(n=Inf)

ggplot(df,
       aes(x = station_code, y = n, fill = year)) +
  geom_bar(position = "stack", stat = "identity") +
  theme_bw()

ggplot(df,
       aes(x = year, y = n, fill = station_code)) +
  geom_bar(position = "stack", stat = "identity") +
  theme_bw()

temp %>% group_by(station_code, year, sample) %>% summarise(n = n()) %>% 
  group_by(station_code) %>% summarise(n_seines = n()) %>% print(n = Inf)

# pivot real data -----
seine <-
  seine_long %>% 
  pivot_wider(id_cols = c(station_code:specific_conductance),
              names_from = common_name,
              names_sort = TRUE,
              values_from = count,
              values_fn = sum,
              values_fill = 0) %>% 
  clean_names() %>% 
  arrange(station_code, date) %>% 
  print()


view(test[1:4,])

test %>% 
  rowSums() %>% 
  mutate(total = across('American Shad':'Yellowfin Goby', sum))

# model df -----
df <-
  tibble(station = c(rep("A", 4), "B", "B", "A", "A", "B"),
       year = as.integer(c(rep("1976", 6), rep("1977", 3))),
       fish = c("salmon", rep("bass", 3), "salmon", "crappie", "crappie", "bass", "bass"),
       count = c(1, 2, rep(1,7)))
pivot_wider(df, 
            names_from = fish, 
            names_sort = TRUE, 
            values_from = count, 
            values_fn = sum, 
            values_fill = 0)
