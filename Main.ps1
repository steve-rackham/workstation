#Requires -RunAsAdministrator
#Requires -Version 7

function main {
    [CmdletBinding()]
    param (

        [Parameter()]
        [switch]$CleanUp,

        [Parameter()]
        [switch]$Apps,

        [Parameter()]
        [switch]$All

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


        # Administrative Action: ##############################################
        Write-Information "[ ADMIN CONFIGURATION ]"
        if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
            Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit
        }

    }

    process {
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

        } catch {
            Write-Warning
            Write-Error $Error[0].ErrorDetails.Message
        }

        # Install Applications: ###############################################

        Install-ScoopApp -Verbose


        # CUSTOMISATION: ######################################################


        # WSL: ################################################################


        Write-Verbose ("{0}{1}" -f $([Char]9), "Enable ssh-agent service")
        Set-Service ssh-agent -StartupType Manual

        if ($CleanUp) {
            Remove-xService -Verbose
            Remove-xAppPackage -Verbose
        }
    }
}

end {

}


