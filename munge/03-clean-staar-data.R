################################################################################
# Filename: 03-clean-staar-data.R                                              #
# Path: munge/03-clean-staar-data.R                                            #
# Author: Mishan Jensen                                                        #
# Date created: 2022-06-20                                                     #
# Date modified: 2022-06-20                                                    #
# Purpose: This script deduplicates STAAR science scores.                      #
# Inputs:                                                                      #
# Outputs:                                                                     #
# Notes: Used code from the R&A manual.                                        #
################################################################################


# To get a count of distinct student numbers to see how much duplication exists
# count_students <- raw_staar %>%
#   distinct(StudentNumber)
# 
# Getting max score to de-duplicate
# df_staar_science <- raw_staar %>%
#   group_by(StudentNumber,
#            SubjectCode) %>%
#   mutate(Best_score = max(ScaleScore),
#          BestScoreFlag = if_else(Best_score == ScaleScore, 1, 0)) %>%
#   filter(BestScoreFlag == 1) %>%
#   select(-BestScoreFlag, 
#          -Best_score, 
#          -AdminDate, 
#          -ScaleScore) %>%
#   distinct()
# 
# Calculating the % Approaches and the % Masters
# table_staar_science_dist <- df_staar_science %>%
#   select(SubjectCode,
#          GradeLevelID,
#          Approaches, 
#          Meets,
#          Masters) %>%
#   group_by(SubjectCode,
#            GradeLevelID) %>%
#   summarize(nStudents = n(),
#             nApproaches = sum(Approaches),
#             nMeets = sum(Meets),
#             nMasters = sum(Masters)) %>%
#   mutate(PercentApproaches = nApproaches/nStudents,
#          PercentMeets = nMeets/nStudents,
#          PercentMasters = nMasters/nStudents)