################################################################################
# Filename: 02-get-science-grades-data.R                                       #
# Path: ./data/02-get-science-grades-data.R                                    #
# Author: Steven Macapagal                                                     #
# Date created: 2022-06-01                                                     #
# Date modified: 2022-06-02                                                    #
# Purpose: This script pulls in science historical grades.                     #
# Inputs:                                                                      #
# Outputs:                                                                     #
# Notes:                                                                       #
################################################################################


# df_science_grades <- get_table(.table_name = "StudentHistoricalGrades",
#                                .server_name = "RGVPDSD-DWPRD1",
#                                .database_name = "PROD1",
#                                .schema = "Schools") %>%
#   filter(AcademicYear == "2021-2022",
#          CreditType == "SC",
#          StoreCode == "Y1")


df_science_grades <- get_table(.table_name = "StudentHistoricalGrades",
                               .server_name = "1065574-SQLPRD1",
                               .database_name = "PROD1",
                               .schema = "Schools") %>%
  filter(AcademicYear == "2021-2022",
         CreditType == "SC",
         StoreCode == "Y1")


glimpse(df_science_grades)
