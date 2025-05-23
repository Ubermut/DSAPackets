@echo off
setlocal enabledelayedexpansion
for /f "usebackq tokens=1,* delims==" %%A in (".env") do (
    if /i "%%A"=="BASE_PATH" set "BASE_PATH=%%B"
	if /i "%%A"=="TYPE" set "TYPE=%%B"
	if /i "%%A"=="ID" set "ID=%%B"
	if /i "%%A"=="TYPEPATH" set "TYPEPATH=%%B"
)
if "%BASE_PATH%"=="" (
    for /f "usebackq delims=" %%A in (`fvtt configure get dataPath`) do (
		set "BASE_PATH=%%A"
	)
)
if "%BASE_PATH%"=="" (
    set /p BASE_PATH=Could not find BASE_PATH in .env file. Enter the base path: 
)
if "%TYPE%"=="" (
    set /p TYPE=Could not find TYPE in .env file. Enter the base path: 
)
if "%TYPEPATH%"=="" (
    set /p TYPEPATH=Could not find TYPEPATH in .env file. Enter the base path: 
)
if "%ID%"=="" (
    set /p TYPE=Could not find ID in .env file. Enter the base path: 
)
set "DEST_BASE=%cd%\packs"
set "PACKET_PATH=%BASE_PATH%\Data\%TYPEPATH%\%ID%\packs"
echo Listing folders in: "%PACKET_PATH%"
echo Base Destination "%DEST_BASE%"
for /d %%F in ("%PACKET_PATH%\*") do (
    set "DEST_PATH=!DEST_BASE!\%%~nxF\_source"
    echo Processing: %%~nxF copy to !DEST_PATH!
    call fvtt package unpack "%%~nxF" --id "dsa-packets" --type "Module"
    if exist "%%~fF\_source" (
        if not exist !DEST_PATH! (
            mkdir "!DEST_PATH!"
        )
		if exist "!DEST_PATH!" (
            echo Deleting contents of "!DEST_PATH!"
            del /Q "!DEST_PATH!\*" >nul 2>&1
            for /d %%D in ("!DEST_PATH!\*") do rd /S /Q "%%D"
        )
        echo Copying "%%~fF\_source" to "!DEST_PATH!"
        xcopy /E /I /Y "%%~fF\_source" "!DEST_PATH!\"
    ) else (
        echo No _source folder in "%%~fF"
    )
   
)
 set /p TEST=Exit 
endlocal