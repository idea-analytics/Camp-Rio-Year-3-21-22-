################################################################################
# Filename: 02-get-science-grades-data.R                                       #
# Path: ./data/02-get-science-grades-data.R                                    #
# Author: Mishan Jensen                                                        #
# Date created: 2022-06-01                                                     #
# Date modified: 2022-06-01                                                    #
# Purpose: This script pulls in STAAR scores.                                  #
# Inputs:                                                                      #
# Outputs:                                                                     #
# Notes: Used code from the R&A manual.                                        #
################################################################################


STAAR <- get_table(.table_name = "STAAR", 
                   .database_name = "Dashboard", 
                   .schema = "dbo", 
                   .server_name = "RGVPDRA-DASQL") %>%
  filter(TestVersion == "S", 
         ScoreCode == "S", 
         SubjectCode == "Math",
         AdminDate %in% c("0421", "0521")) %>%
  select(StudentID,
         LocalStudentID,
         GradeLevel,
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
  select(-StudentID, -LocalStudentID, -ScoreCode) %>%
  group_by(StudentNumber) %>%
  distinct() %>%
  collect()

# To get a count of distinct student numbers to see how much duplication exists
Count_stus <- STAAR %>%
  distinct(StudentNumber)

# Getting max score to de-duplicate
staar_math <- STAAR %>%
  group_by(StudentNumber) %>%
  mutate(Best_score = max(ScaleScore),
         BestScoreFlag = if_else(Best_score == ScaleScore, 1, 0)) %>%
  filter(BestScoreFlag == 1) %>%
  select(-BestScoreFlag, -Best_score, -AdminDate, -ScaleScore, -GradeLevel) %>%
  distinct()

# Calculating the % Approaches and the % Masters
pct_apprhs_mstrs <- staar_math %>%
  select(Approaches, Masters) %>%
  summarize(n_students = n(),
            n_apprchs = sum(Approaches),
            n_mstrs = sum(Masters)) %>%
  mutate(pct_app = n_apprchs/n_students,
         pct_mst = n_mstrs/n_students)