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


