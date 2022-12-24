# ObesityProject
This was my final project for MGSC 310 in Spring of 2022. I utilized R and Rstudio to visualize the data and make simple machine learning models to help predict which factors are most likely to contribute to a diagnosis of Obesity.

This was a group project and my team used a combination of supervised and unsupervised machine learning models to predict the variable obesity. We used Logistic regression, Lasso regression, and a decision tree model to find the most significant variables that contribute to a positive obesity diagnosis.

The dataset we used is from the UC Irvine repository found here: https://archive.ics.uci.edu/ml/datasets/Estimation+of+obesity+levels+based+on+eating+habits+and+physical+condition+

The dataset contains information on various individuals from Mexico, Peru and Colombia aged 14 to 61. There are multiple attributes used in this analysis including BMI, age, height, weight, caloric intake, exercise frequency, water consumption per day, physical activity frequency and more to predict the attribute. 

The attributes related with eating habits: 
- Frequent consumption of high caloric food (FAVC)
- Frequency of consumption of vegetables (FCVC)
- Number of main meals (NCP)
- Consumption of food between meals (CAEC)
- Consumption of water daily (CH20)
- Consumption of alcohol (CALC). 

The attributes related with the physical condition: 
- Calories consumption monitoring (SCC)
- Physical activity frequency (FAF)
- Time using technology devices (TUE)
- Transportation used (MTRANS)

Other variables obtained:
- Gender
- Age
- Height
- Weight

The class variable NObesity was created with the values of: 
- Insufficient Weight (BMI < 18.5)
- Normal Weight (18.5 > BMI < 24.9)
- Overweight Level I & Overweight Level II (25 > BMI < 29.9)
- Obesity Type I (30 > BMI < 34.9)
- Obesity Type II (35 > BMI < 39.9)
- Obesity Type III (BMI > 40)

*BMI = weight / height x height
