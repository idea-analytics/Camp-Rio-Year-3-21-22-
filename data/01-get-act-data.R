################################################################################
# Filename: 01-get-act-data.R                                                  #
# Path: ./data/01-get-act-data.R                                               #
# Author: Steven Macapagal                                                     #
# Date created: 2022-06-01                                                     #
# Date modified: 2022-06-01                                                    #
# Purpose: This script pulls in ACT data.                                      #
# Inputs:                                                                      #
# Outputs:                                                                     #
# Notes:                                                                       #
################################################################################


# this does not have any data for 20-21 or 21-22

df_act <- get_table(.table_name = "ACT",
                    .server_name = "RGVPDRA-DASQL",
                    .database_name = "Dashboard",
                    .schema = "dbo") %>%
  filter(ReportingYearIdentifier %in% c("21", "22"))


# this does not have any data for 21-22

df_act <- get_table(.table_name = "ACT",
                    .server_name = "RGVPDSD-DWPRD2",
                    .database_name = "PROD2",
                    .schema = "Assessments") %>%
  filter(AcademicYear == "2021-2022")


# this does not have any data for 20-21 or 21-22

df_act <- get_table(.table_name = "ACT",
                    .server_name = "RGVPDSD-DWSRC3",
                    .database_name = "SRC_CollegeSuccess",
                    .schema = "ETL") %>%
  filter(ReportingYearIdentifier %in% c("21", "22"))
