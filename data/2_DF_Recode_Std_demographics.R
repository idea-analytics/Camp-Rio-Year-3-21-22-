# Need to give students mutually exclusive, collectively exhaustive race categories
# IF hispanic than hispanic and no other race
# If more than one race, then code as multi-racial,
# if no races indicated, then code as such
Stu_demg <- stdtable %>%
  #the code below gives precedence to Hispanic, if hisp than all other races are set to 0
  mutate(White = if_else(Hispanic == 1,0,White),
         Black = if_else(Hispanic == 1,0,Black),
         Asian = if_else(Hispanic == 1,0,Asian),
         Other = if_else(Hispanic == 1,0,Other))%>%
  #the code below creates a multi-race variable and a missing (none) race var
  mutate(total_race = (Hispanic + White + Black + Asian + Other),
         Multi = if_else(total_race>1,1,0),
         None = if_else(total_race ==0,1,0))%>%
  #except for Hispanic, which tramples all other races, the code below sets each ethnicity to 0 if the student indicated multiple races
  mutate(Hispanic = if_else(Multi ==1,0,Hispanic),
         White = if_else(Multi == 1,0,White),
         Black = if_else(Multi == 1,0,Black),
         Asian = if_else(Multi == 1,0,Asian),
         Other = if_else(Multi ==1,0,Other))%>%
  mutate(Other = if_else(Multi==1|Other==1|None==1,1,0))%>%
  #dropping some vars
  select(-total_race,-Multi,-None)%>%
  
  #the code below puts the race indicator into a single column
  pivot_longer(Hispanic:Other, names_to="Race",values_to="race_indicator")%>%
  filter(race_indicator==1)%>%
  select(-race_indicator) %>%
  distinct()
#write_csv(Stu_demg, "Student demographics.csv")