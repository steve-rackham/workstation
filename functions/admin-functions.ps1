

function WSSetupAdmin {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet("SetExplorerOptions", "SetServiceOptions", "RemoveAppPackages")]
        [string]$Setup
    )

    foreach ($Action in $Setup) {
        switch ($Action) {
            SetExplorerOptions {
                WSSetupExplorerOptions
                break
            }
            SetServiceOptions {
                WSSetupService -Name $Service
                break

            }
            RemoveAppPackages {
                WSSetupAppPackage -Name $AppPackage
                break

            }
            Default {
                Write-Output ("{0}{1} {2}" -f $([Char]9), "[ ERROR ]", $Action)
                Write-Output ("{0}{1}" -f $([Char]9), "Exit.")

            }
        }
    }
}

function WSSetupExplorerOptions {
    param (

    )

    try {
        Write-Information "[ FILE EXPLORER ]"
        Write-Information "Set File Explorer Options..."
        Write-Output ("{0}{1}" -f $([Char]9), "Show protected OS files")
        Set-WindowsExplorerOptions -EnableShowProtectedOSFiles -ErrorAction Stop

        Write-Output ("{0}{1}" -f $([Char]9), "Show hidden files")
        Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -ErrorAction Stop

        Write-Output ("{0}{1}" -f $([Char]9), "Show file extensions")
        Set-WindowsExplorerOptions -EnableShowFileExtensions -ErrorAction Stop

        Write-Output ("{0}{1}" -f $([Char]9), "Expand Explorer to Working Folder")
        $RegPath = HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
        Set-ItemProperty -Path $RegPath -Name NavPaneExpandToCurrentFolder -Value 1 -ErrorAction Stop

        Write-Output ("{0}{1}" -f $([Char]9), "Remove Quick Access")
        Set-ItemProperty -Path $RegPath -Name LaunchTo -Value 1 -ErrorAction Stop

        Write-Output ("{0}{1}" -f $([Char]9), "Multi-Monitor Mode for the Taskbar")
        Set-ItemProperty -Path $RegPath -Name MMTaskbarMode -Value 2 -ErrorAction Stop

    } catch {
        Write-Warning ("{0}{1}" -f $([Char]9), "Error Processing File Explorer Options")
        Write-Error ("{0}{1}" -f $([Char]9), $Error[0].ErrorDetails.Message)
    }
}

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
        try {
            Write-Information  "[ APP PACKAGES ]"
            Write-Information  "Remove Unnecessary App Packages..."

        } catch {
            Write-Warning ("{0}{1}" -f $([Char]9), "Error Processing AppPackage Options")
            Write-Error ("{0}{1}" -f $([Char]9), $Error[0].ErrorDetails.Message)
        }
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
        try {
            Write-Information "[ SERVICES ]"
            Write-Information "Set Service Options..."
            Write-Output ("{0}{1}" -f $([Char]9), "Enable ssh-agent service")
            Set-Service ssh-agent -StartupType Manual

            Write-Information "Disable Unnecessary Services..."

        } catch {
            Write-Warning ("{0}{1}" -f $([Char]9), "Error Service Options")
            Write-Error ("{0}{1}" -f $([Char]9), $Error[0].ErrorDetails.Message)
        }

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

