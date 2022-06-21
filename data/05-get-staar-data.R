################################################################################
# Filename: 05-get-staar-data.R                                                #
# Path: ./data/05-get-staar-data.R                                             #
# Author: Mishan Jensen                                                        #
# Date created: 2022-06-01                                                     #
# Date modified: 2022-06-21                                                    #
# Purpose: This script pulls in STAAR scores.                                  #
# Inputs:                                                                      #
# Outputs:                                                                     #
# Notes: Used code from the R&A manual.                                        #
################################################################################


raw_staar <- get_table(.table_name = "STAAR",
                   .database_name = "Dashboard",
                   .schema = "dbo",
                   .server_name = "791150-HQVRA") %>%
                   # .server_name = "RGVPDRA-DASQL") %>%
  filter(TestVersion == "S",
         ScoreCode == "S",
         SubjectCode %in% c("Science", "Biology"),
         AdminDate %in% c("0422", "0522")) %>%
  select(StudentID,
         LocalStudentID,
         GradeLevelID = GradeLevel,
         SubjectCode,
         AdminDate,
         ScoreCode,
         ScaleScore,
         Approaches = LevelII,
         Meets = LevelIIFinal,
         Masters = LevelIII) %>%
  mutate(StudentID = as.numeric(StudentID),
         LocalStudentID = as.numeric(LocalStudentID),
         StudentNumber = if_else(LocalStudentID %in% c(0, NA), StudentID, LocalStudentID),
         StudentNumber = as.numeric(StudentNumber)) %>%
  filter(StudentNumber != 0) %>%
  select(-StudentID,
         -LocalStudentID,
         -ScoreCode) %>%
  group_by(StudentNumber,
           SubjectCode) %>%
  distinct() %>%
  collect()

