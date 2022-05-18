# Definitions: ################################################################
$Services = @(
    "diagnosticshub.standardcollector.service" # Diagnostics Hub Service
    "DiagTrack"                                # Diagnostics Tracking Service
    "dmwappushservice"                         # WAP Push Message Routing Service
    "SharedAccess"                             # Internet Connection Sharing
    "WMPNetworkSvc"                            # Windows Media Player Network Sharing
    "XblAuthManager"                           # Xbox Live Auth Manager
    "XblGameSave"                              # Xbox Live Game Save Service
    "XboxNetApiSvc"                            # Xbox Live Networking Service
)

$OffSet = 0 - ($Services | Measure-Object -Maximum -Property Length).Maximum

# Counters: -------------------------------------------------------------------
[int]$Counter = 0
[int]$CounterTotal = $Collection.Count
[int]$CounterErrors = 0

# Environment: ################################################################
Write-Host -ForegroundColor Cyan "[ ENVIRONMENT CONFIGURATION ]"

# File Explorer Options: ------------------------------------------------------
try {
    Write-Host -ForegroundColor Cyan "Set File Explorer Options..."
    Write-Host ("{0}{1}" -f $([Char]9), "Show protected OS files")
    Set-WindowsExplorerOptions -EnableShowProtectedOSFiles -ErrorAction Stop;
    Write-Host ("{0}{1}" -f $([Char]9), "Show hidden files")
    Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -ErrorAction Stop;
    Write-Host ("{0}{1}" -f $([Char]9), "Show file extensions")
    Set-WindowsExplorerOptions -EnableShowFileExtensions -ErrorAction Stop;
    Write-Host ("{0}{1}" -f $([Char]9), "Expand Explorer to Working Folder")

    $RegPath = HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
    Set-ItemProperty -Path $RegPath -Name NavPaneExpandToCurrentFolder -Value 1 -ErrorAction Stop;
    Write-Host ("{0}{1}" -f $([Char]9), "Remove Quick Access")
    Set-ItemProperty -Path $RegPath -Name LaunchTo -Value 1 -ErrorAction Stop;
    Write-Host ("{0}{1}" -f $([Char]9), "Multi-Monitor Mode for the Taskbar")
    Set-ItemProperty -Path $RegPath -Name MMTaskbarMode -Value 2 -ErrorAction Stop;
} catch {
    { 1:<#Do this if a terminating exception happens#> }
}


# Services: -------------------------------------------------------------------
# Use SSH Service:
Set-Service ssh-agent -StartupType Manual

Write-Host -ForegroundColor Yellow "Disable Unnecessary Services [ $($Services.Count)]..."

foreach ($item in $Services) {
    try {
        Write-Host ("{0}{1}" -f $([Char]9), $item)
        Get-Service -Name $item -ErrorAction Stop | Set-Service -Status Stopped -StartupType Disabled -ErrorAction Stop

    } catch {
        $CounterErrors++
        { 1:<#Do this if a terminating exception happens#> }
    }

    # STATUS :---------------------------------------------------------
    $Counter++

    # Write-Progress Operation.
    WriteProgressParams = @{
        Activity         = "Disabling Services..."
        Status           = "Progress: $Counter of $CounterTotal"
        CurrentOperation = "Processing: $item"
        PercentComplete  = (($Counter / $CounterTotal) * 100)

    } # END WriteProgressParams

    Write-Progress @WriteProgressParams

}

Write-Host -ForegroundColor Cyan "[ CONFIGURE ENVIRONMENT ] Completed. Processed [ $Counter of $CounterTotal ] with [ $CounterErrrors ]"
