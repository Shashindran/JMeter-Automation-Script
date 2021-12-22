@echo off

TITLE Performance Test Auto V2

@REM Automation script for JMeter performance test
@REM Maintainer: Shashindran Vijayan shshindran@yahoo.com

@REM Values assigned from parameters passed during execution
SET _testfile=%1
SET _subdirectory=%2

@REM Set variables
SET _threads=1
SET _testduration=300
SET _restduration=180
SET /A _prev_tps=-1
SET /A _current_tps=0
SET /A _prev_whole=0
SET /A _current_whole=0

CALL :check_file

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

@REM Get current timestamp
SET timestamp=%DATE:/=-%_%TIME::=-%
SET timestamp=%timestamp: =%

@REM Print out summary of user input
echo.
echo "=========================================================================="
echo "                             Performance Test                             "
echo "=========================================================================="
echo "|| TEST FILE: %USERPROFILE%\Desktop\Automate\%_subdirectory%\%_testfile%.jmx"
echo "|| TEST DURATION: %_testduration% seconds"
echo "|| REST: %_restduration% seconds"
echo "=========================================================================="
echo.

:while
echo.
echo "==============================================================="
echo " CURRENT THREAD COUNT: %_threads% thread(s)"
echo "==============================================================="
echo.

CALL :execute_pfm
goto:eof

::
:: Check file function
::
:check_file
@REM Check whether the test file is exist
IF NOT EXIST "%USERPROFILE%\Desktop\Automate\%_subdirectory%\%_testfile%.jmx" (
  @REM Exit the program if the test file not exist
  echo Cannot find the file
  pause
  exit
)

@REM Create Reports folder in desktop if it is not exist
IF NOT EXIST "%USERPROFILE%\Desktop\Reports" MKDIR "%USERPROFILE%\Desktop\Reports"
goto:eof

::
:: strtodecimal function
::
:strtodecimal
echo TPS: %_current_tps%
for /F "tokens=1,2 delims=. " %%a in ("%_current_tps%") do (
  SET /A _current_whole=%%a
)
goto:eof

::
:: Get TPS from json file function
::
:get_tps
for /F "tokens=* USEBACKQ" %%g IN (`jq -r ".Total.throughput" %USERPROFILE%\Desktop\Reports\%_testfile%\%timestamp%\%_threads%\html\statistics.json`) do (SET "_current_tps=%%g")
goto:eof

::
:: Execute test
::
:execute_pfm
echo "Creating %USERPROFILE%\Desktop\Reports\%_testfile%\%timestamp%\%_threads%"
MKDIR "%USERPROFILE%\Desktop\Reports\%_testfile%\%timestamp%\%_threads%\html"

CALL jmeter -n -t "%USERPROFILE%\Desktop\Automate\%_subdirectory%\%_testfile%.jmx" -Jthreads=%_threads% -Jduration=%_testduration% -l "%USERPROFILE%\Desktop\Reports\%_testfile%\%timestamp%\%_threads%\%_testfile%.csv" -e -o "%USERPROFILE%\Desktop\Reports\%_testfile%\%timestamp%\%_threads%\html" 

timeout %_restduration%

SET _prev_tps=%_current_tps%
SET /A _prev_whole=%_current_whole%

CALL :get_tps
CALL :strtodecimal

@REM Increment thread count
SET /A _threads += 2

IF %_current_whole% GEQ %_prev_whole% (
  goto :while
)

goto:eof