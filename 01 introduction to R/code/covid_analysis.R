library(tidyverse)
library(stargazer)

#Read files
demo = read.csv("data/covid_demo.csv")
str(demo)
summary(demo)

survey = read.csv("data/covid_survey.csv")
str(survey)
summary(survey)

#Joining dataframes
covid = demo %>% left_join(survey, by = "Msp_LMS")
str(covid)

###
#Basic dplyr verbs
###

#mutate
covid = covid %>%
  mutate(MatzavClali = 0.5*(MatzavBriut + MatzavNafshi))

#drop_na
covid = covid %>% 
  drop_na()

#filter & summarize        
covid %>% 
  filter(male == 1) %>%
  summarize(mean(MatzavClali))

#summarize_all
covid %>% 
  filter(male == 1) %>%
  select(MatzavBriut, MatzavNafshi) %>%
  summarize_all(mean)

#starts_with
covid %>% 
  filter(male == 1) %>%
  select(starts_with("Hargasha")) %>%
  summarize_all(mean)

#group_by
covid %>% 
  group_by(male) %>%
  select(starts_with("Hargasha")) %>%
  summarize_all(mean)

###
#Exporting tables using stargazer
###

sum_stat = covid %>% 
  group_by(male) %>%
  select(starts_with("Hargasha")) %>%
  summarize_all(mean)

stargazer(round(sum_stat, 2), type = "html", title = "Conditional Expectations", 
          summary = F, out = "outputs/hargasha_conditional_exp.html", rownames = F)

###
#Basic plots using ggplot2            
###

#stat_count (=an histogram for categorical variables)
ggplot(covid) + 
  stat_count(mapping = aes(x = HargashaDikaon))

#..prop..
ggplot(covid) + 
  stat_count(mapping = aes(x = HargashaDikaon, y = ..prop..))

#facet_grid + vars
ggplot(covid) + 
  stat_count(mapping = aes(x = HargashaDikaon, y = ..prop..)) +
  facet_grid(cols = vars(college))

#label_both
g = ggplot(covid) + 
  stat_count(mapping = aes(x = HargashaDikaon, y = ..prop..)) +
  facet_grid(cols = vars(college), rows = vars(jew), labeller = label_both) 

###
#Exporting
###
pdf("outputs/dikaon_conditional_dist.pdf")
print(g)
dev.off()
