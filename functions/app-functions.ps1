function WSSetupScoop {
    param (

    )

    Write-Output "[ SCOOP ]"
    Write-Output  "Scoop Installation..."
    $Result = (Get-Command scoop) ? ("Installed") : ($null)

    switch ($Result) {
        "Installed" {
            Write-Output ("{0}{1} {2}" -f $([Char]9), "[ Scoop ]", "Installed.")
            scoop update
        }
        $null {
            Write-Output ("{0}{1} {2}" -f $([Char]9), "[ Scoop ]", "Installing...")
            Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
            Invoke-WebRequest get.scoop.sh | Invoke-Expression
        }
        Default {
            Write-Warning ("{0}{1} {2}" -f $([Char]9), "[ Scoop ]", "Error Installing Scoop...")
            Write-Warning ("{0}{1} {2}" -f $([Char]9), "[ Scoop ]", "Exit.")
            Return
        }
    }

    # aria2: ----------------------------------------------------------------------
    try {
        Write-Output "aria2 Installation..."
        Write-Output ("{0}{1} {2}" -f $([Char]9), "[ aria2 ]", "Installing...")
        scoop install aria2

        Write-Output ("{0}{1} {2}" -f $([Char]9), "[ aria2 ]", "Configuring...")
        scoop config aria2-warning-enabled false
        scoop config aria2-options @("--check-certificate=false")

    } catch {
        { 1:<#Do this if a terminating exception happens#> }
    }

    # Buckets: --------------------------------------------------------------------
    Write-Output "Adding Scoop Bucket(s) [$($Bucket.Count)]..."
    foreach ($item in $Bucket) {
        try {
            Write-Output ("{0}{1} {2}" -f $([Char]9), "[ $item ]", "Adding...")
            scoop bucket add $item

        } catch {
            Write-Warning ("{0}{1} {2}" -f $([Char]9), "[ $item ]", "Error Installing.")

        }
    }
}


function WSSetupApp {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )][string[]]$Name
    )

    begin {
        $OffSet = 0 - ($Name | Measure-Object -Maximum -Property Length).Maximum
        Write-Output "[ APPLICATIONS ]"
        Write-Output  "Installing Applications..."

    }

    process {
        foreach ($item in $Name) {

            if (-not([void](scoop info $item))) {
                Write-Output ("{0}{1, $Offset} {2}" -f $([Char]9), "[ $item ]", "Installing...")
                # scoop install $item
            } else {
                Write-Output ("{0}{1, $Offset} {2}" -f $([Char]9), "[ $item ]", "Installed..")
            }
        } # foreach ($item in $Name)
    }
}
