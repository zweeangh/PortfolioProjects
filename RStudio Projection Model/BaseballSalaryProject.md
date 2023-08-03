# Project
> Using a 2008 MLB dataset to create a regression model which predicts a player’s salary based on chosen hitting statistics

\
Loading in the data
\
_DataSet <- read.xlsx("Baseball.xlsx",1)_
_DataSet$SR_Salary <- sqrt(DataSet$SALARY)_
\
\
Running a Shapiro-Wilk Test on _DataSet$SR_Salary_ would show a positive skew
\
![image](https://github.com/zweeangh/PortfolioProjects/assets/93295262/2c336fc0-53e0-4a58-8656-c6ea51422620)
