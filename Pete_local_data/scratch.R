

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
  
df %>%
  group_by(sample, date, station_code) %>%
  summarise(
      effort = n_distinct(sample),
      .groups = "drop"
    ) %>% 
  mutate(year = year(date))

df %>% pivot_wider(names_from = common_name,
                   values_from = count,
                   values_fn = sum,
                   values_fill = 0)


head(seine_all_var)
temp <-
  seine_all_var %>% group_by(station_code, date) %>% 
  mutate(sample = paste0(station_code, date)) %>% 
  relocate(sample, .before = station_code) %>% 
  select(sample, date, station_code, region_code, water_temp, common_name, count) %>% 
  mutate(year = year(date), .after = sample) %>% 
  print()



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

