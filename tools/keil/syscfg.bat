@echo off

set SYSCFG_PATH="C:\ti\sysconfig_1.24.0\sysconfig_cli.bat"

if not exist "%SYSCFG_PATH%" (
    echo.
    echo Couldn't find Sysconfig Tool %SYSCFG_PATH%
    echo.
    pause
    exit /b 1
)

echo Using Sysconfig Tool from %SYSCFG_PATH%

set PROJ_DIR=%~1
set PROJ_DIR=%PROJ_DIR:'=%

set SYSCFG_FILE=%~2
set SYSCFG_FILE=%SYSCFG_FILE:'=%

set SDK_ROOT=%PROJ_DIR%\..
echo Using SDK Root: %SDK_ROOT%

set SYSCFG_DIR=%PROJ_DIR%
set iter=0
:syscfg_search_loop
if exist "%SYSCFG_DIR%\*.syscfg" (
    IF %SYSCFG_DIR:~-1%==\ SET SYSCFG_DIR=%SYSCFG_DIR:~0,-1%
    goto syscfg_search_exit
) else if %iter% geq 5 (
	echo "Couldn't find syscfg file"
    pause
    exit /b 1
) else (
	set /a iter=%iter%+1
	set SYSCFG_DIR=%SYSCFG_DIR%..\
	goto syscfg_search_loop
)
:syscfg_search_exit

echo Using SYSCFG_DIR: %SYSCFG_DIR%

%SYSCFG_PATH% -o "%SYSCFG_DIR%" -s "%SDK_ROOT%\.metadata\product.json" --compiler keil "%SYSCFG_DIR%\%SYSCFG_FILE%"

echo Sysconfig generation completed successfully!
pause
