# Remove Unwanted UWP Applications: ###########################################
# Definitions: ################################################################
$Collection = @(
    "Microsoft.BingFinance",
    "Microsoft.3DBuilder",
    "Microsoft.BingNews",
    "Microsoft.BingSports",
    "Microsoft.BingWeather",
    "Microsoft.CommsPhone",
    "Microsoft.Getstarted",
    "Microsoft.WindowsMaps",
    "*MarchofEmpires*",
    "Microsoft.GetHelp",
    "Microsoft.Messaging",
    "*Minecraft*",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.OneConnect",
    "Microsoft.WindowsPhone",
    "Microsoft.WindowsSoundRecorder",
    "*Solitaire*",
    "Microsoft.MicrosoftStickyNotes",
    "Microsoft.Office.Sway",
    "Microsoft.XboxApp",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "Microsoft.NetworkSpeedTest",
    "Microsoft.FreshPaint",
    "Microsoft.Print3D",
    "*Autodesk*",
    "*BubbleWitch*",
    "king.com*",
    "G5*",
    "*Dell*",
    "*Facebook*",
    "*Keeper*",
    "*Netflix*",
    "*Twitter*",
    "*Plex*",
    "*.Duolingo-LearnLanguagesforFree",
    "*.EclipseManager",
    "ActiproSoftwareLLC.562882FEEB491", # Code Writer
    "*.AdobePhotoshopExpress"
)

# Counters: -------------------------------------------------------------------
[int]$Counter = 0
[int]$CounterTotal = $Collection.Count
[int]$CounterErrors = 0

Write-Host -ForegroundColor Cyan "[ UWP CONFIGURATION ]"


Write-Host -ForegroundColor Cyan "Remove Unnecessary App Packages [ $($Collection.Count) ]..."

foreach ($item in $Collection) {
    try {
        Write-Host ("{0}{1}" -f $([Char]9), $item)
        [void](Get-AppxPackage $item -AllUsers -ErrorAction Stop | Remove-AppxPackage -ErrorAction Stop)
        [void](Get-AppxProvisionedPackage -Online -ErrorAction Stop  | Where-Object DisplayName -Like $item -ErrorAction Stop | Remove-AppxProvisionedPackage -Online -ErrorAction Stop)


        # STATUS :---------------------------------------------------------
        $Counter++

        # Write-Progress Operation.
        $WriteProgressParams = @{
            Activity         = "Remove Unnecessary App Packages..."
            Status           = "Progress: $Counter of $CounterTotal"
            CurrentOperation = "Processing: $item"
            PercentComplete  = (($Counter / $CounterTotal) * 100)

        } # END WriteProgressParams

        Write-Progress @WriteProgressParams

    } catch {
        $CounterErrors++
        { 1:<#Do this if a terminating exception happens#> }
    }

} # END foreach ($item in $UWP)

Write-Host -ForegroundColor Cyan "[ UWP CONFIGURATION ] Completed. Processed [ $Counter of $CounterTotal ] with [ $CounterErrrors ]"

