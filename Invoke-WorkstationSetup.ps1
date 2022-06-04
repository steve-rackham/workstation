#Requires -RunAsAdministrator
#Requires -Version 7

function Invoke-WorkstationSetup {
    [CmdletBinding()]
    param (

        [Parameter()]
        [ValidateSet("Apps", "Customise")]
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

        } catch {
            Write-Warning ("{0}{1}" -f $([Char]9), "Error Processing File Explorer Options")
            Write-Error ("{0}{1}" -f $([Char]9), $Error[0].ErrorDetails.Message)
        }

        try {
            Write-Information "[ SERVICES ]"
            Write-Information "Set Service Options..."
            Write-Verbose ("{0}{1}" -f $([Char]9), "Enable ssh-agent service")
            Set-Service ssh-agent -StartupType Manual

            Write-Information "Disable Unnecessary Services..."
            WSSetupService -Name $Service -Verbose
        } catch {
            Write-Warning ("{0}{1}" -f $([Char]9), "Error Service Options")
            Write-Error ("{0}{1}" -f $([Char]9), $Error[0].ErrorDetails.Message)
        }

        try {
            Write-Information  "[ APP PACKAGES ]"
            Write-Information  "Remove Unnecessary App Packages..."
            WSSetupAppPackage -Name $AppPackage -Verbose
        } catch {
            Write-Warning ("{0}{1}" -f $([Char]9), "Error Processing AppPackage Options")
            Write-Error ("{0}{1}" -f $([Char]9), $Error[0].ErrorDetails.Message)
        }
    }
}

switch ($Action) {
    "Apps" {
        WSSetupScoop
        WSSetupApp -Name $Application
    }

    "Customise" {
        WSSetupSettings -Customise VSCode, Terminal, PowerShell
        WSSetupPowerShellModule -Module $PowerShellModule
        WSSetupVSCodeExtensions -Name $VSCodeExtension


    }

    Default {
        WSSetupScoop
        WSSetupApp -Name $Application
        WSSetupSettings -Customise VSCode, Terminal, PowerShell
        WSSetupPowerShellModule -Module $PowerShellModule
        WSSetupVSCodeExtensions -Name $VSCodeExtension
    }
}



