param ($service, $outputfile)

$CPUPercent = @{
Label = "CPUUsed"
Expression = {
    $SecsUsed = (New-Timespan -Start $_.StartTime).TotalSeconds
    “{0:P}” -f [Math]::Round($_.CPU * 10 / $SecsUsed)
}
}

$CPU= @{
Label ="CPU" 
Expression = {
“{0:N2}” -f $_.CPU
}
}

$MemUsage = @{
Label ="RAM(MB)" 
Expression = {
[Math]::Round(($_.WS / 1MB),2)
}
}

$timestamp = @{
Label = "Timestamp"
Expression = {
Get-Date -format “yyyyMMdd_HHmmss”
}
}

$PID_Name = @{
Label = "TM1 Instance"
Expression = {
$fullname=Get-WmiObject -Class Win32_Service -Filter "Name LIKE '$service'" | Select-Object -ExpandProperty Name
$fullname.Remove(0,5)
}
}

$id = Get-WmiObject -Class Win32_Service -Filter "Name LIKE '$service'" | Select-Object -ExpandProperty ProcessId
$table = Get-Process -Id $id | Select-Object -Property $timestamp, $PID_Name, $CPU, $CPUPercent, $MemUsage
$table | select * | Export-CSV $outputfile -NoTypeInformation -Append