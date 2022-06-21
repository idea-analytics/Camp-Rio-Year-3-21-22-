################################################################################
# Filename: 04-clean-nsc-data.R                                                #
# Path: munge/04-clean-nsc-data.R                                              #
# Author: Steven Macapagal                                                     #
# Date created: 2022-06-20                                                     #
# Date modified: 2022-06-20                                                    #
# Purpose: This script cleans NSC data.                                        #
# Inputs:  raw_nsc, get_students()                                             #
# Outputs: df_nsc                                                              #
# Notes:                                                                       #
################################################################################



# select only class of 2021 graduates, join with students table ----------------

df_nsc <- raw_nsc %>%
  
  # clean up data types
  mutate(StudentNumber = as.numeric(str_replace(YourUniqueIdentifier, "_", "")),
         HighSchoolGradDate = ymd(HighSchoolGradDate),
         CohortYear = year(HighSchoolGradDate),
         EnrollmentBegin = ymd(EnrollmentBegin),
         EnrollmentEnd = ymd(EnrollmentEnd)) %>%
  
  # select 2021 grads
  filter(CohortYear == 2021) %>%
  select(-YourUniqueIdentifier,
         -RequesterReturnField) %>%
  
  # get student info directly from warehouse
  left_join(get_students() %>%
              #filter for currently enrolled seniors in 2021-2022
              filter(AcademicYear == "2020-2021",
                     GradeLevelID == "12",
                     ExitDate > "2021-05-20",
                     ExitCode == "01") %>%
              
              #join Schools and Regions tables
              inner_join(get_schools(),
                         by = c("SchoolNumber" = "SchoolNumber")) %>%
              inner_join(get_regions(),
                         by = c("RegionID" = "RegionID")) %>%
              
              select(Region = RegionDescription,
                     SchoolName,
                     StudentNumber,
                     StudentFullName) %>%
              collect(),
            by = c("StudentNumber" = "StudentNumber")) %>%
  mutate(SchoolName = if_else(SchoolName == "IDEA College Preparatory",
                              "IDEA Donna College Preparatory",
                              SchoolName)) %>%
  relocate(Region,
           SchoolName,
           StudentNumber,
           StudentFullName,
           CohortYear) %>%
  arrange(Region,
          SchoolName,
          StudentFullName)

## sanity checks

# glimpse(df_nsc)

### counted 1400 different students

# df_nsc %>%
#   distinct(StudentNumber)

### counted 87 students who did not have a matching record (3.43 %)

# df_nsc %>%
#   count(RecordFoundYN) %>%
#   mutate(Percent = n * 100 / sum(n))

### counted 19 schools (all schools accounted for)

# df_nsc %>%
#   distinct(SchoolName)

### counted 92 students who withdrew from their first college

# df_nsc %>%
#   group_by(StudentNumber) %>%
#   filter(EnrollmentStatus == "W",
#          CollegeSequence == 1)

### counted 948 students who enrolled full time in 2021

# df_nsc %>%
#   filter(EnrollmentStatus == "F",
#          CollegeSequence == 1,
#          year(EnrollmentBegin) == 2021)

### counted 1252 students who enrolled at least half time in 2021

# df_nsc %>%
#   filter(EnrollmentStatus %in% c("F", "Q", "H"),
#          CollegeSequence == 1,
#          year(EnrollmentBegin) == 2021)


### counted 1348 students who enrolled in 2021

# df_nsc %>%
#   filter(!(EnrollmentStatus %in% c("A", "W", "D")),
#          CollegeSequence == 1,
#          year(EnrollmentBegin) == 2021)
