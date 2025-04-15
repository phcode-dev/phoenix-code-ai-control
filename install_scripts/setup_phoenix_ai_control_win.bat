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
set "disableAI=false"
:parse_args
if "%~1"=="" goto :continue
if "%~1"=="--managedByEmail" (
    shift
    set "managedByEmail=%~1"
    :: Check if email is the placeholder or empty
    if "%managedByEmail%"=="school.admin@example.edu" (
        echo Error: Please enter a valid admin email address.
        echo school.admin@example.edu is only meant as an example!
        exit /b 1
    )
    if "%managedByEmail%"=="" (
        echo Error: Email address cannot be empty.
        echo Example: --managedByEmail school.admin@example.edu
        exit /b 1
    )
    shift
    goto :parse_args
)
if "%~1"=="--allowedUsers" (
    shift
    set "allowedUsers=%~1"
    shift
    goto :parse_args
)
if "%~1"=="--disableAI" (
    set "disableAI=true"
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
echo     "disableAI": %disableAI%
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
echo.
echo Configuration contents:
echo ----------------------
type "%CONFIG_FILE%"
echo ----------------------
echo.
echo NOTE: Running this script again will overwrite any previous configuration.
echo       Only the latest settings will be preserved.
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
echo     --managedByEmail   Optional. Admin email who manages AI policy. Can be used in your
echo                        Phoenix managed AI dashboard to selectively enable features and
echo                        manage usage quotas.
echo     --allowedUsers     Optional. Comma-separated list of Windows usernames allowed to use AI.
echo     --disableAI        Optional. If present, AI will be disabled by default.
echo                        If not present, AI will be enabled.
echo.
echo Examples:
echo     setup_phoenix_ai_control_win.bat --managedByEmail admin@example.com
echo     setup_phoenix_ai_control_win.bat --allowedUsers Alice,Bob
echo     setup_phoenix_ai_control_win.bat --managedByEmail admin@example.com --allowedUsers Alice,Bob --disableAI
echo.
echo Help:
echo     setup_phoenix_ai_control_win.bat --help
echo     setup_phoenix_ai_control_win.bat /?
echo.
echo Important:
echo     Running this script will overwrite any previous configuration.
echo     Only the latest settings will be preserved.
echo.

echo.
exit /b 1
