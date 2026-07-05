@echo off
rem Native Windows build for ecloop (no WSL / Linux required).
rem Requires a MinGW-w64 toolchain (gcc or clang) on PATH, e.g. from MSYS2
rem (https://www.msys2.org) or https://winlibs.com. MSVC is not supported
rem because the code uses GCC/Clang extensions (__uint128_t, statement exprs).

setlocal

if "%CC%"=="" set CC=gcc

set CFLAGS=-O3 -ffast-math -march=native -Wall -Wextra -pthread
set LDFLAGS=-lpthread -lbcrypt

echo Building with %CC% %CFLAGS%
%CC% %CFLAGS% main.c -o ecloop.exe %LDFLAGS%
if errorlevel 1 (
  echo Build failed.
  exit /b 1
)

echo Built ecloop.exe
endlocal
