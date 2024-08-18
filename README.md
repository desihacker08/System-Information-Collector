# System-Information-Collector

A simple batch script for collecting and exporting system information to a CSV file. This script captures various system metrics, including CPU information, memory usage, disk usage, network speed, real-time RAM usage, and real-time location.

## Features
<img src="https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExeTV5d24xM3RodnV1OHk2MGhhM2FxN3l0NXJxaWpsdXRuOGtlN3ppdiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/3o7bufkPz3LRof205G/giphy.webp" width="32%" align="right">

- **CPU Information**: Model and details of the CPU.
- **Memory Information**: Total physical memory.
- **Disk Usage**: Drive, total size, and free space.
- **Network Speed**: Adapter statistics, received bytes, and sent bytes.
- **Real-Time RAM Usage**: Available memory in megabytes.
- **Real-Time Location**: IP address, city, region, and country.

## Prerequisites

- Windows operating system
- PowerShell (included with Windows)
- Internet connection for location data

## Script Details

### File Path
File save to **Excel** format. if you change the format then you code you can change file extensation *(.txt)* and another files. 

Update the `output` variable in the script to specify where you want the CSV file to be saved:

```batch
set "output=E:\Programming\BashScript\add\system_info.csv"
```
### Date and Time
The script captures the current date and time in the format **YYYY-MM-DD HH:MM:SS**.

## How to Use
1. **Save the Script:** Save the batch script as `system_info_collector.bat` (or any name you prefer).

2. **Run the Script:** Double-click the system_info_collector.bat file to execute it. The script will generate a CSV file with the collected information.

3. **Check Output:** Open the CSV file specified in the output variable with a spreadsheet application like Microsoft Excel to view the collected data.


## Example Output
  <img src="https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExN2JjOXF5cnQ5NnJ1Y3gxdHZkbGM0dDlsbjU4cXBjNHNtaXo3amhzNSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/qjj4xrA1STjfa/giphy.webp"  width="25%" align="right">


**The resulting CSV file will contain the following columns:**

- **Category:** Type of information collected (e.g., CPU Info, Memory Info).

- **Detail:** Specific details about the information (e.g., Model, Total Physical Memory).
  
- **Value:** The actual value of the collected information.
  
- **Date and Time:** The date and time when the data was collected.

## In this Script 👇
```
@echo off
Title System Information Collector - by @desihaceker08
setlocal

set "output=E:\Programming\BashScript\add\system_info.csv"  
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
```
## Troubleshooting
- **Permissions:** Ensure you have permission to write to the specified path.

- **PowerShell Output:** Verify that PowerShell commands return the expected results.

- **File Path:** Check that the file path in the output variable is correct and accessible.


## License
This script is provided as-is. You can modify and use it for personal or educational purposes.

```
This format will present your information clearly and concisely when viewed on GitHub or other Markdown-rendering platforms. Feel free to adjust any details or add additional sections as needed.
```





