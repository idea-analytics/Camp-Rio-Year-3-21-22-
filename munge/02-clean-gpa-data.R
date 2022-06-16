################################################################################
# Filename: 02-clean-gpa-data.R                                                #
# Path: ./munge/02-clean-gpa-data.R                                            #
# Author: Steven Macapagal                                                     #
# Date created: 2022-06-14                                                     #
# Date modified: 2022-06-14                                                    #
# Purpose: This script cleans GPA data and joins to the students table.        #
# Inputs: raw_gpa                                                              #
# Outputs: df_gpa_all_attendees, df_gpa_survey_takers                          #
# Notes:                                                                       #
################################################################################


df_gpa_attendees <- df_all_cr_attendees %>%
  filter(Grade %in% c(9, 10, 11, 12)) %>%
  left_join(raw_gpa %>% 
              select(StudentNumber,
                     GradeLevelID,
                     CumulativeGPA),
            by = c("StudentNumber" = "StudentNumber"))


df_gpa_survey_takers <- df_all_cr_survey_takers %>%
  filter(GradeLevelID %in% c(9, 10, 11, 12)) %>%
  left_join(raw_gpa %>% 
              select(StudentNumber,
                     GradeLevelID,
                     CumulativeGPA),
            by = c("Student_Number" = "StudentNumber"))
