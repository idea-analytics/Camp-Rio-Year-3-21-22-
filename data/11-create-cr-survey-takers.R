################################################################################
# Filename: 11-create-cr-survey-takers.R                                       #
# Path: ./data/11-create-cr-survey-takers.R                                    #
# Author: Aline Orr                                                            #
# Date created: 2022-06-09                                                     #
# Date modified: 2022-06-22                                                    #
# Purpose: This script creates the main student and school data frames         #
#           for Camp Rio.                                                      #
# Inputs: ./data/Camp RIO groups 21-22.xlsx                                    #
#         Stu_demg                                                             #
# Outputs: df_all_cr_schools, df_all_cr_attendees                              #
# Notes:                                                                       #
################################################################################


# read in academy surveys and create academy df --------------------------------

CRA_2022b <- xlsx_survey_ac %>%
  select(CompletionTime = 'Completion time',
         Name,
         Student_Number = 'Please enter your Student ID number.',
         SchoolName = 'Which campus do you attend?',
         GradeLevel = 'Which grade are you currently in?',
         FullName = 'Please enter your first and last name.',
         CRDose = 'Before today, how many times have you visited Camp RIO?'
  ) %>%
  mutate(Student_Number = as.numeric(Student_Number),
         CompletionTime = as.character(CompletionTime),
         CompletionTime = as_date(CompletionTime))%>%
  separate(FullName, c('First_Name', 'Middle_Name', 'LastName'))

CRA_2022 <- CRA_2022b %>%
  mutate(Last_Name = if_else(is.na(LastName), Middle_Name, LastName),
         Middle_Initial = substr(Middle_Name, 1,2)) %>%
  select(-Middle_Name, -LastName)

CRA_campus_ID <- left_join(CRA_2022, Stu_demg, by=c("Student_Number"="StudentNumber"))%>%
  filter(SchoolNumber != " ")%>%
  select(-FirstName, -MiddleInitial, -LastName)
#write_csv(CRA_campus_ID,"data/Survey_files/CRA_surveydata_and_correct_campus.csv")

CRA_campus_name <- left_join(CRA_2022, Stu_demg, by=c("Last_Name"="LastName", 
                                                      "First_Name"="FirstName", 
                                                      "Middle_Initial" = "MiddleInitial"))%>%
  filter(SchoolNumber != " ")%>%
  select(-StudentNumber)

CRA_AllStudents <- bind_rows(CRA_campus_ID, CRA_campus_name) %>%
  mutate(row_number = row_number())

list_mismatched_ac <- CRA_AllStudents %>% 
  filter(GradeLevelID %in% c(6, 9, 11, 12)) %>% 
  pull(row_number)

# write.csv(CRA_AllStudents, "data/Survey_files/CRA_SurveyParticipants_CleanID.csv")


# read in college prep surveys and create college prep df ----------------------

CRCP_2022b <- xlsx_survey_cp %>%
  select(CompletionTime = 'Completion time',
         Name,
         Student_Number = 'Please enter your Student ID number.',
         SchoolName = 'Which campus do you attend?',
         GradeLevel = 'Which grade are you currently in?',
         FullName = 'Please enter your name.',
         CRDose = 'Before today, how many times have you visited Camp RIO?'
  )%>%
  mutate(Student_Number = as.numeric(Student_Number),
         CompletionTime = as.character(CompletionTime),
         CompletionTime = as_date(CompletionTime)) %>%
  separate(FullName, c('First_Name', 'Middle_Name', 'LastName'))

CRCP_2022 <- CRCP_2022b %>%
  mutate(Last_Name = if_else(is.na(LastName), Middle_Name, LastName),
         Middle_Initial = substr(Middle_Name, 1,2)) %>%
  select(-Middle_Name, -LastName)

CRCP_campus_ID <- left_join(CRCP_2022, Stu_demg, by=c("Student_Number"="StudentNumber"))%>%
  filter(SchoolNumber != " ")%>%
  select(-FirstName, -MiddleInitial, -LastName)
# write_csv(CRCP_campus_ID, "data/Survey_files/CRCP_surveydata_and_correct_campus.csv")

CRCP_campus_name <- left_join(CRCP_2022, Stu_demg, by=c("Last_Name"="LastName", "First_Name"="FirstName", "Middle_Initial"="MiddleInitial"))%>%
  filter(SchoolNumber != " ")%>%
  select(-StudentNumber)

#Std_demg <- read_csv("Student demographics.csv")%>%
# mutate(StudentNumber = as.character(StudentNumber))

CRCP_AllStudents <- bind_rows(CRCP_campus_ID, CRCP_campus_name) %>%
  mutate(row_number = row_number())
# write.csv(CRCP_AllStudents,"data/Survey_files/CRCP_SurveyParticipants_CleanID.csv")

list_mismatched_cp <- CRCP_AllStudents %>%
  filter(GradeLevelID %in% c(1, 2, 3)) %>%
  pull(row_number)


# create single df for all survey takers ---------------------------------------

df_all_cr_survey_takers <- CRA_AllStudents %>%
  mutate(SchoolType = "Academy") %>%
  union_all(CRCP_AllStudents %>%
              mutate(SchoolType = "College Prep")) %>%
  filter(if_else(SchoolType == "Academy",
                 !(row_number %in% list_mismatched_ac),
                 !(row_number %in% list_mismatched_cp))) %>%
  mutate(CRDoseGroup = fct_collapse(factor(CRDose),
                                    `0-2 Visits` = c("0", "1", "2"),
                                    `More Than 2 Visits` = c("3", "4", "5", "6", "7"))) %>%
  select(-Name,
         -row_number) %>%
  rename(StudentNumber = Student_Number,
         SchoolShortNameReported = SchoolName,
         GradeLevelIDReported = GradeLevel,
         FirstName = First_Name,
         LastName = Last_Name,
         MiddleInitial = Middle_Initial,
         RiseStudent = RISEcode)

