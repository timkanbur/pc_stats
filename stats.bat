@echo off & setlocal EnableDelayedExpansion

:start
title PC Stats
color 77
cls

:dashboard
echo.
echo.
echo                 	  PC Info %computername%:
echo            	     =================================
echo.
echo.
echo.
echo.
echo.
echo ===============================PC Specs:=========================================
echo CPU:
wmic cpu get name
echo.
echo GPU:
wmic path win32_VideoController get name 
echo.
echo Main Board:
wmic baseboard get product
echo.
echo RAM:
wmic memorychip get devicelocator, manufacturer, capacity, speed 
echo.
wmic ComputerSystem get TotalPhysicalMemory && wmic OS get FreePhysicalMemory,TotalVirtualMemorySize,FreeVirtualMemory
echo.
echo ===============================Networking:=========================================
for /f "skip=1 tokens=2 delims=[]" %%* in ('ping.exe -n 1 -4 %computername%') Do (set "IP4=%%*") >NUL
echo IPv4: %IP4%
for /f "skip=1 tokens=2 delims=[]" %%* in ('ping.exe -n 1 -6 %computername%') Do (set "IP6=%%*") >NUL
echo IPv6: %IP6%
echo.

set /p asw1="Weitere Informationen? (y/n) "
if %asw1%==y goto ext_dashboard
if %asw1%==n goto end

:ext_dashboard
cls
echo ===============================System:=================================================
Systeminfo
echo.
pause

:tar_dashboard
cls
echo.
echo   [1] Benutzer
echo   [2] BIOS
echo   [3] Netzwerk
echo   [4] Prozesse
echo   [5] Treiber
echo   [6] Tools
echo   [7] Beenden
echo.

set asw2=0
set /p asw2="Bestimmte Systeminfo?: "
if %asw2%==1 goto user
if %asw2%==2 goto bios
if %asw2%==3 goto ipconf
if %asw2%==4 goto tasks
if %asw2%==5 goto driver
if %asw2%==6 goto tools
if %asw2%==7 goto end

:user
echo ================================User:=================================================
net user
echo.
quser.exe
echo.
pause
goto tar_dashboard

:bios
echo ================================BIOS:=================================================
wmic BIOS Get /Format:list
echo.
pause
goto tar_dashboard

:ipconf
echo ==============================Netzwerk:===============================================
ipconfig /all
echo.
netsh firewall show opmode
echo.
pause
goto tar_dashboard

:tasks
echo ==============================Prozesse:===============================================
tasklist
echo.
pause
goto tar_dashboard

:driver
echo ==============================Treiber:===============================================
driverquery.exe /fo list
echo.
pause
goto tar_dashboard

:tools
cls
echo.
echo   [1] Systemdiagnose (dxdiag)
echo   [2] Geraetemanager (devmgmt)
echo   [3] Partitionsmanager (diskmgmt)
echo   [4] Beenden
echo.

set asw3=0
set /p asw1="Tool auswählen: "
if %asw3%==1 start dxdiag
if %asw3%==2 start devmgmt.msc
if %asw3%==3 start diskmgmt.msc
if %asw3%==4 goto end

:end
color 4
echo.
echo PC  Stats wird beendet
timeout 2 >NUL