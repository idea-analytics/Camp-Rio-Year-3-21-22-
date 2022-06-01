################################################################################
# Filename: 04-get-ap-data.R                                                   #
# Path: ./data/04-get-ap-data.R                                                #
# Author: Mishan Jensen                                                        #
# Date created: 2022-06-01                                                     #
# Date modified: 2022-06-01                                                    #
# Purpose: This retrieves the AP Data that is avaialble on the RnA server.     #
# Inputs: [791150-HQVRA].[Dashboard].[dbo].[APResult]                          #
#         [791150-HQVRA].[Dashboard].[dbo].[APCode]                            #
# Outputs: ap_results_codes                                                    #
# Notes: note that the current process is to manually donwload the file from   #
#       scores.collegeboard.com and then Edison processes the file with two    #
#       C# scripts and loads it into                                           #
################################################################################


# Get AP results
ap_result_conn_current_year <- get_table(.table_name = "APResult", .database_name = "Dashboard", .schema = "dbo", .server_name = "791150-HQVRA") %>% 
  filter(BestScore == "TRUE", SchoolYear == "2020-2021") %>% 
  select(StudentNumberDelta, ExamCode, AP_Result =  ExamGrade, AdminYear, GradeLevel, BestScore)

ap_result_conn_last_year <- get_table(.table_name = "APResult", .database_name = "Dashboard", .schema = "dbo", .server_name = "791150-HQVRA") %>% 
  filter(SchoolYear != "2020-2021") %>% 
  group_by(StudentNumberDelta, ExamCode, AdminYear, GradeLevel) %>% 
  summarize(AP_Result = max(ExamGrade)) %>% 
  mutate(BestScore = "TRUE") %>% 
  select(StudentNumberDelta, ExamCode, AP_Result, AdminYear, GradeLevel)

ap_result_conn_all_prior_year <- get_table(.table_name = "APResult", .database_name = "Dashboard", .schema = "dbo", .server_name = "791150-HQVRA") %>% 
  filter(SchoolYear != "2020-2021" | SchoolYear != "2019-2020") %>% 
  group_by(StudentNumberDelta, ExamCode, AdminYear, GradeLevel) %>% 
  summarize(AP_Result = max(ExamGrade)) %>% 
  mutate(BestScore = "TRUE") %>% 
  select(StudentNumberDelta, ExamCode, AP_Result, AdminYear, GradeLevel)


ap_result_conn <- ap_result_conn_current_year %>%
  union_all(ap_result_conn_last_year) %>%
  union_all(ap_result_conn_all_prior_year) 

# Get AP exam codes
ap_code_conn <- get_table(.table_name = "APCode", .database_name = "Dashboard", .schema = "dbo", .server_name = "791150-HQVRA") %>% 
  select(ExamCode, ExamName)

glimpse(ap_code_conn)

# Join and light munging 
ap_results_codes <- ap_result_conn %>%
  left_join(ap_code_conn, by = "ExamCode") %>%
  #filter(!(GradeLevel %in% c('Unknown','< 9','Not in High School'))) %>% 
  collect()  %>%   
  mutate(AcademicYear = glue::glue('20{as.integer(AdminYear)-1}-20{AdminYear}'),
         AcademicYear = if_else(AcademicYear==as.character('209-2010'), 
                                as.character('2009-2010'), 
                                as.character(AcademicYear)),
         TookTest = 1)


