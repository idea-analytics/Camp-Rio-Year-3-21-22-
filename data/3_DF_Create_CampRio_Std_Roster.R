SchlRoster <- read_xlsx("data/Camp RIO groups 21-22.xlsx")%>%
  filter(Grade !=" ", Campus != "BTG", Campus != "Empty") %>%
  mutate(Grade = as.character(Grade),
         Grade = if_else(Campus == "San Juan CP" & Grade == "11","99",Grade)) %>%
  mutate(mergeVar = if_else(Rise == 1, 99, 0),
         Grade = as.integer(Grade))%>%
  select(-Date)%>%
  distinct()

Rise_stu <- Stu_demg %>%
  filter(SchoolShortName == "Robindale" & RISEcode == "1" | 
           SchoolShortName == "Mission" & RISEcode == "1"|
           SchoolShortName == "San Juan CP" & GradeLevelID == 11 & RISEcode =="1" )%>%
  mutate(mergeVar = if_else(RISEcode == "1", 99, 0),
  )

Participants <- left_join(SchlRoster, Stu_demg, by = c("Campus" = "SchoolShortName", "Grade"="GradeLevelID"))
#write.csv(Participants, "Participants.csv")

Rise_participants <- left_join(SchlRoster, Rise_stu, by = c("Campus"="SchoolShortName","mergeVar"))%>%
  filter(StudentNumber != "")%>%
  select(-GradeLevelID)All_participants <- bind_rows(Participants, Rise_participants) %>%
  write.csv("data/Camp_Rio_participants_6.02.2022.csv")