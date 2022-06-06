<#
.SYNOPSIS
    A short one-line action-based description, e.g. 'Tests if a function is valid'
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Test-MyTestFunction -Verbose
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>


function Invoke-WSSetup {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateSet("Apps", "Customise", "DotFiles", "Admin")]
        [string]$Setup
    )

    # Definitions: ########################################################
    # Load Helper Functions and Files: ------------------------------------
    Write-Output "[ DEFINITIONS ]"
    Write-Output "Loading Helper Functions and Definitions..."

    $AppFiles = @(
        ".\definitions\app-definitions.ps1"
        ".\functions\app-functions.ps1"
    )

    $CustomiseFiles = @(
        ".\definitions\customise-definitions.ps1"
        ".\functions\customise-functions.ps1"
    )

    $DotFiles = @(
        ".\definitions\dotfiles-definitions.ps1"
        ".\functions\dotfiles-functions.ps1"
    )

    foreach ($Action in $Setup) {
        switch ($Action) {
            Apps {
                WSSetupCheckFiles -Files $AppFiles
                WSSetupScoop
                WSSetupApp -Name $Application

                break
            }
            Customise {
                WSSetupCheckFiles -Files $CustomiseFiles
                WSSetupSettings -Customise VSCode, Terminal, PowerShell
                WSSetupPowerShellModule -Module $PowerShellModule
                WSSetupVSCodeExtensions -Name $VSCodeExtension

                break

            }
            DotFiles {
                WSSetupCheckFiles -Files $DotFiles
                WSSetupDotFiles -DotFile GitConfig, Starship
                break

            }
            Admin {
                # Self-elevate the script if required
                if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {

                    $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
                    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
                    Exit

                }
                break

            }
            Default {
                Write-Output ("{0}{1} {2}" -f $([Char]9), "[ ERROR ]", $Action)
                Write-Output ("{0}{1}" -f $([Char]9), "Exit.")

            }
        }
    }
} # END: function Invoke-WSSetup ##############################################


function WSSetupCheckFiles {
    param (
        [string[]]$Files
    )

    foreach ($File in $Files) {
        $Path = [System.IO.Path]::GetFullPath($File)

        switch ($([System.IO.File]::Exists($Path))) {
            $true {
                Write-Output ("{0}{1} {2}" -f $([Char]9), "[ Loading ]", $File)
                . $File
            }
            $false {
                Write-Output ("{0}{1} {2}" -f $([Char]9), "[ ERROR ]", $File)
                Write-Output ("{0}{1}" -f $([Char]9), "Exit.")
                Exit
            }
        }
    }
}

