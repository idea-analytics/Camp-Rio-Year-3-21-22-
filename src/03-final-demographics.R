
counts <- list(
  df_all_cr_survey_takers %>% tabyl(Gender),
  df_all_cr_survey_takers %>% tabyl(SPED),
  df_all_cr_survey_takers %>% tabyl(AtRisk),
  df_all_cr_survey_takers %>% tabyl(ECD),
  df_all_cr_survey_takers %>% tabyl(LEP),
  df_all_cr_survey_takers %>% tabyl(RISEcode),
  df_all_cr_survey_takers %>% tabyl(Race),
  df_all_cr_attendees %>% tabyl(Gender),
  df_all_cr_attendees %>% tabyl(SPED),
  df_all_cr_attendees %>% tabyl(AtRisk),
  df_all_cr_attendees %>% tabyl(ECD),
  df_all_cr_attendees %>% tabyl(LEP),
  df_all_cr_attendees %>% tabyl(RISEcode),
  df_all_cr_attendees %>% tabyl(Race),
)
  
df_survey_counts <- counts[[1]] %>%
  bind_rows(counts[[2]] %>% filter(SPED == 1)) %>%
  bind_rows(counts[[3]] %>% filter(AtRisk == 1)) %>%
  bind_rows(counts[[4]] %>% filter(ECD == 1)) %>%
  bind_rows(counts[[5]] %>% filter(LEP == 1)) %>%
  bind_rows(counts[[6]] %>% filter(RISEcode == 1)) %>%
  bind_rows(counts[[7]]) %>%
  mutate(across(AtRisk:RISEcode, as.character)) %>%
  as_tibble() %>%
  mutate(category = c(
    "Female",
    "Male",
    "SPED",
    "At Risk",
    "Eco Dis",
    "EL",
    "RISE",
    "Asian",
    "Black",
    "Hispanic",
    "Other",
    "White"
  )) %>%
  select(category,
         n,
         percent)


df_attendees_counts <- counts[[8]] %>%
  bind_rows(counts[[9]] %>% filter(SPED == 1)) %>%
  bind_rows(counts[[10]] %>% filter(AtRisk == 1)) %>%
  bind_rows(counts[[11]] %>% filter(ECD == 1)) %>%
  bind_rows(counts[[12]] %>% filter(LEP == 1)) %>%
  bind_rows(counts[[13]] %>% filter(RISEcode == 1)) %>%
  bind_rows(counts[[14]]) %>%
  mutate(across(AtRisk:RISEcode, as.character)) %>%
  as_tibble() %>%
  mutate(category = c(
    "Female",
    "Male",
    "SPED",
    "At Risk",
    "Eco Dis",
    "EL",
    "RISE",
    "Asian",
    "Black",
    "Hispanic",
    "Other",
    "White"
  )) %>%
  select(category,
         n,
         percent)
