# CUSTOMISATION: ##############################################################
# Definitions: ################################################################
$GitName = ""
$GitEmail = ""

$PowerShellModule = @(
    "Az"
    "AzureADPreview"
    "ComputerManagementDsc"
    "Graphical"
    "GuestConfiguration"
    "Micrsoft.PowerShell.SecretManagement"
    "MSOnline"
    "Pester"
    "Posh-Git"
    "PoShLog"
    "PoShLog.Enrichers"
    "PoShLog.Sinks.Eventlog"
    "PoShLog.Sinks.Syslog"
    "PSDesiredStateConfiguration"
    "PSDscResources"
    "PSReadline"
    "PSRemotely"
    "Terminal-Icons"

)

$VSCodeExtension = @(
    "aprilandjan.ascii-tree-generator"
    "DotJoshJohnson.xml"
    "eamodio.gitlens"
    "esbenp.prettier-vscode"
    "golang.go"
    "hashicorp.terraform"
    "hediet.vscode-drawio"
    "ms-azuretools.vscode-azureterraform"
    "ms-vscode-remote.remote-wsl"
    "ms-vscode.azure-account"
    "ms-vscode.powershell-preview"
    "PKief.material-product-icons"
    "redhat.vscode-yaml"
    "robole.markdown-snippets"
    "robole.marky-dynamic"
    "robole.marky-edit"
    "robole.marky-markdown"
    "robole.marky-stats"
    "streetsidesoftware.code-spell-checker"
    "vscode-icons-team.vscode-icons"
    "yzhang.markdown-all-in-one"
)

$PowerShellProfile = @"


"@

# Counters: -------------------------------------------------------------------
[int]$Counter = 0
[int]$CounterTotal = $Collection.Count
[int]$CounterErrors = 0

Write-Host -ForegroundColor Cyan "[ CUSTOMISE ENVIRONMENT ]"
# GIT: ########################################################################
Write-Host -ForegroundColor Cyan "Customise Git Config..."
Write-Host ("{0}{1}" -f $([Char]9), "Use VSCode for Git editing...")
git config --global core.editor "code --wait"
Write-Host ("{0}{1}" -f $([Char]9), "Set prune during fetch...")
git config --global fetch.prune true
Write-Host ("{0}{1}" -f $([Char]9), "Set default branch to [ main ]...")
git config --global init.defaultBranch main

Write-Host ("{0}{1}" -f $([Char]9), "Set git name to [ $GitName ]...")
$Result = ($null -ne $GitName)  ? ($true) : ($false)
switch ($Result) {
    $true {
        git config --global user.name $GitName

    }
    $false {
        $GitName = Read-Host "Enter Git Name: "
        git config --global user.name $GitName
    }
}

Write-Host ("{0}{1}" -f $([Char]9), "Set git email to [ $GitEmail ]...")
$Result = ($null -ne $GitEmail)  ? ($true) : ($false)
switch ($Result) {
    $true {
        git config --global user.name $GitEmail

    }
    $false {
        $GitName = Read-Host "Enter Git Email: "
        git config --global user.name $GitEmail
    }
}

# TERMINAL: ###################################################################
Write-Host -ForegroundColor Cyan "Customise Terminal Config..."



# POWERSHELL: #################################################################
# Modules: --------------------------------------------------------------------
Write-Host -ForegroundColor Cyan "Install PowerShell Modules [ $(PowerShellModule.Count) ]..."

foreach ($item in $PowerShellModule) {
    Write-Host ("{0}{1}" -f $([Char]9), $item)
    $Result = (Get-Module -ListAvailable -Name $item) ? ("Installed") : ("Not Installed")

    switch ($Result) {
        "Installed" {
            Write-Host ("{0}{1, {2}}" -f $([Char]9), $item, "Installed. Checking for updates...")
            Update-Module $item -Confirm:$false -Force
        }
        "Not Installed" {
            try {
                Install-Module $item -Scope CurrentUser -Confirm:$false -ErrorAction Stop

            } catch {
                $CounterErrors++
                { 1:<#Do this if a terminating exception happens#> }
            }

        }
        Default {

        }
    }
}

# END if (Get-Module -ListAvailable -Name PoshLog)

# Profile: --------------------------------------------------------------------
Write-Host -ForegroundColor Cyan "Customise PowerShell Profile..."

# Where is the profile located?
if (-not ([System.Environment]::GetFolderPath("Personal").Equals($env:USERPROFILE))) {
    # Set registry key...

}

$Result = (Test-Path $PROFILE.CurrentUserAllHosts) ? ($true) : ($false)
switch ($Result) {
    $true {
        Write-Host ("{0}{1}" -f $([Char]9), "Existing Profile in use.")

    }
    $false {
        try {
            Write-Host ("{0}{1}" -f $([Char]9), "Creating Profile: CurrentUserAllHosts .")
            New-Item -ItemType File $PROFILE.CurrentUserAllHosts -ErrorAction Stop
        } catch {
            $CounterErrors++
            { 1:<#Do this if a terminating exception happens#> }
        }

    }
    Default {

    }
}
# Prompt: ---------------------------------------------------------------------
pshazz use aag


# VSCODE: #####################################################################
# Extensions:------------------------------------------------------------------
Write-Host -ForegroundColor Cyan "Install VSCode Extensions [ $(VSCodeExtension.Count) ]..."

foreach ($item in $VSCodeExtension) {
    code --install-extension $item
}

# Settings: -------------------------------------------------------------------
Write-Host -ForegroundColor Cyan "Customise VSCode Preferences..."


Write-Host -ForegroundColor Cyan "[ CUSTOMISE ENVIRONMENT ] Completed. Processed [ $Counter of $CounterTotal ] with [ $CounterErrrors ]"
