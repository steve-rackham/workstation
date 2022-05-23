#Requires -RunAsAdministrator
#Requires -Version 7
# Definitions: ################################################################
# Logging: --------------------------------------------------------------------



# Administrative Action: ######################################################
Write-Host -ForegroundColor Green "[ ADMIN CONFIGURATION ]"
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit
}

# REMOVE UWP APPS: ############################################################
.\helper\Remove-UWPackages.ps1

# SCOOP: ######################################################################
.\helper\Install-Scoop.ps1

# Install Applications: #######################################################
.\helper\Install-Applications.ps1

# CUSTOMISATION: ##############################################################
.\helper\Customise-Environment.ps1

# WSL: ########################################################################


