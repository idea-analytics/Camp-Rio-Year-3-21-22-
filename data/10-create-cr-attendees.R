################################################################################
# Filename: 10-create-cr-attendees.R                                           #
# Path: ./data/10-create-cr-attendees.R                                        #
# Author: Aline Orr                                                            #
# Date created: 2022-06-09                                                     #
# Date modified: 2022-06-09                                                    #
# Purpose: This script creates the main student df for Camp Rio.               #
# Inputs: ./data/Camp RIO groups 21-22.xlsx                                    #
#         Stu_demg                                                             #
# Outputs: df_all_cr_attendees                                                 #
# Notes: Rise variable indicates a RISE group came to Camp Rio.                #
#         RISEcode indicates the student is marked as RISE in the students     #
#         table. These two might not match because a RISE student could have   #
#         attended in a mainstream group. These will be renamed to             #
#         RiseGroup and RiseStudent, respectively.                             #
################################################################################


# intermediate dfs to get CR attendees -----------------------------------------

Rise_stu <- Stu_demg %>%
  filter(SchoolShortName == "Robindale" & RISEcode == "1" | 
           SchoolShortName == "Mission" & RISEcode == "1"|
           SchoolShortName == "San Juan CP" & GradeLevelID == 11 & RISEcode =="1" )%>%
  mutate(mergeVar = if_else(RISEcode == "1", 99, 0),
  )

Participants <- left_join(df_all_cr_schools, Stu_demg, by = c("Campus" = "SchoolShortName", "Grade"="GradeLevelID"))
#write.csv(Participants, "Participants.csv")

Rise_participants <- left_join(df_all_cr_schools, Rise_stu, by = c("Campus"="SchoolShortName","mergeVar"))%>%
  filter(StudentNumber != "")%>%
  select(-GradeLevelID)


# this creates the roster of all students who attended CR ----------------------

df_all_cr_attendees <- bind_rows(Participants, Rise_participants) %>%
  select(-mergeVar) %>%
  rename(SchoolShortName = Campus,
         GradeLevelID = Grade,
         RiseGroup = Rise,
         RiseStudent = RISEcode)




# write.csv(All_participants, here("data", "Camp_Rio_participants_6.02.2022.csv"))