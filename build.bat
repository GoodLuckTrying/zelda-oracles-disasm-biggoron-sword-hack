@echo off
setlocal

set "ROOT=%~dp0"
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"

set "WLA=%ROOT%\tools\wla-dx"
set "MAKEBIN=%ROOT%\tools\bin"
set "BUILD_SH=%ROOT%\tools\build_roms.sh"

if not exist "%WLA%\wla-gb.exe" (
  echo ERROR: Missing "%WLA%\wla-gb.exe"
  exit /b 1
)
if not exist "%MAKEBIN%\make.exe" (
  echo ERROR: Missing "%MAKEBIN%\make.exe"
  exit /b 1
)
if not exist "%BUILD_SH%" (
  echo ERROR: Missing "%BUILD_SH%"
  exit /b 1
)

set "BASH="
if exist "%ProgramFiles%\Git\bin\bash.exe" set "BASH=%ProgramFiles%\Git\bin\bash.exe"
if not defined BASH if exist "%ProgramFiles(x86)%\Git\bin\bash.exe" set "BASH=%ProgramFiles(x86)%\Git\bin\bash.exe"
if not defined BASH for /f "delims=" %%I in ('where bash 2^>nul') do set "BASH=%%I" & goto :have_bash
:have_bash
if not defined BASH (
  echo ERROR: Git Bash not found. Install Git for Windows, or put bash on PATH.
  exit /b 1
)

set "PY="
if exist "%LocalAppData%\Programs\Python\Python313\python.exe" set "PY=%LocalAppData%\Programs\Python\Python313"
if not defined PY if exist "%LocalAppData%\Programs\Python\Python312\python.exe" set "PY=%LocalAppData%\Programs\Python\Python312"
if not defined PY if exist "%LocalAppData%\Programs\Python\Python311\python.exe" set "PY=%LocalAppData%\Programs\Python\Python311"
if defined PY (
  if not exist "%PY%\python3.exe" copy /y "%PY%\python.exe" "%PY%\python3.exe" >nul
  set "PATH=%PY%;%PATH%"
)

where python3 >nul 2>&1
if errorlevel 1 where python >nul 2>&1
if errorlevel 1 (
  echo ERROR: Python 3 not found. Install Python 3 and run: pip install pyyaml
  exit /b 1
)

set "PATH=%MAKEBIN%;%WLA%;%PATH%"

cd /d "%ROOT%"
echo Building VANILLA Ages and Seasons from:
echo   %ROOT%
echo.

"%BASH%" "%BUILD_SH%"
set "ERR=%ERRORLEVEL%"

if %ERR% neq 0 (
  echo.
  echo Build failed with exit code %ERR%.
  exit /b %ERR%
)

echo.
echo Done:
echo   %ROOT%\ages.gbc
echo   %ROOT%\seasons.gbc
exit /b 0
