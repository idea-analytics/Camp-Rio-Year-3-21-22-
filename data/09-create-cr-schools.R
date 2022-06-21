################################################################################
# Filename: 09-create-cr-schools.R                                             #
# Path: ./data/09-create-cr-schools.R                                          #
# Author: Aline Orr                                                            #
# Date created: 2022-06-09                                                     #
# Date modified: 2022-06-09                                                    #
# Purpose: This script creates the main student and school data frames         #
#           for Camp Rio.                                                      #
# Inputs: ./data/Camp RIO groups 21-22.xlsx                                    #
#         Stu_demg                                                             #
# Outputs: df_all_cr_schools, df_all_cr_attendees                              #
# Notes:                                                                       #
################################################################################


# creates the list of schools and grade levels that attended CR ----------------

df_all_cr_schools <- readxl::read_xlsx(here::here("data", "Camp RIO groups 21-22.xlsx")) %>%
  filter(Grade !=" ", Campus != "BTG", Campus != "Empty") %>%
  mutate(Grade = as.character(Grade),
         Grade = if_else(Campus == "San Juan CP" & Grade == "11","99",Grade)) %>%
  mutate(mergeVar = if_else(Rise == 1, 99, 0),
         Grade = as.integer(Grade))%>%
  select(-Date)%>%
  distinct() %>%
  rename(SchoolShortName = Campus,
         GradeLevelID = Grade)
  
