################################################################################
# Filename: 01-clean-act-data.R                                                #
# Path: ./munge/01-clean-act-data.R                                            #
# Author: Steven Macapagal                                                     #
# Date created: 2022-06-06                                                     #
# Date modified: 2022-06-06                                                    #
# Purpose: This script cleans ACT data and joins with the student table.       #
# Inputs: raw_act                                                              #
# Outputs: list_act_students, df_act                                           #
# Notes:                                                                       #
################################################################################


list_act_students <- raw_act %>%
  pull(hs_student_id)


clean_act <- raw_act %>%
  filter(test_type == "ACT") %>%
  
  # this step is used to convert the test_date column into a consistent
  # yyyy-mm-dd format. raw data in test_date are in one of three character forms:
  # (1) days since origin in Excel
  # (2) yyyy-mm-00
  # (3) 0000-00-00
  mutate(# remove -00 for case (3),
         test_date = str_replace(test_date, "-00", ""),
         # separate cases (1) and (2) into separate columns
         test_date_char = if_else(str_detect(test_date, "-"), 
                                  test_date, 
                                  as.character(NA)),
         test_date_num = if_else(str_detect(test_date, "-", negate = TRUE), 
                                 as.numeric(test_date), 
                                 as.numeric(NA)),
         # convert cases (1) and (2) into yyyy-mm-dd
         test_date_char = ym(test_date_char),
         test_date_num = excel_numeric_to_date(test_date_num),
         # pull all dates back into one column
         test_date = coalesce(test_date_char, 
                              test_date_num)) %>%
  
  # fix science column
  mutate(science = as.numeric(science)) %>%

  # join with students table
  left_join(get_students() %>%
              filter(AcademicYear == "2021-2022",
                     RowIsCurrent == 1,
                     StudentNumber %in% list_act_students) %>%
              select(StudentNumber,
                     SchoolNumber,
                     GradeLevelID) %>%
              collect(),
            by = c("hs_student_id" = "StudentNumber")) %>%
  clean_names() %>%
  arrange(idea_campus,
          class_year,
          grade_level_id,
          full_name,
          test_date) %>%
  select(idea_campus,
         school_number,
         full_name,
         hs_student_id,
         class_year,
         grade_level_id,
         current_highest_act,
         test_date,
         composite,
         science) 

df_act_attendees <- df_all_cr_attendees %>%
  left_join(clean_act,
            by = c("StudentNumber" = "hs_student_id")) %>%
  clean_names()
  
  
df_act_survey_takers <- df_all_cr_survey_takers %>%
  left_join(clean_act,
            by = c("Student_Number" = "hs_student_id")) %>%
  clean_names()
