function Remove-xAppPackage {
    [CmdletBinding()]
    param (

    )

    # Counters: -------------------------------------------------------------------
    [int]$Counter = 0
    [int]$CounterTotal = $Collection.Count
    [int]$CounterErrors = 0

    Write-Host -ForegroundColor Cyan "[ UWP CONFIGURATION ]"
    Write-Host -ForegroundColor Cyan "Remove Unnecessary App Packages [ $($Collection.Count) ]..."

    foreach ($item in $script:AppPackage) {
        try {
            Write-Host ("{0}{1}" -f $([Char]9), $item)
            [void](Get-AppxPackage $item -AllUsers -ErrorAction Stop | Remove-AppxPackage -ErrorAction Stop)
            [void](Get-AppxProvisionedPackage -Online -ErrorAction Stop  | Where-Object DisplayName -Like $item -ErrorAction Stop | Remove-AppxProvisionedPackage -Online -ErrorAction Stop)

        } catch {
            $CounterErrors++
            { 1:<#Do this if a terminating exception happens#> }
        }

    } # END foreach ($item in $UWP)
    Write-Host -ForegroundColor Cyan "[ UWP CONFIGURATION ] Completed. Processed [ $Counter of $CounterTotal ] with [ $CounterErrrors ]"

}

# Services: -------------------------------------------------------
function Remove-xService {
    [CmdletBinding()]
    param (

    )

    try {
        Write-Information "Disable Unnecessary Services [ $($Services.Count)]..."

        foreach ($item in $script:Services) {
            try {
                Write-Verbose ("{0}{1}" -f $([Char]9), $item)
                Get-Service -Name $item -ErrorAction Stop | Set-Service -Status Stopped -StartupType Disabled -ErrorAction Stop

            } catch {
                $CounterErrors++
                { 1:<#Do this if a terminating exception happens#> }
            }

        }

        Write-Information "[ CONFIGURE ENVIRONMENT ] Completed. Processed [ $Counter of $CounterTotal ] with [ $CounterErrrors ]"

    } catch {
        Write-Warning
        Write-Error
    }
}



function Install-ScoopApp {
    [CmdletBinding()]
    param (

    )

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

    Write-Host -ForegroundColor Cyan "[ INSTALL APPLICATIONS ]"
    Write-Host -ForegroundColor Cyan "Installing Applications [ $($Collection.Count) ]..."

    foreach ($item in $Collection) {
        Write-Host ("{0}{1}" -f $([Char]9), $item)
        scoop install $item

    } # END foreach ($item in $UWP)

    Write-Host -ForegroundColor Cyan "[ INSTALL APPLICATIONS ] Completed. Processed [ $Counter of $CounterTotal ] with [ $CounterErrrors ]"


}

