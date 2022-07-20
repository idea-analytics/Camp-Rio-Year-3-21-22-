################################################################################
# Filename: 02-get-science-grades-data.R                                       #
# Path: ./data/02-get-science-grades-data.R                                    #
# Author: Steven Macapagal                                                     #
# Date created: 2022-06-01                                                     #
# Date modified: 2022-07-11                                                    #
# Purpose: This script pulls in science historical grades.                     #
# Inputs:                                                                      #
# Outputs:                                                                     #
# Notes: Historical grades were not stored until Monday 11 July 2022.          #
################################################################################



raw_science_grades <- get_table(.table_name = "StudentHistoricalGrades",
                               # .server_name = "1065574-SQLPRD1",
                               .server_name = "RGVPDSD-DWPRD1",
                               .database_name = "PROD1",
                               .schema = "Schools") %>%
  filter(AcademicYear == "2021-2022",
         CreditType == "SC",
         StoreCode == "Y1",
         GradeLevelID %in% c(9, 10, 11, 12)) %>%
  collector(GradeLevelID)


# glimpse(raw_science_grades)


# raw_science_grades <- get_table(.table_name = "StudentCurrentGrades",
#                                 .server_name = "RGVPDSD-DWPRD1",
#                                 .database_name = "PROD1",
#                                 .schema = "Schools") %>%
#   filter(SchoolTermID == "3100",
#          CreditType == "SC",
#          StoreCode == "Y1",
#          GradeLevelID %in% c(9, 10, 11, 12))
# 
# glimpse(raw_science_grades)
