function WSSetupAppPackage {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string[]]$Name
    )
    begin {
        $OffSet = 0 - ($Name | Measure-Object -Maximum -Property Length).Maximum

    }

    process {
        foreach ($item in $Name) {
            try {
                Write-Output ("{0}{1, $Offset} {2}" -f $([Char]9), "[ $item ]", "Removing AppPackage...")
                [void](Get-AppxPackage $item -AllUsers -ErrorAction Stop | Remove-AppxPackage -ErrorAction Stop)
                [void](Get-AppxProvisionedPackage -Online -ErrorAction Stop  | Where-Object DisplayName -Like $item -ErrorAction Stop | Remove-AppxProvisionedPackage -Online -ErrorAction Stop)

            } catch {
                Write-Warning ("{0}{1, $Offset} {2}" -f $([Char]9), "[ $item ]", "Error Removing AppPackage...")
                Write-Error ("{0}{1, $Offset} {2}" -f $([Char]9), "[ $item ]", $Error[0].ErrorRecord.Message)
            }
        } # END foreach ($item in $UWP)
    }
}

function WSSetupService {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string[]]$Name
    )

    Begin {
        $OffSet = 0 - ($Name | Measure-Object -Maximum -Property Length).Maximum

    }

    Process {
        foreach ($item in $Name ) {
            try {
                Write-Output ("{0}{1, $Offset} {2}" -f $([Char]9), "[ $item ]", "Disabling Service...")
                Get-Service -Name $item -ErrorAction Stop | Set-Service -Status Stopped -StartupType Disabled -ErrorAction Stop

            } catch {
                Write-Warning ("{0}{1, $Offset} {2}" -f $([Char]9), "[ $item ]", "Error Disabling Service...")
                Write-Error ("{0}{1, $Offset} {2}" -f $([Char]9), "[ $item ]", $Error[0].ErrorRecord.Message)
            }
        }
    }
}

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

function WSSetupSettings {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateSet("VSCode", "Terminal", "PowerShell")]
        [string[]]$Customise
    )

    # $OffSet = 0 - ($SettingAndProfile.Name | Measure-Object -Maximum -Property Length).Maximum - 5
    Write-Output "[ APP CONFIG ]"
    Write-Output  "Applying App Customisation Configs..."

    foreach ($Action in $Customise) {
        switch ($Action) {
            VSCode {
                $Setting = @(
                    $VSCodeSetting
                    #$VSCodeExtension
                )
                break

            }
            Terminal {
                $Setting = @(
                    $WindowsTerminalSetting

                )
                break
            }
            PowerShell {
                $Setting = @(
                    $PowerShellProfile
                    # $PowerShellModule

                )
                break
            }
            Default {
                $Setting = @(
                    $VSCodeSetting
                    #$VSCodeExtension
                    $PowerShellProfile
                    #$PowerShellModule
                    $WindowsTerminalSetting

                )
                break
            }
        }
    }

    foreach ($item in $Setting) {
        try {
            $ContentParams = @{
                Value       = $item.Value
                Path        = $item.Path
                Confirm     = $false
                Force       = $true
                ErrorAction = "Stop"
            }
            Write-Output ("{0}{1}" -f $([Char]9), "[ $($item.Name) ]")
            Write-Output ("{0}{1}{2}" -f $([Char]9), $([Char]9), "$($item.Path)...")
            # Set-Content @ContentParams -WhatIf

        } catch {
            Write-Error $_
            continue
        }

    }
}

function WSSetupPowerShellModule {
    param (
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )][hashtable[]]$Module
    )

    begin {
        Write-Output  "[ POWERSHELL ]"
        Write-Output  "Installing PowerShell Modules..."
    }

    process {
        foreach ($item in $Module) {
            Write-Output ("{0}{1} {2}" -f $([Char]9), "[ $($item.ModuleName) ]", "Required Version [ $($item.Version) ]...")
            $Latest = [void](Find-Module -Name $item.ModuleName)
            $Result = [void](Get-InstalledModule -Name $item.ModuleName -AllowPrerelease -ErrorAction Stop)

            switch ($Result) {
                (([version]$Result.Version -lt [version]$Latest.Version) -and ($Module.Version -eq "Latest")) {
                    Write-Output ("{0}{1} {2}" -f $([Char]9), "[ $($item.ModuleName) ]", "Updating to [ $($Latest.Version)]...")
                    # Update-Module $item -Confirm:$false -Force

                }

                (([version]$Result.Version -ne [version]$Latest.Version) -and ($Module.Version -ne "Latest")) {
                    Write-Output ("{0}{1} {2}" -f $([Char]9), "[ $($item.ModuleName) ]", "Current Version [ $($Result.Version) ]. Installing [ $($Module.Version)]...")
                    # Update-Module $item -Confirm:$false -Force

                }

                Default {
                    Write-Output ("{0}{1} {2}" -f $([Char]9), "[ $($item.ModuleName) ]", "Installing [ $($Latest.Version)]...")
                    # Install-Module $item.ModuleName -Scope CurrentUser -Confirm:$false -ErrorAction Stop

                }
            }
        }
    }
}

function WSSetupVSCodeExtensions {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )][string[]]$Name
    )

    begin {
        $OffSet = 0 - ($Name | Measure-Object -Maximum -Property Length).Maximum
        Write-Output "[ VSCode Extentions ]"
        Write-Output  "Installing VSCode Extentions..."

    }

    process {
        foreach ($item in $Name) {
            try {
                $Result = code --list-extensions
                if ($Result -contains $item) {
                    Write-Output ("{0}{1, $Offset} {2}" -f $([Char]9), "[ $item ]", "Installed.")
                    [void](code --install-extension $item)
                } else {
                    Write-Output ("{0}{1, $Offset} {2}" -f $([Char]9), "[ $item ]", "Installing...")
                }
            } catch {
                Write-Output ("{0}{1, $Offset} {2}" -f $([Char]9), "[ $item ]", "Error.")
                Write-Output ("{0}{1, $Offset} {2}" -f $([Char]9), "[ $item ]", $Error[0].ErrorDetails.Message)

            }

        } # foreach ($item in $Name)
    }
}
