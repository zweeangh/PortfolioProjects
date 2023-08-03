# Baseball Salary Project
> Using a 2008 MLB dataset to create a regression model which predicts a player’s salary based on chosen hitting statistics

## Checking Data
Run a Shapiro-Wilk Test on _DataSet$SR_Salary_ would show a positive skew, correct this using square root
\
![image](https://github.com/zweeangh/PortfolioProjects/assets/93295262/2c336fc0-53e0-4a58-8656-c6ea51422620)
\
\
Choose predictor variables and run a correlation matrix to see if there is a risk of multicollinearity
\
_HR (Home Runs)_
\
_G (Games Played)_
\
_PA (Plate Appearances)_
\
_TB (Total Bases)_
\
![image](https://github.com/zweeangh/PortfolioProjects/assets/93295262/45f3d8b3-c6c6-4311-9975-d2c0312a72ae)
\
\
Run a model without PA
\
![image](https://github.com/zweeangh/PortfolioProjects/assets/93295262/4fb20b02-30ba-4d88-916e-321a8fbbf7b3)
\
\
We can see that we have a significant regression model, _F(3,333) = 16.63, p < 0.001_. We have
explained 13.03% of the variance in “SR_Salary”, with an adjusted R-squared value of 0.1224.
Looking at the predictors, we can see that the intercept is significantly different than zero. In
our situation, it means that the baseball players got paid, even if they didn’t get any of the other
statistics we looked at.
\
\
We also see that the number of Games Played (G) is a significant predictor. Interestingly, it has a
negative value, indicating a negative relationship between games played and salary. Total Bases
was significant and we can see that there is a positive relationship between TB and SR_Salary.
Lastly, we see that HR is not a significant predictor of salary.

## Running Diagnostics
Look at the data in a pair-wise manner
\
![image](https://github.com/zweeangh/PortfolioProjects/assets/93295262/cf83d0f5-b986-45f2-9747-79e07af15448)
\
\
Look at the “Leverage” of the individual points in the model
\
![image](https://github.com/zweeangh/PortfolioProjects/assets/93295262/4340510d-7374-47df-bd7e-d3f0bf9037fc)
\
\
We can see that there are no overly “influential cases” in our dataset. If we had values above
0.25, we would be concerned and may want to see if this case is an outlier.
## Evaluating Residuals
Plot the residuals against the predicted values and the independent variables. The
residuals should be randomly scattered about zero and the width should be constant, for the
homoscedasticity assumption to hold.
\
![image](https://github.com/zweeangh/PortfolioProjects/assets/93295262/33380c34-2ac0-4d1d-809b-d46ca8788407)
\
\
Check the normality of our residuals
\
![image](https://github.com/zweeangh/PortfolioProjects/assets/93295262/2ec31dc5-c355-4eb3-8d1a-b55ddc9d0581)

## Using the Model
Say we want to predict the salary of a player who plays 92 games, has 126 total bases, and 12
HRs. We can do this with the following command, and get prediction with a confidence interval
based on our model.
\
_predict(Model1, data.frame(HR=12, TB = 126, G = 92), interval="prediction")_
\
\
This tells us we could expect an SR_Salary of 1717.735 with the stats we presented… note we
took the square root of the salary, so we have to square the value we get, so we could expect a
mean salary of approximately $2.95 million for putting up those numbers.
