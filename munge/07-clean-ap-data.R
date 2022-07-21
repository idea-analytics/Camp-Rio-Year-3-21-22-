################################################################################
# Filename: 07-clean-ap-data.R                                                 #
# Path: munge/07-clean-ap-data.R                                               #
# Author: Mishan Jensen, Steven Macapagal                                      #
# Date created: 2022-07-19                                                     #
# Date modified: 2022-07-19                                                    #
# Purpose: This cleans AP data, joins with all students and CR rosters.        #
# Inputs: ap_results_code                                                      #
# Outputs: ap_full, ap_df                                                      #
# Notes:                                                                       #
################################################################################


# double check we are getting the best scores, filter out NA students, clean names
ap_data <- ap_results_codes %>% 
  group_by(StudentNumberDelta,
           ExamCode, 
           ExamName, 
           AdminYear,
           AcademicYear,
           TookTest) %>% 
  summarize(AP_Result = max(APResult, na.rm=TRUE)) %>%
  mutate(AP_Result = as.numeric(AP_Result)) %>%
  distinct() %>% 
  # filter(!is.na(ap_file_path)) %>% 
  # janitor::clean_names() %>% 
  ungroup() %>%
  rename(StudentNumber = StudentNumberDelta) %>%
  filter(AcademicYear == "2021-2022")


df_ap_attendees <- df_all_cr_attendees %>%
  left_join(ap_data,
            by = c("StudentNumber" = "StudentNumber"))


df_ap_survey_takers <- df_all_cr_survey_takers %>%
  left_join(ap_data,
            by = c("StudentNumber" = "StudentNumber"))

# cache("ap_data")


# # Joining Enrolled Students with Tested Students ----
# 
# # Collect all distinct student numbers from all years
# stu_scaffold <- ap_data %>% 
#   ungroup() %>% 
#   select(student_number = student_number_delta,
#          academic_year) %>%
#   bind_rows(students_df %>% 
#               ungroup() %>%  
#               select(student_number, academic_year) )%>%
#   arrange(student_number, academic_year) %>% 
#   distinct()
# 
# 
# # Scaffold admin years
# admin_year_scaffold <- tibble(
#   academic_year = sprintf("%s-%s", 2009:2020, 2010:2021)) %>% 
#   mutate(admin_year = as.integer(str_extract(academic_year, regex("\\d{2}$")))-9)
# 
# 
# # list of IB Schools 
# ib_exception_schools <- c("Donna", # just works IB, offer very few APS
#                           "South Flores", # not trying to hit AP goal
#                           "Brownsville",  # include if it helps this year. Should be included in 21-22
#                           "Frontier"      # try hit AP Goal in 20-21
# ) 
# 
# 
# # use studnet scaffold to ensure we are tracking all studunts, and not just 
# # students who tested
# ap_full <- stu_scaffold %>% 
#   left_join(students_df, by = c("student_number", "academic_year")) %>% 
#   left_join(ap_data, by = c("student_number" = "student_number_delta",
#                             "academic_year" = "academic_year")) %>%
#   select(student_number,
#          academic_year,
#          admin_year,
#          school_name, 
#          region,
#          grade_level_id,
#          took_test,
#          ap_result,
#          exam_name,
#          enrollment_status,
#          graduate,
#          race,
#          sped,
#          at_risk,
#          ecd,
#          lep
#   ) %>% 
#   # last check on max exam results
#   mutate(ap_result = as.integer(ap_result)) %>%
#   group_by(student_number
#            ,academic_year
#            ,admin_year
#            ,school_name
#            ,region
#            ,grade_level_id
#            ,enrollment_status
#            ,graduate
#            ,took_test
#            ,exam_name 
#            ,race
#            ,sped
#            ,at_risk
#            ,ecd
#            ,lep) %>% 
#   summarise(ap_result = max(ap_result)) %>% 
#   distinct() %>%
#   
#   # this next set of steps ensures that every student who didn't take the test
#   # has an admin_year, since that data came from the College Board data
#   left_join(admin_year_scaffold, by = "academic_year") %>%
#   select(-admin_year.x) %>% 
#   rename(admin_year = admin_year.y) %>% 
#   mutate(took_test = if_else(is.na(took_test), 0, 1),
#          
#          #this school name renaming seems unneccesary
#          school_name = if_else(is.na(school_name), "Placeholder", school_name)) %>% 
#   
#   # need to indicate if score sim from a student at IB focused campuses
#   mutate(ib_school = school_name %in% ib_exception_schools)
# 
# 
# # Exam group scaffold -----
# 
# # order matters here since it needs to match the grades in which these are 
# # generally taught
# exams_vector <- c("Spanish Language and Culture",
#                   "World History",
#                   "Human Geography",
#                   "Physics 1",
#                   "United States Government and Politics",
#                   "English Language and Composition",
#                   "United States History",
#                   "Biology",
#                   "English Literature and Composition",
#                   "Microeconomics",
#                   "Calculus AB",
#                   "Chemistry",
#                   "Spanish Literature and Culture",
#                   "Statistics",
#                   "Environmental Science")
# 
# # so roder matters here too 
# grade_level_vector <- c(11,10,9,12,12,11,11,12,12,12,12,12,12,12,12)
# 
# 
# exams_df <- tibble(exam_name = exams_vector,
#                    grade_level_id = grade_level_vector) %>%
#   mutate(concat =  paste(exam_name, grade_level_id),
#          ones = 1, # I kinda hate this
#          ap_group = case_when(
#            str_detect(exam_name, "Bio|Chem|Environ|Physics") ~ "Science",
#            str_detect(exam_name, "World|Human|Microeconomics|United States") ~ "Humanities",
#            str_detect(exam_name, "Calculus AB|Statistics") ~ "Math",
#            str_detect(exam_name, "Spanish") ~ "Spanish",
#            str_detect(exam_name, "English") ~ "English",
#            TRUE ~ "Other"
#          ))
# 
# 
# 
# ap_df <- ap_full %>% 
#   left_join(exams_df %>% select(exam_name, ap_group),
#             by = c("exam_name" = "exam_name")) %>%
#   mutate(ap_group = if_else(is.na(ap_group), "Other", ap_group),
#          ap_group = if_else(!is.na(exam_name), ap_group, as.character(NA))) %>% 
#   ungroup() %>% 
#   arrange(student_number, academic_year, exam_name) %>% 
#   group_by(student_number) %>% 
#   mutate(passed = ap_result >= 3,
#          cum_passed = cumsum(replace_na(as.integer(passed), 0))) %>% 
#   ungroup() %>% 
#   filter(!is.na(student_number))
# 
# 
# cache("ap_df")

