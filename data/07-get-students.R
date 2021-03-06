################################################################################
# Filename: 07-get-students.R                                                  #
# Path: ./data/07-get-students.R                                               #
# Author: Aline Orr                                                            #
# Date created: 2022-06-09                                                     #
# Date modified: 2022-06-09                                                    #
# Purpose: This script pulls in all students.                                  #
# Inputs: students table, schools table                                        #
# Outputs: std_data, schl_data, stdtable                                       #
# Notes:                                                                       #
################################################################################

std_data <- get_students() %>%
  filter(AcademicYear == "2021-2022") %>%
  select(StudentNumber,
         FirstName,
         MiddleInitial,
         LastName,
         AcademicYear,
         SchoolNumber,
         GradeLevelID,
         ExitDate,
         Gender,
         SPED,
         AtRisk = AtRiskFlag,
         ECD = ECDFlag,
         LEP = ELLCode,
         RISEcode = InstructionalSettingCode, 
         Hispanic = FederalHispanicFlag, 
         Am_Indian = FederaRaceI,
         Asian = FederaRaceA, 
         Black = FederaRaceB, 
         P_Islander = FederaRaceP, 
         White = FederaRaceW) %>%
  
  mutate(ECD = as.numeric(ECD),
         #ECD = if_else(ECD %in% c(0,NA),0,1),
         #LEP = case_when(LEP %in% c("0", "F", "S", "3", "4") ~ "Non-EL",
         #LEP == "1" ~ "EL",
         LEP = if_else(LEP %in% c("0","F","S","3","4"),0,1),
         SPED = if_else(SPED =="TRUE","1","0"),
         AtRisk = if_else(AtRisk == "TRUE", 1,0),
         RISEcode = if_else(RISECode %in% c(43,44),1,0),
         Other = case_when(P_Islander ==1 ~1, Am_Indian ==1 ~1),
         Other = as.numeric(if_else(Other ==1,1,0)),
         Hispanic = as.numeric(Hispanic),
         White = as.numeric(White),
         Black = as.numeric(Black),
         Asian = as.numeric(Asian)) %>%
  #use this when you can not use rowiscurrent to keep only one grade level, this can also be used as max school number to keep only one school. Again, make sure to group by student first.

  select(-P_Islander, -Am_Indian) %>%
  distinct() %>%
  collect() %>% 
  group_by(StudentNumber) %>%
  filter(GradeLevelID == max(GradeLevelID),
         ExitDate == max(ExitDate)) %>% 
  ungroup() %>%
  distinct()
# std_data
# glimpse(std_data)
# write.csv(std_data, "Student data.csv")

schl_data <- get_schools() %>%
  select(SchoolNumber, SchoolShortName) %>%
  collect()
# write.csv(schl_data,"School names_2022.csv")

stdtable <- left_join(std_data, schl_data, by = "SchoolNumber") # %>%
  # filter((SchoolShortName != "Robindale" & RISEcode == "1") &
  #       (SchoolShortName != "Mission" & RISEcode =="1") &
  #      (SchoolShortName != "San Juan CP" & GradeLevelID == "11" & RISEcode == "1"))
