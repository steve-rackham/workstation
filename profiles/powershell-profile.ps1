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
switch ($env:COMPUTERNAME) {
    "WOLF-PC" {
        $OneDrive = "siliconwolf"
    }
    Default {
        $OneDrive = "Computer Concepts Limited"
    }
}
$Params = @{
    Name        = "git"
    PSProvider  = "FileSystem"
    Root        = "C:\Users\$env:USERNAME\OneDrive - $OneDrive\git"
    Description = "Git Folder"
}

[void](New-PSDrive @Params)

Set-Location git:

# BANNER: #####################################################################

$Coffee = @"
─▄▀─▄▀
──▀──▀
█▀▀▀▀▀█▄  🅸🅽🆂🅴🆁🆃 🅸🅽🅸🆃
█░░░░░█─█ ☕☕☕  🧠🧠
▀▄▄▄▄▄▀▀

"@

$Beer = @"
█▄▀▄▀▄█     🅸🅽🆂🅴🆁🆃 🆄🅽🆆🅸🅽🅳
█░▀░▀░█▄    🍺🍺🍺 🧠🧠🧠
█░▀░░░█─█
█░░░▀░█▄▀
▀▀▀▀▀▀▀

"@
$Date = Get-Date

switch ($Date.DayOfWeek) {
    ("Friday" -or "Saturday" -or "Sunday") {
        if ($Date.TimeOfDay.hours -gt 17) {
            Write-Host $Beer -ForegroundColor Cyan
        }
    }

    Default {
        Write-Host $Coffee  -ForegroundColor Cyan
    }
}

# SHELL: ######################################################################
# StarShip: -------------------------------------------------------------------
if ($Env:STARSHIP_SHELL) {
    Invoke-Expression (&starship init powershell)
}

# MINICONDA: ------------------------------------------------------------------
#region conda initialize
if (Test-Path -Path "C:\Users\$env:USERNAME\scoop\apps\miniconda3\current\Scripts\conda.exe") {
    # !! Contents within this block are managed by 'conda init' !!
    (& "C:\Users\$env:USERNAME\scoop\apps\miniconda3\current\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
}

#endregion

