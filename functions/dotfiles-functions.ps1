function WSSetupGitConfig {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$File = '.\dotfiles\.gitconfig'
    )

    $Destination = [System.IO.Path]::Join( $env:USERPROFILE, ".gitconfig")
    $Backup = [System.IO.Path]::Join( $Destination, ".old")

    [System.IO.File]::Exists($File)
    [System.IO.File]::Replace($File, $Destination, "C:\Temp\.gitconfig.old")
}

function WSSetupStarship {
    param (
        [string]$File = '.\dotfiles\starship.toml'
    )

    $Path = [System.IO.Path]::GetFullPath($File)
    [System.IO.File]::Exists($Path)

}

WSSetupStarship