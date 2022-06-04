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

    $AdminFiles = @(
        ".\definitions\admin-definitions.ps1"
        ".\functions\admin-functions.ps1"
    )

    $AppFiles = @(
        ".\definitions\app-definitions.ps1"
        ".\functions\app-functions.ps1"
    )

    $CustomiseFiles = @(
        ".\definitions\customise-definitions.ps1"
        ".\functions\customise-functions.ps1"
    )

    $DotFiles = @(
        ".\.dotfiles\.gitconfig"
        ".\.dotfiles\starship.toml"
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
                # WSSetupCheckFiles -Files $DotFiles

                WSSetupDotFiles
                break

            }
            Admin {
                foreach ($File in $AdminFiles) {
                    $Path = [System.IO.Path]::GetFullPath($File)

                    switch ($([System.IO.File]::Exists($Path))) {
                        $true {
                            Write-Output ("{0}{1} {2}" -f $([Char]9), "[ Loading ]", $File)
                            . .\defintitions\admin-defintitions.ps1
                            . .\functions\admin-functions.ps1
                        }
                        $false {
                            Write-Output ("{0}{1} {2}" -f $([Char]9), "[ ERROR ]", $File)
                            Write-Output ("{0}{1}" -f $([Char]9), "Exit.")
                            Exit
                        }
                    }
                }

                Administrative Action: ##############################################
                Write-Information "[ ADMIN CONFIGURATION ]"
                if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
                    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit
                }

                WSSetupExplorerOptions
                WSSetupService -Name $Service
                WSSetupAppPackage -Name $AppPackage -Verbose

                break

            }

            Default {
                Write-Output ("{0}{1} {2}" -f $([Char]9), "[ ERROR ]", $Action)
                Write-Output ("{0}{1}" -f $([Char]9), "Exit.")

            }
        }
    }


}





