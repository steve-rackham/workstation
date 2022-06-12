# SHELL CUSTOMISATION: --------------------------------------------------------
# COMMON MODULES: -------------------------------------------------------------
Import-Module -Name Terminal-Icons

# HELPER FUNCTIONS: -----------------------------------------------------------
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

# SET-LOCATION:----------------------------------------------------------------
$Params = @{
    Name        = "git"
    PSProvider  = "FileSystem"
    Root        = "C:\Users\wolf\OneDrive - siliconwolf\git"
    Description = "Git Folder"
}

[void](New-PSDrive @Params)
Set-Location git:
$date = Get-Date
$uptime = Get-Uptime

$Coffee = @"
─▄▀─▄▀
──▀──▀
█▀▀▀▀▀█▄
█░░░░░█─█ 🅸🅽🆂🅴🆁🆃 ☕ 🅸🅽🅸🆃 🧠
▀▄▄▄▄▄▀▀
"@

$Beer = @"
█▄▀▄▀▄█
█░▀░▀░█▄    🅸🅽🆂🅴🆁🆃 🍺 🅸🅳🅻🅴 🧠
█░▀░░░█─█
█░░░▀░█▄▀
▀▀▀▀▀▀▀

"@


$MOTD


# Write-Host $MOTD -foregroundcolor cyan
$date = Get-Date
switch (($date.TimeOfDay.hours -lt 17)) {
    $true {
        Write-Host $Coffee -ForegroundColor cyan
    }
    Default {
        Write-Host $Beer  -ForegroundColor cyan
    }
}
Invoke-Expression (&starship init powershell)

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
(& "C:\Users\wolf\scoop\apps\miniconda3\current\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
#endregion

