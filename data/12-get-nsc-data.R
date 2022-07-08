################################################################################
# Filename: 12-get-nsc-data.R                                                  #
# Path: data/12-get-nsc-data.R                                                 #
# Author: Steven Macapagal                                                     #
# Date created: 2022-06-20                                                     #
# Date modified: 2022-06-22                                                    #
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
