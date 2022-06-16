################################################################################
# Filename: 03-final-demographics.R                                            #
# Path: ./src/03-final-demographics.R                                          #
# Author: Steven Macapagal                                                     #
# Date created: 2022-06-13                                                     #
# Date modified: 2022-06-16                                                    #
# Purpose: This script gets demographics of survey takers and attendees.       #
# Inputs: df_all_cr_survey_takers, df_all_cr_attendees                         #
# Outputs: list_demog_survey_takers, list_demog_attendees,                     #
#           df_demog_survey_takers, df_demog_attendees                         #
# Notes:                                                                       #
################################################################################

# list of group_by variables ---------------------------------------------------

group_by_vars <- c("Gender", "SPED", "AtRisk", "ECD", "LEP", "RISEcode", "Race")


# create list of demographics of survey takers ---------------------------------

list_demog_survey_takers <- list()

for (i in 1:length(group_by_vars)) {
  
  list_demog_survey_takers[[i]] <- df_all_cr_survey_takers %>% tabyl(group_by_vars[i])
  
}


# create list of demographics of attendees -------------------------------------

list_demog_attendees <- list()

for (j in 1:length(group_by_vars)) {
  
  list_demog_attendees[[j]] <- df_all_cr_attendees %>% tabyl(group_by_vars[j])
  
}

  
df_demog_survey_takers <- list_demog_survey_takers[[1]] %>%
  bind_rows(list_demog_survey_takers[[2]] %>% filter(SPED == 1)) %>%
  bind_rows(list_demog_survey_takers[[3]] %>% filter(AtRisk == 1)) %>%
  bind_rows(list_demog_survey_takers[[4]] %>% filter(ECD == 1)) %>%
  bind_rows(list_demog_survey_takers[[5]] %>% filter(LEP == 1)) %>%
  bind_rows(list_demog_survey_takers[[6]] %>% filter(RISEcode == 1)) %>%
  bind_rows(list_demog_survey_takers[[7]]) %>%
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


df_demog_attendees <- list_demog_attendees[[1]] %>%
  bind_rows(list_demog_attendees[[2]] %>% filter(SPED == 1)) %>%
  bind_rows(list_demog_attendees[[3]] %>% filter(AtRisk == 1)) %>%
  bind_rows(list_demog_attendees[[4]] %>% filter(ECD == 1)) %>%
  bind_rows(list_demog_attendees[[5]] %>% filter(LEP == 1)) %>%
  bind_rows(list_demog_attendees[[6]] %>% filter(RISEcode == 1)) %>%
  bind_rows(list_demog_attendees[[7]]) %>%
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
         valid_percent)
