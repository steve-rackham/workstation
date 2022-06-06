function WSSetupDotFiles {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateSet("Starship", "GitConfig")]
        [string[]]$DotFile
    )

    # $OffSet = 0 - ($SettingAndProfile.Name | Measure-Object -Maximum -Property Length).Maximum - 5
    Write-Output "[ DOTFILES ]"
    Write-Output  "Applying Dot File Configs..."

    foreach ($File in $DotFile) {
        switch ($File) {
            Starship {
                $Setting = @(
                    $Starship
                )
                break

            }
            GitConfig {
                $Setting = @(
                    $GitConfig

                )
                break
            }

            Default {
                $Setting = @(
                    $Starship
                    $GitConfig

                )
                break
            }
        }
    }

    foreach ($item in $Setting) {
        try {
            $ContentParams = @{
                Value       = $item.Value
                Path        = $item.Path
                Confirm     = $false
                Force       = $true
                ErrorAction = "Stop"
            }
            Write-Output ("{0}{1}" -f $([Char]9), "[ $($item.Name) ]")
            Set-Content @ContentParams
            Write-Output ("{0}{1}{2}" -f $([Char]9), $([Char]9), "$($item.Path)...")

        } catch {
            Write-Output ("{0}{1} {2}" -f $([Char]9), "[ $($item.Name) ]", "ERROR!")
            continue
        }
    }
}
