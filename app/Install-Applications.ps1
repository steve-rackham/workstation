# Install Applications: #######################################################
# Definitions: ################################################################

$Collection = @(
    "7zip"
    "vscode"
    "pshazz"
    "pwsh"
    "curl"
    "sudo"
    "starship"
)

# Counters: -------------------------------------------------------------------
Write-Host -ForegroundColor Cyan "[ INSTALL APPLICATIONS ]"
Write-Host -ForegroundColor Cyan "Installing Applications [ $($Collection.Count) ]..."

foreach ($item in $Collection) {
    Write-Host ("{0}{1}" -f $([Char]9), $item)
    scoop install $item

} # END foreach ($item in $UWP)

Write-Host -ForegroundColor Cyan "[ INSTALL APPLICATIONS ] Completed. Processed [ $Counter of $CounterTotal ] with [ $CounterErrrors ]"


