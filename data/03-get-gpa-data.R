################################################################################
# Filename: 03-get-gpa-data.R                                                  #
# Path: ./data/03-get-gpa-data.R                                               #
# Author: Steven Macapagal                                                     #
# Date created: 2022-06-01                                                     #
# Date modified: 2022-06-02                                                    #
# Purpose: This script pulls in science historical grades.                     #
# Inputs:                                                                      #
# Outputs:                                                                     #
# Notes:                                                                       #
################################################################################


# df_gpa <- get_table(.table_name = "StudentAcademicSummary",
#                     .server_name = "RGVPDSD-DWPRD1",
#                     .database_name = "PROD1",
#                     .schema = "Schools") %>%
#   filter(AcademicYear == "2021-2022")


raw_gpa <- get_table(.table_name = "StudentAcademicSummary",
                    .server_name = "1065574-SQLPRD1",
                    .database_name = "PROD1",
                    .schema = "Schools") %>%
  filter(AcademicYear == "2021-2022") %>%
  collect()

glimpse(raw_gpa)
