@echo off
Title System Information Collector - by @desihaceker08
setlocal

set "output=C:\Path\to\system_info.csv"  
:: Ensure the file location is correct and writable

:: Get current date and time
for /f "tokens=2 delims==" %%a in ('wmic os get localdatetime /value') do set "datetime=%%a"
set "datetime=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2% %datetime:~8,2%:%datetime:~10,2%:%datetime:~12,2%"

:: Create CSV file with headers
echo "Category","Detail","Value","Date and Time" > "%output%"

:: CPU Info
echo "CPU Info","Model","%datetime%" >> "%output%"
wmic cpu get caption | findstr /v "Caption" | for /f "tokens=*" %%a in ('wmic cpu get caption') do echo "CPU Info","Model",%%a,"%datetime%" >> "%output%"

:: Memory Info
echo "Memory Info","Total Physical Memory","%datetime%" >> "%output%"
for /f "tokens=*" %%b in ('systeminfo ^| find "Total Physical Memory"') do echo "Memory Info","Total Physical Memory",%%b,"%datetime%" >> "%output%"

:: Disk Usage
echo "Disk Usage","Drive","Total Size","Free Space","%datetime%" >> "%output%"
for /f "tokens=1,2,3" %%c in ('wmic logicaldisk get caption,size,freespace ^| findstr /v "Caption"') do echo "Disk Usage",%%c,%%d,%%e,"%datetime%" >> "%output%"

:: Network Speed
echo "Network Speed","Adapter","Received Bytes","Sent Bytes","%datetime%" >> "%output%"
powershell -Command "Get-NetAdapterStatistics | Format-Table -Property Name,ReceivedBytes,SentBytes | Out-String -Stream | Select-String -Pattern '^ *[^\s]' | ForEach-Object {$_ -replace '\s{2,}',','}" | findstr /v "Name" | for /f "tokens=1,2,3" %%f in ('powershell -Command "Get-NetAdapterStatistics | Format-Table -Property Name,ReceivedBytes,SentBytes | Out-String -Stream | Select-String -Pattern '^ *[^\s]' | ForEach-Object {$_ -replace '\s{2,}',','}"') do echo "Network Speed",%%f,%%g,%%h,"%datetime%" >> "%output%"

:: Real-Time RAM Usage
echo "Real-Time RAM Usage","Available MBytes","%datetime%" >> "%output%"
for /f "tokens=1,2" %%i in ('powershell -Command "Get-Counter ''\Memory\Available MBytes'' | Select-Object -ExpandProperty CounterSamples | ForEach-Object { $_.InstanceName + ',' + $_.CookedValue }"') do echo "Real-Time RAM Usage",%%i,%%j,"%datetime%" >> "%output%"

echo Information saved to %output%.
pause
::When show press any key to continue ... Then its complete

