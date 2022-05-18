# SCOOP: ######################################################################
# Definitions: ################################################################
$Bucket = @(
    "extras"
    "main"
    "nerd-fonts"
    "nirsoft"
    "sysinternals"
    "versions"
)

# Counters: -------------------------------------------------------------------
[int]$Counter = 0
[int]$CounterTotal = $Collection.Count
[int]$CounterErrors = 0

# Scoop Installation: ---------------------------------------------------------
Write-Host -ForegroundColor Green "[ SCOOP ]"
Write-Host -ForegroundColor Cyan "Scoop Installation..."

$Result = (Get-Command scoop) ? ("Installed") : ($null)

switch ($Result) {
    "Installed" {
        Write-Host ("{0}{1}" -f $([Char]9), "Scoop Installed. Updating...")
        scoop update
    }
    $null {
        Write-Host ("{0}{1}" -f $([Char]9), "Installing Scoop...")
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-WebRequest get.scoop.sh | Invoke-Expression
    }
    Default {
        Write-Host ("{0}{1}" -f $([Char]9), "Error Handling...")
    }
}

# aria2: ----------------------------------------------------------------------
try {
    Write-Host -ForegroundColor Cyan "aria2 Installation..."
    Write-Host ("{0}{1}" -f $([Char]9), "Installing aria2...")
    scoop install aria2

    Write-Host ("{0}{1}" -f $([Char]9), "Configuring aria2...")
    scoop config aria2-warning-enabled false
    scoop config aria2-options @('--check-certificate=false')

} catch {
    { 1:<#Do this if a terminating exception happens#> }
}

# Buckets: --------------------------------------------------------------------
Write-Host -ForegroundColor Cyan "Adding Scoop Bucket(s) [$($Bucket.Count)]..."
foreach ($item in $Bucket) {
    try {
        Write-Host "$([Char]9) Bucket: $item"
        scoop bucket add $item

    } catch {
        { 1:<#Do this if a terminating exception happens#> }
    }

}

