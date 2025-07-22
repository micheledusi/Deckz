@echo off
setlocal enabledelayedexpansion

:: This script syncs the current package to the packages/preview/<name> directory.
:: THIS SHOULD BE RUN FROM THE MAIN PACKAGE DIRECTORY.

set "PACKAGE_NAME=deckz"

:: Parameters:
set "CLEAN_TARGET=TRUE"


:: STEP 0: Define directories
pushd "%~dp0\.."
set "SOURCE_DIR=%CD%"
popd
set "TARGET_BASE=../typst-packages/packages/preview/%PACKAGE_NAME%"

set "TOOLS_DIR=%~dp0"
set "EXAMPLES_DIR=%SOURCE_DIR%\examples"
set "GIT_DIR=%SOURCE_DIR%\.git"

:: STEP 1: Extract version from manifest typst.toml
set "VERSION_LINE="
for /f "usebackq delims=" %%A in ("%SOURCE_DIR%\typst.toml") do (
    echo %%A | findstr /c:"version =" >nul
    if not errorlevel 1 (
        set "VERSION_LINE=%%A"
    )
)
:: STEP 1.1: Use a string substitution to extract version string
for %%B in (!VERSION_LINE!) do (
    set "VERSION=%%~B"
)
:: STEP 1.2: Remove everything before the quote
for /f "tokens=2 delims== " %%C in ("!VERSION_LINE!") do (
    set "VERSION=%%~C"
)
:: STEP 1.3: Strip surrounding quotes
set "VERSION=%VERSION:"=%"

:: STEP 1.4: Check if VERSION is empty
if "%VERSION%"=="" (
    echo [ERROR] Could not find 'version' in typst.toml
    exit /b 1
)
echo [INFO] Detected version: %VERSION%

:: STEP 1.5: Check if some file refers to a previous version
set "MISMATCH_FOUND=0"
for /r "%SOURCE_DIR%" %%F in (*) do (
    findstr /r /c:"%PACKAGE_NAME%:[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*" "%%F" >nul
    if not errorlevel 1 (
        for /f "delims=" %%L in ('findstr /n /r /c:"%PACKAGE_NAME%:[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*" "%%F"') do (
            set "LINE=%%L"
            for /f "tokens=1,* delims=:" %%N in ("!LINE!") do (
                set "LINENUM=%%N"
                set "TEXT=%%O"
                for /f "tokens=2 delims=:" %%V in ("!TEXT!") do (
                    set "REF=%%V"
                )
                for %%R in (!TEXT!) do (
                    setlocal enabledelayedexpansion
                    for /f "tokens=1,2,3 delims=:" %%A in ("!TEXT!") do (
                        set "MATCHED=!PACKAGE_NAME!:%%B"
                        set "VER=%%B"
                        if not "!MATCHED!"=="%PACKAGE_NAME%:%VERSION%" (
                            echo [ERROR] Version reference mismatch in file: %%F, line !LINENUM!: !MATCHED! (expected %PACKAGE_NAME%:%VERSION%)
                            set "MISMATCH_FOUND=1"
                        )
                    )
                    endlocal
                )
            )
        )
    )
)
if "%MISMATCH_FOUND%"=="1" (
    echo [ERROR] One or more files refer to an old version.
    exit /b 1
)

:: STEP 2.0: Define target directory
set "TARGET_DIR=%TARGET_BASE%/%VERSION%/"

:: STEP 2.1: Clean target dir
if "%CLEAN_TARGET%"=="TRUE" (
    if exist "%TARGET_DIR%" (
        echo [INFO] Cleaning target directory...
        rmdir /s /q "%TARGET_DIR%"
    )
) else (
    echo [INFO] Skipping cleaning of target directory.
)

:: STEP 2.2: Remove trailing backslash from dirs
if "%SOURCE_DIR:~-1%"=="\" set "SOURCE_DIR=%SOURCE_DIR:~0,-1%"
if "%TOOLS_DIR:~-1%"=="\" set "TOOLS_DIR=%TOOLS_DIR:~0,-1%"
if "%EXAMPLES_DIR:~-1%"=="\" set "EXAMPLES_DIR=%EXAMPLES_DIR:~0,-1%"
if "%GIT_DIR:~-1%"=="\" set "GIT_DIR=%GIT_DIR:~0,-1%"


:: STEP 3: Copy files (excluding tools folder, this script, and .git directory)
echo [INFO] Copying files to: %TARGET_DIR%
robocopy "%SOURCE_DIR%" "%TARGET_DIR%" /E /XD "%TOOLS_DIR%" "%GIT_DIR%" "%EXAMPLES_DIR%" /XF "%~f0"

if %ERRORLEVEL% GEQ 8 (
    echo [ERROR] robocopy failed.
    exit /b 1
)

:: STEP 4: End
echo [SUCCESS] Package synced to: %TARGET_DIR%
exit /b 0
