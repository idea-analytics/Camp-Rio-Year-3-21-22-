################################################################################
# Filename: 06-get-survey-data.R                                               #
# Path: ./data/06-get-survey-data.R                                            #
# Author: Aline Orr, Steven Macapagal                                          #
# Date created: 2022-06-07                                                     #
# Date modified: 2022-06-08                                                    #
# Purpose: This script pulls in all survey data.                               #
# Inputs: ./data/Camp RIO Survey_Academy_21-22.xlsx                            #
#         ./data/Camp RIO Survey_CollegePrep_21-22.xlsx                        #
# Outputs: xlsx_survey_ac, xlsx_survey_cp                                      #
# Notes:                                                                       #
################################################################################


# read in academy data ---------------------------------------------------------

xlsx_survey_ac <- readxl::read_xlsx(here::here("data", "Camp RIO Survey_Academy_21-22.xlsx"))

# glimpse(xlsx_survey_ac)


# read in college prep data ----------------------------------------------------

xlsx_survey_cp <- readxl::read_xlsx(here::here("data", "Camp RIO Survey_CollegePrep_21-22.xlsx"))

# glimpse(xlsx_survey_cp)



