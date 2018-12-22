rem Script to Sync Files from Development Terminal to Version Control

@echo off
setlocal enabledelayedexpansion

:: Source Directory where Expert Advisor is located
set SOURCE_DIR="C:\Program Files (x86)\FxPro - Terminal2\MQL4\Experts\01_DataWriter"
:: Destination Directory where Version Control Repository is located
set DEST_DIR="C:\Users\fxtrams\Documents\000_TradingRepo\DataWriter"

:: Copy only files with *.mq4 extension
ROBOCOPY %SOURCE_DIR% %DEST_DIR% DataWriter_*.mq4