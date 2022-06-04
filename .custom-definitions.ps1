# POWERSHELL PROFILE: #########################################################
$PowerShellProfile = @(
    @{
        Name  = "PowerShell Profile"
        Value = [System.IO.Path]::GetFullPath(".\powershell\profile.ps1")
        Path  = [System.IO.Path]::join($env:USERPROFILE, "\Documents\PowerShell", "\profile.ps1")
    }
)

# POWERSHELL MODULES: #########################################################
$PowerShellModule = @(
    @{
        ModuleName = "Az"
        Version    = "Latest"
    }

    @{
        ModuleName = "Az"
        Version    = "Latest"
    }
    @{
        ModuleName = "AzureADPreview"
        Version    = "Latest"
    }
    @{
        ModuleName = "ComputerManagementDsc"
        Version    = "Latest"
    }
    @{
        ModuleName = "Graphical"
        Version    = "Latest"
    }
    @{
        ModuleName = "GuestConfiguration"
        Version    = "Latest"
    }
    @{
        ModuleName = "Micrsoft.PowerShell.SecretManagement"
        Version    = "Latest"
    }
    @{
        ModuleName = "MSOnline"
        Version    = "Latest"
    }
    @{
        ModuleName = "Pester"
        Version    = "Latest"
    }
    @{
        ModuleName = "Posh-Git"
        Version    = "Latest"
    }
    @{
        ModuleName = "PoShLog"
        Version    = "Latest"
    }
    @{
        ModuleName = "PoShLog.Enrichers"
        Version    = "Latest"
    }
    @{
        ModuleName = "PoShLog.Sinks.Eventlog"
        Version    = "Latest"
    }
    @{
        ModuleName = "PoShLog.Sinks.Syslog"
        Version    = "Latest"
    }
    @{
        ModuleName = "PSDesiredStateConfiguration"
        Version    = "Latest"
    }
    @{
        ModuleName = "PSDscResources"
        Version    = "Latest"
    }
    @{
        ModuleName = "PSDesiredStateConfiguration"
        Version    = "Latest"
    }
    @{
        ModuleName = "PSReadline"
        Version    = "Latest"
    }
    @{
        ModuleName = "PSRemotely"
        Version    = "Latest"
    }
    @{
        ModuleName = "Terminal-Icons"
        Version    = "Latest"
    }
    @{
        ModuleName = "PSScriptAnalyzer"
        Version    = "Latest"
    }
)

# VSCODE SETTINGS: ############################################################
$VSCodeSetting = @(
    @{
        Name  = "VSCode Settings"
        Value = [System.IO.Path]::GetFullPath(".\vscode\settings.json")
        Path  = [System.IO.Path]::join($env:APPDATA, "\Code\User", "\settings.json")
    }

    @{
        Name  = "VSCode PowerShell Snippets"
        Value = [System.IO.Path]::GetFullPath(".\vscode\snippets\powershell.json")
        Path  = [System.IO.Path]::join($env:APPDATA, "\Code\User\snippets", "\powershell.json")
    }

)

# WINDOWS TERMINAL SETTINGS: ##################################################
$WindowsTerminalSetting = @(
    @{
        Name  = "Windows Terminal Settings"
        Value = [System.IO.Path]::GetFullPath(".\windows-terminal\settings.json")
        Path  = [System.IO.Path]::join($env:LOCALAPPDATA, "\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState", "\settings.json")
    }

    @{
        Name  = "Windows Terminal Background"
        Value = [System.IO.Path]::GetFullPath(".\windows-terminal\background.png")
        Path  = [System.IO.Path]::join($env:LOCALAPPDATA, "\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\RoamingState", "\settings.json")
    }
)

# VSCODE EXTENSIONS: ##########################################################
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

