# DataWriter

Designed to work best with Decision Support System developed inside Lazy Trading Project

https://vladdsm.github.io/myblog_attempt/topics/lazy%20trading/

# Introduction

Various Expert Advisors that will record financial data from the asset to MT4 Sandbox. Data will be then separately analyzed to build models or used for price change prediction.

# Synchronize or Deploy

## Setup Environmental Variables

Add these User Environmental Variables:

PATH_T2_E - path to Development Terminal MT4, folder *\MQL4\Experts
PATH_T1_E, PATH_T3_E, etc - paths to the Terminals where all other terminals are located
PATH_DSS_Repo - path to the folder where this repository is stored on the local computer

## DataWriter v4.01

Expert Advisor able to automatically collect indicators values for 28 major currency pairs.

Pairs = c("EURUSD", "GBPUSD", "AUDUSD", "NZDUSD", "USDCAD", "USDCHF", "USDJPY",
                     "EURGBP", "EURJPY", "EURCHF", "EURNZD", "EURCAD", "EURAUD", "GBPAUD",
                     "GBPCAD", "GBPCHF", "GBPJPY", "GBPNZD", "AUDCAD", "AUDCHF", "AUDJPY",
                     "AUDNZD", "CADJPY", "CHFJPY", "NZDJPY", "NZDCAD", "NZDCHF", "CADCHF")   
					 
## DataWriter v4.02

Improved code using nested for loops and strings arrays (contributed by @MiguelDaCosta)					 
					 
## DataWriter v5.01

Expert Advisor able to automatically collect close price of the #TeslaMotor stock price
					 
## DataWriter v6.01 [Prototype]

Expert Advisor collecting several indicator data to build Deep Learning regression models:

* Several indicators
* Each Pair has it's own output
					 
## Courious how to apply?

This content is a result of a lot of dedication and time.
Please support this project by joining these courses using referral links published
here: https://vladdsm.github.io/myblog_attempt/topics/topics-my-promotions.html

# Disclaimer

Use on your own risk: past performance is no guarantee of the future results!