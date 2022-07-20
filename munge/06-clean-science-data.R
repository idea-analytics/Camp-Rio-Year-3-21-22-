################################################################################
# Filename: 06-clean-science-data.R                                            #
# Path: munge/06-clean-science-data.R                                          #
# Author: Steven Macapagal                                                     #
# Date created: 2022-07-07                                                     #
# Date modified: 2022-07-11                                                    #
# Purpose: This script cleans science historical grades.                       #
# Inputs:                                                                      #
# Outputs:                                                                     #
# Notes:                                                                       #
################################################################################



df_science_grades_attendees <- df_all_cr_attendees %>%
  left_join(raw_science_grades,
            by = c("StudentNumber" = "StudentNumber"))



df_science_grades_survey_takers <- df_all_cr_survey_takers %>%
  left_join(raw_science_grades,
            by = c("StudentNumber" = "StudentNumber"))
