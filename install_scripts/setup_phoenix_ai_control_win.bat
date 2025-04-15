@echo off
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

:: Help screen - allowing help without admin check
if "%~1"=="/?" goto :help
if "%~1"=="--help" goto :help

:: Admin check only if not showing help
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script must be run as Administrator.
    echo Run with --help for usage information.
    pause
    exit /b 1
)

:: Parse args
set "managedByEmail="
set "allowedUsers="
:parse_args
if "%~1"=="" goto :continue
if "%~1"=="--managedByEmail" (
    shift
    set "managedByEmail=%~1"
    shift
    goto :parse_args
)
if "%~1"=="--allowedUsers" (
    shift
    set "allowedUsers=%~1"
    shift
    goto :parse_args
)
echo Unknown option: %~1
goto :help
:continue
:: Paths
set "TARGET_DIR=C:\Program Files\Phoenix AI Control"
set "CONFIG_FILE=%TARGET_DIR%\config.json"
:: Create folder if missing
if not exist "%TARGET_DIR%" (
    mkdir "%TARGET_DIR%"
)
:: Start writing JSON
(
echo {
echo     "disableAI": true
:: Conditionally write managedByEmail
if defined managedByEmail (
    echo     ,"managedByEmail": "%managedByEmail%"
)
:: Conditionally write allowedUsers
if defined allowedUsers (
    echo     ,"allowedUsers": [
    set first=1
    for %%U in (%allowedUsers%) do (
        if "!first!"=="1" (
            set first=0
            echo         "%%U"
        ) else (
            echo         ,"%%U"
        )
    )
    echo     ]
)
echo }
) > "%CONFIG_FILE%"
echo.
echo Phoenix AI control config written to:
echo %CONFIG_FILE%
pause
exit /b 0
:help
echo.
echo Phoenix AI Control Setup Script
echo -------------------------------
echo Usage:
echo     setup_phoenix_ai_control_win.bat [--managedByEmail <email>] [--allowedUsers <user1,user2,...>]
echo.
echo Options:
echo     --managedByEmail   Optional. Admin email who manages AI policy.
echo     --allowedUsers     Optional. Comma-separated list of Windows usernames allowed to use AI.
echo.
echo Examples:
echo     setup_phoenix_ai_control_win.bat --managedByEmail admin@example.com
echo     setup_phoenix_ai_control_win.bat --allowedUsers Alice,Bob
echo     setup_phoenix_ai_control_win.bat --managedByEmail admin@example.com --allowedUsers Alice,Bob
echo.
echo Help:
echo     setup_phoenix_ai_control_win.bat --help
echo     setup_phoenix_ai_control_win.bat /?
echo.
echo NOTE: Administrator privileges are required to make changes,
echo       but not to view this help information.
echo.
exit /b 1
