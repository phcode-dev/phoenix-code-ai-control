@echo off
:: Phoenix AI Control – Windows setup script
:: Flags: --managedByEmail, --allowedUsers, --disableAI, --help
:: Writes JSON to:  C:\Program Files\Phoenix AI Control\config.json
:: -------------------------------------------------------------------------

setlocal EnableDelayedExpansion

:: ───────────────────────── Defaults ───────────────────────────────────────
set "managedByEmail="
set "allowedUsers="
set "disableAI=false"

:: ──────────────────────── Help first ──────────────────────────────────────
if /I "%~1"=="--help" goto :show_help

:: ─────────────── Require Administrator privileges ────────────────────────
>nul 2>&1 net session || (
    echo.
    echo This script must be run as **Administrator**.
    exit /b 1
)

:: ───────────────────── Parse CLI arguments ────────────────────────────────
:parse_args
if "%~1"=="" goto :after_parse
if /I "%~1"=="--managedByEmail" (
    set "managedByEmail=%~2"
    if "%managedByEmail%"=="school.admin@example.edu" (
        echo Error: please provide a real admin email address.
        exit /b 1
    )
    shift
) else if /I "%~1"=="--allowedUsers" (
    set "allowedUsers=%~2"
    shift
) else if /I "%~1"=="--disableAI" (
    set "disableAI=true"
) else (
    echo Unknown option: %~1
    goto :show_help
)
shift
goto :parse_args

:after_parse
:: ───────────────────── Target paths ───────────────────────────────────────
set "TARGET_DIR=C:\Program Files\Phoenix AI Control"
set "CONFIG_FILE=%TARGET_DIR%\config.json"
if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"

:: ───────────────────── Build JSON string ──────────────────────────────────
REM 1. base object  ->  {"disableAI": false
set json_content={^"disableAI^": %disableAI%

REM 2. optional managedByEmail
if defined managedByEmail (
    set json_content=%json_content%, ^"managedByEmail^": ^"%managedByEmail%^"
)

REM 3. optional allowedUsers
if defined allowedUsers (
    set json_content=%json_content%, ^"allowedUsers^": [
    set first=1
    for %%U in (%allowedUsers:,= %) do (
        if !first! equ 1 (
            set json_content=!json_content!^"%%U^"
            set first=0
        ) else (
            set json_content=!json_content!, ^"%%U^"
        )
    )
    set json_content=!json_content!]
)

REM 4. close object  ->  ... }
set json_content=!json_content!}

:: ───────────────────── Write file ─────────────────────────────────────────
> "%CONFIG_FILE%" echo(!json_content!

:: ───────────────────── Show result ────────────────────────────────────────
echo.
echo Phoenix AI control config written to:
echo   "%CONFIG_FILE%"
echo.
echo Configuration contents:
echo ----------------------
type "%CONFIG_FILE%"
echo ----------------------
echo.
echo NOTE: Running this script again overwrites the previous configuration.
exit /b 0


:show_help
echo.
echo Phoenix AI Control Setup Script
echo --------------------------------
echo Usage:
echo   setup_phoenix_ai_control_windows.bat [--managedByEmail ^<email^>] [--allowedUsers ^<u1,u2,...^>] [--disableAI]
echo.
echo Options:
echo   --managedByEmail   Admin email for AI policy management (optional)
echo   --allowedUsers     Comma‑separated list of Windows usernames (optional)
echo   --disableAI        If present, AI is disabled by default (optional)
echo   --help             Show this help
echo.
echo Examples:
echo   setup_phoenix_ai_control_windows.bat --managedByEmail admin@example.com
echo   setup_phoenix_ai_control_windows.bat --allowedUsers alice,bob
echo   setup_phoenix_ai_control_windows.bat --managedByEmail admin@example.com --allowedUsers alice,bob --disableAI
echo.
echo Running this script overwrites any previous configuration.
exit /b 1
