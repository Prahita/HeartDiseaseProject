library(ggplot2)
library(ggplot2)
library(tidyverse)
library(rsample)
library(tree)
library(dplyr)
library(GGally)
library(plotROC)
library(yardstick)
library(glmnet)
library(glmnetUtils)
library(forcats)
library(ggridges)
library(coefplot)
library(caret)
#load the data set 
obesity <- read.csv("datasets/ObesityDataSet2.csv")
glimpse(obesity)

#Removing NA from the Dataset
obesity <- na.omit(obesity)
colSums(is.na(obesity))

#Explore the data set
dim(obesity)
glimpse(obesity)


#Rename variables
obesity <- obesity %>% rename( eats_high_calor_food = FAVC,
                               eats_veggies = FCVC,
                               num_meals = NCP,
                               eats_snacks = CAEC,
                               drinks_water = CH2O,
                               counts_calories = SCC,
                               exercises_frequency = FAF,
                               time_using_tech = TUE,
                               drinks_alcohol = CALC,
                               transport_methods = MTRANS,
                               weight_category = NObeyesdad ) 

#mutate factor variables
obesity <- obesity %>% 
  mutate(
    Gender = factor(Gender),
    family_history_with_overweight = factor(family_history_with_overweight),
    eats_high_calor_food = factor(eats_high_calor_food),
    drinks_alcohol = factor(drinks_alcohol),
    eats_snacks = factor(eats_snacks),
    SMOKE = factor(SMOKE),
    counts_calories = factor(counts_calories),
    transport_methods = factor(transport_methods))

obesity <- obesity %>% mutate(Obese_binary = factor(Obese_binary),
                              drinks_water = as.integer(drinks_water))

glimpse(obesity)

#added two more columns BMI and weight category number 
obesity <- obesity %>% mutate( bmi = Weight / Height^2 ) %>%
  mutate( weight_cat_num = case_when( ( weight_category == "Insufficient_Weight" ) ~ -1,
                                      ( weight_category == "Normal_Weight" ) ~ 0,
                                      ( weight_category == "Overweight_Level_I" ) ~ 1,
                                      ( weight_category == "Overweight_Level_II" ) ~ 2,
                                      ( weight_category == "Obesity_Type_I" ) ~ 3,
                                      ( weight_category == "Obesity_Type_II" ) ~ 4,
                                      ( weight_category == "Obesity_Type_III" ) ~ 5 ) )


glimpse(obesity)



#Classification tree

# Splitting data set.seed(310)
obesity_split <- initial_split(obesity,prop=0.7)
obesity_train <- training(obesity_split)
obesity_test <- testing(obesity_split)



#----------------------------------------------------

# classification tree 2 - no bmi/ weight_category / no weight related category
#making model and running tree
tree_obesity_wo_weight <- tree(Obese_binary ~ Gender+Age+Height+Weight+bmi+family_history_with_overweight+eats_high_calor_food+eats_veggies+num_meals+eats_snacks+SMOKE+drinks_water+counts_calories+exercises_frequency+time_using_tech+drinks_alcohol+transport_methods,
                       data=obesity_train)

#plotting this model
plot(tree_obesity_wo_weight)
text(tree_obesity_wo_weight,pretty = 0,cex=0.35)


# predicting the tree for this model
preds_test_obesitytree_wo_weight <- predict(tree_obesity_wo_weight,
                                       newdata = obesity_test,
                                       type = "class")

head(preds_test_obesitytree_wo_weight)

table(preds_test_obesitytree_wo_weight, obesity_test$Obese_binary)


# cross validating and testing data
cv_tree_obesity_wo_weight <- cv.tree(tree_obesity_wo_weight)

print(cv_tree_obesity_wo_weight)
summary(cv_tree_obesity_wo_weight)


# find the best tree size
cv_tree_df_obesity_wo_weight <- data.frame(size = cv_tree_obesity_wo_weight$size,
                                 mse = cv_tree_obesity_wo_weight$dev)

print(cv_tree_df_obesity_wo_weight)


# plot the error vs tree 

ggplot(cv_tree_df_obesity_wo_weight, aes(x=size,y=mse))+
  geom_point()+geom_line()+
  xlab("Tree size")+ylab("MSE (CV)")



# prune the tree by the best size
pruned_tree_obese_wo_weight <- prune.tree(tree_obesity_wo_weight,best=14)

# plot the pruned tree
plot(pruned_tree_obese_wo_weight)
text(pruned_tree_obese_wo_weight,pretty = 0,cex=0)

#----------------------------------------------------------------

# Final Tree Model

tree_obesity <- tree(factor(Obese_binary) ~ Age + Height + 
                       family_history_with_overweight + 
                       drinks_water + time_using_tech + 
                       counts_calories + exercises_frequency + 
                       transport_methods,
                     data = obesity_train)
plot(tree_obesity)
text(tree_obesity,pretty = 0,cex=0.6)

# prediction for test tree
prediction_test <- predict(tree_obesity,
                           newdata = obesity_test,
                           type = "class")

prediction_test
table(prediction_test, obesity_test$Obese_binary)


# cross validating and testing data
cv_tree_obesity <- cv.tree(tree_obesity)
print(cv_tree_obesity)

# find the best tree size
cv_tree_df <- data.frame(
  size = cv_tree_obesity$size,
  mse = cv_tree_obesity$dev
)
print(cv_tree_df)
# plot the error vs tree 
ggplot(cv_tree_df, aes(x = size, y = mse)) +
  geom_point() +
  geom_line() +
  xlab("Tree Size") + ylab("Mse (CV)")

# prune the tree by the best size
prunned.tree <- prune.tree(tree_obesity, best = 10)

# plot the pruned tree
plot(prunned.tree)
text(prunned.tree)