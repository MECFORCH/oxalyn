@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul 2>&1
title Oxalyn-64 Windows Build

echo.
echo ╔══════════════════════════════════════════════════════╗
echo ║          Oxalyn-64 — Windows Build Script            ║
echo ╚══════════════════════════════════════════════════════╝
echo.

:: ── MSYS2 / MinGW64 yollarını bul ───────────────────────────────────
set MSYS2_PATHS=C:\msys64\mingw64\bin;C:\msys64\usr\bin;C:\msys2\mingw64\bin;C:\msys2\usr\bin;C:\tools\msys64\mingw64\bin;C:\tools\msys64\usr\bin

:: PATH'e ekle (zaten yoksa)
echo [*] MinGW araçları aranıyor...
where gcc >nul 2>&1
if %errorlevel% neq 0 (
    set "PATH=%MSYS2_PATHS%;%PATH%"
    where gcc >nul 2>&1
    if !errorlevel! neq 0 (
        echo.
        echo [HATA] gcc bulunamadı!
        echo.
        echo  MSYS2 kurulu değil veya PATH'e eklenmemiş.
        echo  Çözüm:
        echo    1. https://www.msys2.org/ adresinden MSYS2 kur
        echo    2. MSYS2 terminalinde şunu çalıştır:
        echo       pacman -S mingw-w64-x86_64-gcc mingw-w64-x86_64-make
        echo    3. Bu script'i tekrar çalıştır
        echo.
        pause
        exit /b 1
    )
)

:: Sürüm bilgisi
for /f "tokens=*" %%v in ('gcc --version 2^>^&1 ^| findstr /i "gcc"') do (
    echo [OK] %%v
    goto :gcc_found
)
:gcc_found

where make >nul 2>&1
if %errorlevel% neq 0 (
    echo [HATA] make bulunamadı! MSYS2'den mingw-w64-x86_64-make kur.
    pause
    exit /b 1
)
echo [OK] make bulundu

:: ── Derleme seçenekleri ──────────────────────────────────────────────
echo.
echo  Ne derlemek istiyorsun?
echo.
echo   [1] Tam sistem   (kernel + compiler + simülatör)
echo   [2] Sadece kernel
echo   [3] Sadece simülatör
echo   [4] Pencereli simülatör  (Win32 GDI — SDL2 gerekmez)
echo   [5] Pencereli simülatör  (SDL2)
echo   [6] Çıkış
echo.
set /p CHOICE="Seçim [1-6]: "

if "%CHOICE%"=="1" goto :build_all
if "%CHOICE%"=="2" goto :build_kernel
if "%CHOICE%"=="3" goto :build_sim
if "%CHOICE%"=="4" goto :build_gui_win32
if "%CHOICE%"=="5" goto :build_gui_sdl2
if "%CHOICE%"=="6" goto :end
echo [HATA] Geçersiz seçim
goto :end

:: ── Tam sistem ───────────────────────────────────────────────────────
:build_all
echo.
echo [*] Tam sistem derleniyor...
echo.
make CC=gcc build
if %errorlevel% neq 0 goto :fail
goto :done

:: ── Sadece kernel ────────────────────────────────────────────────────
:build_kernel
echo.
echo [*] Kernel derleniyor...
echo.
make CC=gcc -C kernel host
if %errorlevel% neq 0 goto :fail
make CC=gcc -C kernel oxalyn
if %errorlevel% neq 0 goto :fail
goto :done

:: ── Sadece simülatör ─────────────────────────────────────────────────
:build_sim
echo.
echo [*] Simülatör derleniyor...
echo.
make CC=gcc simulator
if %errorlevel% neq 0 goto :fail
goto :done

:: ── Win32 GDI pencereli simülatör ────────────────────────────────────
:build_gui_win32
echo.
echo [*] Pencereli simülatör (Win32 GDI) derleniyor...
echo.
make CC=gcc sim-gui-win32
if %errorlevel% neq 0 goto :fail
goto :done

:: ── SDL2 pencereli simülatör ─────────────────────────────────────────
:build_gui_sdl2
echo.
echo [*] SDL2 kontrolü yapılıyor...
where sdl2-config >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo [UYARI] SDL2 bulunamadı. MSYS2'de şunu çalıştır:
    echo   pacman -S mingw-w64-x86_64-SDL2
    echo.
    pause
    exit /b 1
)
echo.
echo [*] Pencereli simülatör (SDL2) derleniyor...
echo.
make CC=gcc sim-gui
if %errorlevel% neq 0 goto :fail
goto :done

:: ── Sonuçlar ─────────────────────────────────────────────────────────
:done
echo.
echo ╔══════════════════════════════════════════════════════╗
echo ║              Derleme başarıyla tamamlandı!           ║
echo ╠══════════════════════════════════════════════════════╣
echo ║                                                      ║
if exist "build\sim.exe"        echo ║  build\sim.exe          → Terminal simülatör       ║
if exist "build\sim-gui-win32.exe" echo ║  build\sim-gui-win32.exe → Pencereli simülatör  ║
if exist "build\sim-gui.exe"    echo ║  build\sim-gui.exe      → SDL2 simülatör           ║
if exist "build\compiler.exe"   echo ║  build\compiler.exe     → Oxalyn compiler          ║
if exist "kernel\hilal_bis_host.exe" echo ║  kernel\hilal_bis_host.exe → Kernel test      ║
echo ║                                                      ║
echo ║  Kullanım:                                           ║
echo ║    build\sim.exe path\to\program.bin                 ║
echo ║    build\sim-gui-win32.exe path\to\program.bin       ║
echo ║                                                      ║
echo ╚══════════════════════════════════════════════════════╝
echo.
pause
exit /b 0

:fail
echo.
echo ╔══════════════════════════════════════════════════════╗
echo ║              [HATA] Derleme başarısız!               ║
echo ╠══════════════════════════════════════════════════════╣
echo ║  Yukarıdaki hata mesajlarını kontrol et.             ║
echo ╚══════════════════════════════════════════════════════╝
echo.
pause
exit /b 1

:end
exit /b 0
