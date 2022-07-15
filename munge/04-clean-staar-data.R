################################################################################
# Filename: 03-clean-staar-data.R                                              #
# Path: munge/03-clean-staar-data.R                                            #
# Author: Mishan Jensen, Steven Macapagal                                      #
# Date created: 2022-06-20                                                     #
# Date modified: 2022-06-22                                                    #
# Purpose: This script deduplicates STAAR science scores.                      #
# Inputs:                                                                      #
# Outputs:                                                                     #
# Notes: Used code from the R&A manual.                                        #
################################################################################


# To get a count of distinct student numbers to see how much duplication exists
count_students <- raw_staar %>%
  distinct(StudentNumber)

# Getting max score to de-duplicate
df_staar_science <- raw_staar %>%
  group_by(StudentNumber,
           SubjectCode) %>%
  mutate(GradeLevelID = as.numeric(GradeLevelID),
         Best_score = max(ScaleScore),
         BestScoreFlag = if_else(Best_score == ScaleScore, 1, 0),
         Approaches = as.numeric(Approaches),
         Meets = as.numeric(Meets),
         Masters = as.numeric(Masters)) %>%
  filter(BestScoreFlag == 1) %>%
  select(-BestScoreFlag,
         -Best_score,
         -AdminDate) %>%
  relocate(StudentNumber) %>%
  distinct()


# join with students tables ----------------------------------------------------

df_staar_science_attendees <- df_all_cr_attendees %>%
  left_join(df_staar_science,
            by = c("StudentNumber" = "StudentNumber"))

df_staar_science_survey_takers <- df_all_cr_survey_takers %>%
  left_join(df_staar_science,
            by = c("StudentNumber" = "StudentNumber"))

