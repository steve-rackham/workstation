$Starship = @{
    Name  = "Starship TOML"
    Value = [System.IO.Path]::GetFullPath(".\dotfiles\starship.toml")
    Path  = [System.IO.Path]::join($env:USERPROFILE, "\.config", "\starship.toml")
}

$GitConfig = @{
    Name  = "Git Config"
    Value = [System.IO.Path]::GetFullPath(".\dotfiles\.gitconfig")
    Path  = [System.IO.Path]::join($env:USERPROFILE, "\.gitconfig")
}