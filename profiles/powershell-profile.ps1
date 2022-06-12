# SHELL CUSTOMISATION: ########################################################
# DEFINITIONS: ################################################################
$Date = Get-Date

# COMMON MODULES: #############################################################
Import-Module -Name Terminal-Icons

# HELPER FUNCTIONS: ###########################################################
function Test-RunAsAdministrator {
    $Principal = [Security.Principal.WindowsPrincipal] ([Security.Principal.WindowsIdentity]::GetCurrent())
    if ($Principal.IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
        return $true

    } else {
        return $false

    } # END if ($Principal.IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
} # END function Test-RunAsAdministrator

function Get-TypeAccelerators {
    [psobject].Assembly.GetType("System.Management.Automation.TypeAccelerators")::get
}

# GIT: ########################################################################
# Set-Location: ---------------------------------------------------------------
$Params = @{
    Name        = "git"
    PSProvider  = "FileSystem"
    Root        = "C:\Users\$env:USERNAME\OneDrive - siliconwolf\git"
    Description = "Git Folder"
}

[void](New-PSDrive @Params)

Set-Location git:

# BANNER: #####################################################################

$Coffee = @"
─▄▀─▄▀
──▀──▀
█▀▀▀▀▀█▄  🅸🅽🆂🅴🆁🆃
█░░░░░█─█ ☕☕☕
▀▄▄▄▄▄▀▀  🅸🅽🅸🆃🧠

"@

$Beer = @"
█▄▀▄▀▄█     🅸🅽🆂🅴🆁🆃
█░▀░▀░█▄    🍺🍺🍺
█░▀░░░█─█
█░░░▀░█▄▀   🆄🅽🆆🅸🅽🅳
▀▀▀▀▀▀▀     🧠🧠🧠

"@
$Date = Get-Date

switch ($Date.DayOfWeek) {
    "Friday" {
        if ($Date.TimeOfDay.hours -lt 17) {
            Write-Host $Coffee -ForegroundColor Cyan
        }

    }
    "Saturday" {
        Write-Host $Coffee -ForegroundColor Cyan
    }
    "Sunday" {
        Write-Host $Coffee -ForegroundColor Cyan
    }
    Default {
        Write-Host $Beer  -ForegroundColor Cyan
    }
}


Invoke-Expression (&starship init powershell)

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
(& "C:\Users\$env:USERNAME\scoop\apps\miniconda3\current\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
#endregion

