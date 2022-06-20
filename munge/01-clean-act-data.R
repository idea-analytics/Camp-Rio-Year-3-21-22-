################################################################################
# Filename: 01-clean-act-data.R                                                #
# Path: ./munge/01-clean-act-data.R                                            #
# Author: Steven Macapagal                                                     #
# Date created: 2022-06-06                                                     #
# Date modified: 2022-06-20                                                    #
# Purpose: This script cleans ACT data and joins with the student table.       #
# Inputs: raw_act                                                              #
# Outputs: list_act_students, df_act                                           #
# Notes:                                                                       #
################################################################################


list_act_students <- raw_act %>%
  pull(HsStudentId)


# clean_act <- raw_act %>%
#   filter(TestType == "ACT") %>%
#   
#   # this step is used to convert the test_date column into a consistent
#   # yyyy-mm-dd format. raw data in test_date are in one of three character forms:
#   # (1) days since origin in Excel
#   # (2) yyyy-mm-00
#   # (3) 0000-00-00
#   mutate(# remove -00 for case (3),
#          TestDate = str_replace(TestDate, "-00", ""),
#          # separate cases (1) and (2) into separate columns
#          test_date_char = if_else(str_detect(TestDate, "-"), 
#                                   TestDate, 
#                                   as.character(NA)),
#          test_date_num = if_else(str_detect(TestDate, "-", negate = TRUE), 
#                                  as.numeric(TestDate), 
#                                  as.numeric(NA)),
#          # convert cases (1) and (2) into yyyy-mm-dd
#          test_date_char = ym(test_date_char),
#          test_date_num = excel_numeric_to_date(test_date_num),
#          # pull all dates back into one column
#          TestDate = coalesce(test_date_char, 
#                               test_date_num)) %>%
#   
#   # fix science column
#   mutate(Science = as.numeric(Science)) %>%
# 
#   # join with students table
#   left_join(get_students() %>%
#               filter(AcademicYear == "2021-2022",
#                      RowIsCurrent == 1,
#                      StudentNumber %in% list_act_students) %>%
#               select(StudentNumber,
#                      SchoolNumber,
#                      GradeLevelID) %>%
#               collect(),
#             by = c("HsStudentId" = "StudentNumber")) %>%
#   arrange(IdeaCampus,
#           ClassYear,
#           GradeLevelID,
#           FullName,
#           TestDate) %>%
#   select(IdeaCampus,
#          SchoolNumber,
#          FullName,
#          HsStudentId,
#          ClassYear,
#          GradeLevelID,
#          CurrentHighestAct,
#          TestDate,
#          Composite,
#          Science) 


df_act <- raw_act %>%
  filter(TestType == "ACT") %>%
  
  # this step is used to convert the TestDate column into a consistent
  # yyyy-mm-dd format. raw data in test_date are in one of two character forms:
  # (1) yyyy-mm-00 or yyyy-mm-dd
  # (2) 0000-00-00
  mutate(TestDate = str_replace(TestDate, "-00", "-01"), # forces all (1) cases to have a day
         TestDate = ymd(TestDate)) %>%
  
  # fix science column
  mutate(English = as.numeric(English),
         Math = as.numeric(Math),
         Reading = as.numeric(Reading),
         Science = as.numeric(Science),
         Writing = as.numeric(Writing),
         Ela = as.numeric(Ela),
         Stem = as.numeric(Stem),
         Composite = as.numeric(Composite),
         GradeLevelTaken = as.numeric(str_trim(GradeLevel))) %>%
  select(StudentNumber = HsStudentId,
         FirstName,
         MiddleName,
         LastName,
         ClassYear,
         GradeLevelTaken,
         TestType,
         English,
         Math,
         Reading,
         Science,
         Writing,
         Ela,
         Stem,
         Composite,
         TestDate)
  

df_act_attendees <- df_all_cr_attendees %>%
  left_join(df_act,
            by = c("StudentNumber" = "StudentNumber"))
  
  
df_act_survey_takers <- df_all_cr_survey_takers %>%
  left_join(df_act,
            by = c("StudentNumber" = "StudentNumber"))

