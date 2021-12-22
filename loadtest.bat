@echo off

TITLE JMeter Performance Test

@REM Batch script for JMeter performance test
@REM Maintainer: Shashindran Vijayan shshindran@yahoo.com

@REM Get user inputs
SET /p _testfilename="Enter test file name without (.jmx): "

@REM Check whether the test file is exist
IF NOT EXIST "%USERPROFILE%\Desktop\Script\%_testfilename%.jmx" (
  @REM Exit the program if the test file not exist
  echo Cannot find the file
  pause
  exit
)

SET /p _threads="Enter threads to test separated by space (default: 1): " || SET _threads=1
SET /p _testduration="Enter test duration in seconds (default: 300): " || SET _testduration=300
SET /p _restduration="Enter rest duration between test in seconds (default: 120): " || SET _restduration=120

@REM Create Reports folder in desktop if it is not exist
IF NOT EXIST "%USERPROFILE%\Desktop\Reports" MKDIR "%USERPROFILE%\Desktop\Reports"

@REM Check whether the test folder is exist inside Reports folder
IF EXIST "%USERPROFILE%\Desktop\Reports\%_testfilename%" (
  SET /p _delete_folder="%USERPROFILE%\Desktop\Reports\%_testfilename% already exist. Do you want to delete the folder? (y/n) "
  goto delete_test_folder
) ELSE (
  ECHO Please wait... Checking system information.
  :: Section 1: Windows 10 information
  ECHO ==========================
  ECHO WINDOWS INFO
  ECHO ============================
  systeminfo | findstr /c:"OS Name"
  systeminfo | findstr /c:"OS Version"
  systeminfo | findstr /c:"System Type"
  :: Section 2: Hardware information.
  ECHO ============================
  ECHO HARDWARE INFO
  ECHO ============================
  systeminfo | findstr /c:"Total Physical Memory"
  wmic cpu get name
  goto load_test
)
goto:eof

:delete_test_folder
@REM Delete folder if the response is y
IF "%_delete_folder%"=="y" (
  echo "Deleting directory %USERPROFILE%\Desktop\Reports\%_testfilename%"
  RMDIR /s /q "%USERPROFILE%\Desktop\Reports\%_testfilename%"
)
goto load_test
goto:eof

:load_test
@REM Print out summary of user input
echo.
echo "==============================================================="
echo "|| TEST FILE: %USERPROFILE%\Desktop\Script\%_testfilename%.jmx"
echo "|| LIST OF THREADS: %_threads%"
echo "|| DURATION: %_testduration% seconds"
echo "|| REST: %_restduration% seconds"
echo "============================================================="
echo.

@REM Get current timestamp
set timestamp=%DATE:/=-%_%TIME::=-%
set timestamp=%timestamp: =%

@REM Prepare folder name for test
(for %%a in (%_threads%) do (

echo "Creating %USERPROFILE%\Desktop\Reports\%_testfilename%\%timestamp%\%%a\html"
MKDIR "%USERPROFILE%\Desktop\Reports\%_testfilename%\%timestamp%\%%a\html"

echo.
echo "==============================================================="
echo " CURRENT THREAD COUNT: %%a thread(s)"
echo "============================================================="
echo.

CALL jmeter -n -t "%USERPROFILE%\Desktop\Script\%_testfilename%.jmx" -Jthreads=%%a -Jduration=%_testduration% -l "%USERPROFILE%\Desktop\Reports\%_testfilename%\%timestamp%\%%a\%_testfilename%.csv" -e -o "%USERPROFILE%\Desktop\Reports\%_testfilename%\%timestamp%\%%a\html" 
timeout %_restduration%
))
goto:eof