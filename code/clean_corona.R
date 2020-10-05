library(dplyr)
library(readxl)
covid = read_excel("~/Dropbox/Econometrics A/puf files/hosenCOVID/H20201431data.xlsx")
#demographics
colnames(covid)
demo_vars = c("Msp_LMS", "Min_puf", "Dat_puf", "academai_puf")
covid_demo = covid %>% select(all_of(demo_vars))
covid_demo = covid_demo %>% 
             rename(male = Min_puf, jew = Dat_puf, college = academai_puf)
covid_demo = covid_demo %>% mutate(male = replace(male, male == 2, 0),
                                   jew = replace(jew, jew == 2, 0),
                                   college = replace(college, college == 2, 0))
write.csv(covid_demo, "data/covid_demo.csv", row.names = F)                                   

#survey
survey_vars = c("Msp_LMS", "HargashaDikaon", "HargashaBedidut",  
                "HargashaLahazHarada", "MatzavBriut", "MatzavNafshi")
covid_survey = covid %>% select(all_of(survey_vars))
covid_survey = covid_survey %>% na_if(".") %>% na_if(100) %>% na_if(101)
covid_survey = covid_survey %>% mutate(across(everything(), as.numeric))
summary(covid_survey)

write.csv(covid_survey, "data/covid_survey.csv", row.names = F)
