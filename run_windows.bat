@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul 2>&1
title Oxalyn-64 Çalıştır

echo.
echo ╔══════════════════════════════════════════════════════╗
echo ║           Oxalyn-64 — Windows Çalıştır               ║
echo ╚══════════════════════════════════════════════════════╝
echo.

:: Derlenmiş binary kontrol et
if not exist "build\sim.exe" (
    if not exist "build\sim" (
        echo [HATA] Simülatör bulunamadı!
        echo.
        echo  Önce derleme yapman gerekiyor:
        echo    build_windows.bat   ^(Windows^)
        echo    make build          ^(MSYS2 terminal^)
        echo.
        pause
        exit /b 1
    )
)

echo  Ne çalıştırmak istiyorsun?
echo.
echo   [1] Terminal simülatörü  (build\sim)
echo   [2] Pencereli simülatör  (build\sim-gui-win32)
echo   [3] Kernel host test     (kernel\hilal_bis_host)
echo   [4] Özel binary seç
echo.
set /p CHOICE="Seçim [1-4]: "

if "%CHOICE%"=="1" goto :run_sim
if "%CHOICE%"=="2" goto :run_gui
if "%CHOICE%"=="3" goto :run_host
if "%CHOICE%"=="4" goto :run_custom
echo Geçersiz seçim.
goto :end

:run_sim
echo.
set /p BIN="Binary yolu gir (örn: tests\test_new_isa.bin): "
if not exist "%BIN%" (
    echo [HATA] Dosya bulunamadı: %BIN%
    goto :end
)
echo [*] Çalıştırılıyor: build\sim.exe %BIN%
echo ─────────────────────────────────────────────────────
if exist "build\sim.exe" (
    build\sim.exe "%BIN%"
) else (
    build\sim "%BIN%"
)
goto :end

:run_gui
echo.
set /p BIN="Binary yolu gir (örn: tests\test_new_isa.bin): "
if not exist "%BIN%" (
    echo [HATA] Dosya bulunamadı: %BIN%
    goto :end
)
if exist "build\sim-gui-win32.exe" (
    echo [*] Çalıştırılıyor: build\sim-gui-win32.exe %BIN%
    build\sim-gui-win32.exe "%BIN%"
) else if exist "build\sim-gui.exe" (
    echo [*] Çalıştırılıyor: build\sim-gui.exe %BIN%
    build\sim-gui.exe "%BIN%"
) else (
    echo [HATA] Pencereli simülatör bulunamadı.
    echo  'build_windows.bat' ile 'Pencereli simülatör' seçeneğini derlemeyi dene.
)
goto :end

:run_host
echo.
if exist "kernel\hilal_bis_host.exe" (
    echo [*] Çalıştırılıyor: kernel\hilal_bis_host.exe
    kernel\hilal_bis_host.exe
) else if exist "kernel\hilal_bis_host" (
    echo [*] Çalıştırılıyor: kernel\hilal_bis_host
    kernel\hilal_bis_host
) else (
    echo [HATA] kernel\hilal_bis_host bulunamadı.
)
goto :end

:run_custom
echo.
set /p BIN="Binary yolu gir (örn: myprogram.bin): "
if not exist "%BIN%" (
    echo [HATA] Dosya bulunamadı: %BIN%
    goto :end
)
if exist "build\sim.exe" (
    build\sim.exe "%BIN%"
) else (
    build\sim "%BIN%"
)
goto :end

:end
echo.
pause
