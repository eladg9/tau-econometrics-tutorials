###
#Matrices
###

#Generating matrices
n = 3
X = matrix(rep(1, n), ncol = 1, dimnames = list(NULL, "x1"))

##generating an empty matrix
empty_mat = matrix(nrow = 3, ncol = 3)

#Adding columns 
X = cbind(X, x2 = rnorm(n))

#Adding rows
X = rbind(X, rnorm(2))

#Removing rows / columns
X = X[-4,]

#Matrices vs. Dataframes
X_df = as.data.frame(X)
X_df = cbind(X_df, x3 = rep("A", n))

X_mat = X
X_mat = cbind(X, rep("A", n))

###
#Matrix Operations
###

#Inverse matrix 
X = cbind(X, x3 = rnorm(n))
X_inverse = solve(X)

#Matrix multiplication
round(X %*% X_inverse, 5) #%*% - matrix multiplication
round(X * X_inverse, 5) #* - element-wise multiplication

#Transpose
t(X) + t(X_inverse)
t(X + X_inverse)

###
#Linear Regression
###

library(tidyverse)
library(stargazer)

#Read Data
demo = read.csv("data/covid_demo.csv")
survey = read.csv("data/covid_survey.csv")

#Merge
covid = demo %>% left_join(survey, by = "Msp_LMS")
summary(covid)

#drop NA
covid = covid %>% 
  drop_na()

#Estimating linear regression
reg = lm(MatzavBriut ~ jew + college, data = covid)
summary(reg)
nobs(reg)

#Estimating on subgroups
male_reg = lm(MatzavBriut ~ jew + college, data = covid, subset = male == 1)
summary(male_reg)
nobs(male_reg)

#Estimating on sub-samples
sub_covid = covid %>% sample_n(size = 800, replace = F)
#sub_covid = covid %>% sample_frac(size = 0.5, replace = F)
sub_reg = lm(MatzavBriut ~ jew + college, data = sub_covid)
summary(sub_reg)

#Extracting OLS coefficeints
#option 1
reg_coef = reg$coefficients
#option 2
summary_object = summary(reg)
reg_coef = summary_object$coefficients[,1]

#Exporting results
stargazer(reg, type = "html", title = "Regression Results",
          out = "outputs/reg_results.html")

