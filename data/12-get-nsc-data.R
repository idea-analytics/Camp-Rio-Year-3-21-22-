################################################################################
# Filename: 12-get-nsc-data.R                                                  #
# Path: data/12-get-nsc-data.R                                                 #
# Author: Steven Macapagal                                                     #
# Date created: 2022-06-20                                                     #
# Date modified: 2022-07-12                                                    #
# Purpose: This script pulls in NSC data.                                      #
# Inputs:                                                                      #
# Outputs:                                                                     #
# Notes:                                                                       #
################################################################################


raw_nsc <- read_csv(here::here("data", "NSC-data-2022-06-09.csv")) %>%
  clean_names("upper_camel")


xlsx_survey_cp_20_21 <- readxl::read_xlsx(here::here("data", "Camp RIO Survey - Video - College Prep. 2021.5.25.LFK.xlsx")) %>%
  clean_names("upper_camel") %>%
  rename(StudentNumber = PleaseEnterYourStudentNumber) %>%
  mutate(StudentNumber = as.numeric(StudentNumber),
         Surveyed = 1)


xlsx_schools_20_21 <- readxl::read_xlsx(here::here("docs", "02-camp-rio-schools.xlsx"),
                                        sheet = "2020-2021") %>%
  clean_names("upper_camel") %>%
  mutate(SeniorInPerson = if_else(str_detect(Grade, "12"), 1, 0)) %>%
  filter(SeniorInPerson == 1)


list_seniors_schools_20_21 <- xlsx_schools_20_21 %>%
  mutate(School = if_else(School == "Wes Pike", "Weslaco Pike", School)) %>%
  pull(School)
