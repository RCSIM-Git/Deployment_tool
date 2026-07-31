@echo off
rem ============================================================================
rem RCSIM Deployment Tool Build Script
rem Copyright (c) 2025-2026 RCSIM Project. All rights reserved.
rem License: Proprietary / RCSIM Standard License
rem ============================================================================
echo [RCSIM BUILD] Inicjalizacja kompilacji narzedzia wdrozeniowego...
echo [RCSIM BUILD] Upewnianie sie, ze wymagane pakiety sa zainstalowane...

set PYTHON_CMD=python
if exist "%~dp0..\..\.venv\Scripts\python.exe" (
    set PYTHON_CMD="%~dp0..\..\.venv\Scripts\python.exe"
    echo [RCSIM BUILD] Wykryto wirtualne srodowisko projektu. Uzywanie: %PYTHON_CMD%
)

%PYTHON_CMD% -c "import PyInstaller" 2>nul
if %errorlevel% neq 0 (
    echo [RCSIM BUILD] PyInstaller nie jest zainstalowany. Instalowanie...
    %PYTHON_CMD% -m pip install pyinstaller
)

%PYTHON_CMD% -c "import paramiko" 2>nul
if %errorlevel% neq 0 (
    echo [RCSIM BUILD] Paramiko nie jest zainstalowane. Instalowanie...
    %PYTHON_CMD% -m pip install paramiko cryptography pyinstaller-hooks-contrib
)

%PYTHON_CMD% -c "import flask" 2>nul
if %errorlevel% neq 0 (
    echo [RCSIM BUILD] Flask nie jest zainstalowane. Instalowanie...
    %PYTHON_CMD% -m pip install flask
)

echo [RCSIM BUILD] Uruchamianie kompilacji za pomoca build_deployment.py...
%PYTHON_CMD% "%~dp0core\build_deployment.py"

if %errorlevel% equ 0 (
    echo ============================================================================
    echo [RCSIM BUILD] SUKCES! Kompilacja zakonczona pomyslnie.
    echo [RCSIM BUILD] Plik wykonywalny znajduje sie w:
    echo               RCSIM_deployment_tool\dist\RCsimDeployment.exe
    echo ============================================================================
) else (
    echo ============================================================================
    echo [RCSIM BUILD] BLAD! Proces kompilacji zakonczyl sie niepowodzeniem.
    echo ============================================================================
)

pause
