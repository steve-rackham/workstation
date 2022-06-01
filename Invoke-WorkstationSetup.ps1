#Requires -RunAsAdministrator
#Requires -Version 7

function Invoke-WorkstationSetup {
    [CmdletBinding()]
    param (

        [Parameter()]
        [ValidateSet("Full", "Apps", "Customise")]
        [string]$Action


    )

    begin {
        # Definitions: ########################################################
        # Logging: ------------------------------------------------------------

        # Load Helper Functions and Files: ------------------------------------
        try {
            Write-Information "[ DEFINITIONS ]"
            . .app-definitions.ps1
            . .custom-definitions.ps1
            . .cleanup-definitions.ps1
            . .function-defintions.ps1

        } catch {
            Write-Warning
            Write-Error
        }
    }

    process {
        # Administrative Action: ##############################################
        Write-Information "[ ADMIN CONFIGURATION ]"
        if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
            Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit
        }

        # ENVIRONMENT OPTIONS: ################################################
        Write-Information "[ FILE EXPLORER ]"

        # File Explorer Options: ----------------------------------------------
        try {
            Write-Information "Set File Explorer Options..."
            Write-Verbose ("{0}{1}" -f $([Char]9), "Show protected OS files")
            Set-WindowsExplorerOptions -EnableShowProtectedOSFiles -ErrorAction Stop

            Write-Verbose ("{0}{1}" -f $([Char]9), "Show hidden files")
            Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -ErrorAction Stop

            Write-Verbose ("{0}{1}" -f $([Char]9), "Show file extensions")
            Set-WindowsExplorerOptions -EnableShowFileExtensions -ErrorAction Stop

            Write-Verbose ("{0}{1}" -f $([Char]9), "Expand Explorer to Working Folder")
            $RegPath = HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
            Set-ItemProperty -Path $RegPath -Name NavPaneExpandToCurrentFolder -Value 1 -ErrorAction Stop

            Write-Verbose ("{0}{1}" -f $([Char]9), "Remove Quick Access")
            Set-ItemProperty -Path $RegPath -Name LaunchTo -Value 1 -ErrorAction Stop

            Write-Verbose ("{0}{1}" -f $([Char]9), "Multi-Monitor Mode for the Taskbar")
            Set-ItemProperty -Path $RegPath -Name MMTaskbarMode -Value 2 -ErrorAction Stop

            Write-Host  "[ SERVICES ]"
            Write-Information "Set Service Options..."
            Write-Verbose ("{0}{1}" -f $([Char]9), "Enable ssh-agent service")
            Set-Service ssh-agent -StartupType Manual

            Write-Information "Disable Unnecessary Services..."
            $Script:Service | WSSetupService -Verbose

            Write-Host  "[ APP PACKAGES ]"
            Write-Host  "Remove Unnecessary App Packages..."
            $script:AppPackage | WSSetupAppPackage -Verbose

        } catch {
            Write-Warning
            Write-Error $Error[0].ErrorDetails.Message
        }

        switch ($Action) {
            "Apps" {
                # Scoop Installation: -----------------------------------------
                Write-Host "[ SCOOP ]" -ForegroundColor Green
                Write-Host  "Scoop Installation..."
                WSSetupScoop

                # App Installation: -------------------------------------------
                Write-Host "[ APPLICATIONS ]"
                Write-Host  "Installing Applications..."
                $script:Application | WSSetupApp -Verbose

            }

            "Customise" {
                # Shell: ------------------------------------------------------


            }

            Default {
                # Scoop Installation: -----------------------------------------
                Write-Host -ForegroundColor Green "[ SCOOP ]"
                Write-Host  "Scoop Installation..."
                WSSetupScoop -Verbose

                # App Installation: -------------------------------------------
                Write-Host  "[ APPLICATIONS ]"
                Write-Host  "Installing Applications..."
                $Application | WSSetupApp -Verbose

                Write-Host  "[ POWERSHELL ]"
                Write-Host  "Installing PowerShell Modules..."
                $script:PowerShellModule | WSSetupPowerShellModule  -Verbose
            }
        }
    }
}

end {

}


