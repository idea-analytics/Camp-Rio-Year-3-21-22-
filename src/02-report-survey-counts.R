################################################################################
# Filename: 02-report-survey-counts.R                                          #
# Path: ./src/02-report-survey-counts.R                                        #
# Author: Aline Orr, Steven Macapagal                                          #
# Date created: 2022-06-07                                                     #
# Date modified: 2022-06-07                                                    #
# Purpose: This script uses survey data to compute counts and demographics     #
#           of Camp Rio attendees.                                             #
# Inputs:  xlsx_survey_ac, xlsx_survey_cp, Stu_demg                            #
# Outputs: CRA_2022b, CRA_2022, CRCP_2022b, CRCP_2022,                         #
#          CRA_campus_ID, CRA_campus_name, CRA_AllStudents,                    #
#          CRCP_campus_ID, CRCP_campus_name, CRCP_AllStudents,                 #
#          CRA_SummarizedbyDate, CRCP_SummarizedbyDate                         #
# Notes:                                                                       #
################################################################################


# clean, join academy students -------------------------------------------------

CRA_2022b <- xlsx_survey_ac %>%
  select(CompletionTime = 'Completion time',
         Name,
         Student_Number = 'Please enter your Student ID number.',
         SchoolName = 'Which campus do you attend?',
         GradeLevel = 'Which grade are you currently in?',
         FullName = 'Please enter your first and last name.') %>%
  mutate(Student_Number = as.numeric(Student_Number),
         CompletionTime = as.character(CompletionTime),
         CompletionTime = as_date(CompletionTime)) %>%
  separate(FullName, c('First_Name', 'Middle_Name', 'LastName'))

CRA_2022 <- CRA_2022b %>%
  mutate(Last_Name = if_else(is.na(LastName), Middle_Name, LastName),
         Middle_Initial = substr(Middle_Name, 1,2)) %>%
  select(-Middle_Name, -LastName)

CRA_campus_ID <- left_join(CRA_2022, Stu_demg, by=c("Student_Number"="StudentNumber")) %>%
  filter(SchoolNumber != " ") %>%
  select(-FirstName, -MiddleInitial, -LastName)
#write_csv(CRA_campus_ID,"data/Survey_files/CRA_surveydata_and_correct_campus.csv")

CRA_campus_name <- left_join(CRA_2022, Stu_demg, by=c("Last_Name"="LastName", "First_Name"="FirstName", "Middle_Initial"="MiddleInitial")) %>%
  filter(SchoolNumber != " ") %>%
  select(-StudentNumber)

CRA_AllStudents <- bind_rows(CRA_campus_ID, CRA_campus_name)
# write.csv(CRA_AllStudents, "data/Survey_files/CRA_SurveyParticipants_CleanID.csv")



# clean, join college prep students --------------------------------------------

CRCP_2022b <- xlsx_survey_cp %>%
  select(CompletionTime = 'Completion time',
         Name,
         Student_Number = 'Please enter your Student ID number.',
         SchoolName = 'Which campus do you attend?',
         GradeLevel = 'Which grade are you currently in?',
         FullName = 'Please enter your name.') %>%
  mutate(Student_Number = as.numeric(Student_Number),
         CompletionTime = as.character(CompletionTime),
         CompletionTime = as_date(CompletionTime)) %>%
  separate(FullName, c('First_Name', 'Middle_Name', 'LastName'))

CRCP_2022 <- CRCP_2022b %>%
  mutate(Last_Name = if_else(is.na(LastName), Middle_Name, LastName),
         Middle_Initial = substr(Middle_Name, 1,2)) %>%
  select(-Middle_Name, -LastName)

CRCP_campus_ID <- left_join(CRCP_2022, Stu_demg, by=c("Student_Number"="StudentNumber")) %>%
  filter(SchoolNumber != " ") %>%
  select(-FirstName, -MiddleInitial, -LastName)
# write_csv(CRCP_campus_ID, "data/Survey_files/CRCP_surveydata_and_correct_campus.csv")

CRCP_campus_name <- left_join(CRCP_2022, Stu_demg, by=c("Last_Name"="LastName", "First_Name"="FirstName", "Middle_Initial"="MiddleInitial")) %>%
  filter(SchoolNumber != " ") %>%
  select(-StudentNumber)

#Std_demg <- read_csv("Student demographics.csv")%>%
# mutate(StudentNumber = as.character(StudentNumber))

CRCP_AllStudents <- bind_rows(CRCP_campus_ID, CRCP_campus_name)
# write.csv(CRA_AllStudents,"data/Survey_files/CRCP_SurveyParticipants_CleanID.csv")

CRA_campus_name <- left_join(CRA_2022, Std_demg, by = "LastName", "FirstName")%>%
  collect()


# generate counts --------------------------------------------------------------

CRCP_SummarizedbyDate <- CRCP_campus %>%
  group_by(SchoolShortName, CompletionTime)%>%
  summarize(n_students = n())
CRCP_SummarizedbyDate

CRA_SummarizedbyDate <- CRA_campus %>%
  group_by(SchoolShortName, CompletionTime) %>%
  summarize(n_students = n())
CRA_SummarizedbyDate
