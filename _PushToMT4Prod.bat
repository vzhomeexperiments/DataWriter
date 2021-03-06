rem Script to Deploy files from Version Control repository to All Terminals
rem Use when you need to publish all files to All Terminals

@echo off
setlocal enabledelayedexpansion

set SOURCE_DIR="%PATH_DSS_Repo%\DataWriter"

set DEST_DIR1="%PATH_T1_E%\01_DataWriter"
set DEST_DIR2="%PATH_T2_E%\01_DataWriter"
set DEST_DIR3="%PATH_T3_E%\01_DataWriter"
set DEST_DIR4="%PATH_T4_E%\01_DataWriter"


ROBOCOPY %SOURCE_DIR% %DEST_DIR1% *.mq4
ROBOCOPY %SOURCE_DIR% %DEST_DIR2% *.mq4
ROBOCOPY %SOURCE_DIR% %DEST_DIR3% *.mq4
ROBOCOPY %SOURCE_DIR% %DEST_DIR4% *.mq4



