#Requires -RunAsAdministrator
#Requires -Version 7

function Invoke-WorkstationSetup {
    [CmdletBinding()]
    param (

        [Parameter()]
        [ValidateSet("Full", "Apps")]
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
            . .env-definitions.ps1
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
        Write-Information "[ ENVIRONMENT CONFIGURATION ]"

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

            Write-Host -ForegroundColor Cyan "[ UWP CONFIGURATION ]"
            Write-Information "Set Service Options..."
            Write-Verbose ("{0}{1}" -f $([Char]9), "Enable ssh-agent service")
            Set-Service ssh-agent -StartupType Manual

            Write-Information "Disable Unnecessary Services [ $($Script:Service.Count)]..."
            Services -Name $Script:Service -Verbose

            Write-Host -ForegroundColor Cyan "[ UWP CONFIGURATION ]"
            Write-Host -ForegroundColor Cyan "Remove Unnecessary App Packages [ $($script:AppPackage.Count) ]..."


        } catch {
            Write-Warning
            Write-Error $Error[0].ErrorDetails.Message
        }

        switch ($Action) {
            "Apps" {
                ScoopApp
            }
            Default {
            }
        }



        if ($CleanUp) {
            Services -Verbose
            AppPackage -Verbose
        }
    }
}

end {

}


