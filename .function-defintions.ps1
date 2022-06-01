function WSSetupAppPackage {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string[]]$Name
    )
    process {
        foreach ($item in $Name) {
            try {
                Write-Verbose ("{0}{1} {2}" -f $([Char]9), "[ $item ]", "Removing...")
                [void](Get-AppxPackage $item -AllUsers -ErrorAction Stop | Remove-AppxPackage -ErrorAction Stop)
                [void](Get-AppxProvisionedPackage -Online -ErrorAction Stop  | Where-Object DisplayName -Like $item -ErrorAction Stop | Remove-AppxProvisionedPackage -Online -ErrorAction Stop)

            } catch {
                Write-Warning ("{0}{1} {2}" -f $([Char]9), "[ $item ]", "Removing... Error.")
            }

        } # END foreach ($item in $UWP)
    }

}

function WSSetupServices {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string[]]$Name
    )

    Process {
        foreach ($item in $Name ) {
            try {
                Write-Host -ForegroundColor Cyan ("{0}{1} {2}" -f $([Char]9), "[ $item ]", "Disabling Service...")
                Get-Service -Name $item -ErrorAction Stop | Set-Service -Status Stopped -StartupType Disabled -ErrorAction Stop

            } catch {
                Write-Warning ("{0}{1} {2}" -f $([Char]9), "[ $item ]", "Disabling Service...Error.")
            }
        }
    }
}

function WSSetupScoop {
    param (

    )


    $Result = (Get-Command scoop) ? ("Installed") : ($null)

    switch ($Result) {
        "Installed" {
            Write-Verbose ("{0}{1} {2}" -f $([Char]9), "[ Scoop ]", "Disabling Service...")
            scoop update
        }
        $null {
            Write-Host ("{0}{1}" -f $([Char]9), "Installing Scoop...")
            Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
            Invoke-WebRequest get.scoop.sh | Invoke-Expression
        }
        Default {
            Write-Host ("{0}{1}" -f $([Char]9), "Error Handling...")
        }
    }

    # aria2: ----------------------------------------------------------------------
    try {
        Write-Host -ForegroundColor Cyan "aria2 Installation..."
        Write-Host ("{0}{1}" -f $([Char]9), "Installing aria2...")
        scoop install aria2

        Write-Host ("{0}{1}" -f $([Char]9), "Configuring aria2...")
        scoop config aria2-warning-enabled false
        scoop config aria2-options @('--check-certificate=false')

    } catch {
        { 1:<#Do this if a terminating exception happens#> }
    }

    # Buckets: --------------------------------------------------------------------
    Write-Host -ForegroundColor Cyan "Adding Scoop Bucket(s) [$($Bucket.Count)]..."
    foreach ($item in $Bucket) {
        try {
            Write-Host "$([Char]9) Bucket: $item"
            scoop bucket add $item

        } catch {
            { 1:<#Do this if a terminating exception happens#> }
        }

    }
}


function WSSetupApp {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )][string[]]$Name
    )

    process {
        foreach ($item in $Name) {
            Write-Host -ForegroundColor Cyan ("{0}{1}" -f $([Char]9), $item) -NoNewline
            if (-not(scoop info $item)) {
                Write-Host ("{0}{1}" -f $([Char]9), "Installing...")
                # scoop install $item
            } else {
                Write-Host ("{0}{1}" -f $([Char]9), "Installed")
            }
        } # foreach ($item in $Name)
    }


}

function WSSetupSettings {
    [CmdletBinding()]
    param (
    )
    $settings = @(
        @{
            Name = 'VSCode Settings'
            URI  = $script:vsCodeSettingsJSON
            File = -join ($script:vscodeSettingsPath, '\settings.json')
        }
        @{
            Name = 'VSCode PowerShell Snippets'
            URI  = $script:vsCodePowerShellSnippetsJSON
            File = -join ($script:vscodeSnippetsPath, '\powershell.json')
        }
        @{
            Name = 'Windows Terminal Settings'
            URI  = $script:windowsTerminalSettingsJSON
            File = -join ($script:windowsTerminalSettingsPath, '\settings.json')
        }
        @{
            Name = 'PowerShell profile'
            URI  = $script:psProfile
            File = -join ($script:profilePath, '\profile.ps1')
        }
    )

    foreach ($setting in $settings) {
        Start-Sleep -Milliseconds 500
        Write-Verbose -Message ('Downloading {0} to {1}' -f $setting.Name, $setting.File)

        $gistUrl = $null
        $fileName = $null
        $gistContent = $null
        $gistUrl = $setting.URI
        $fileName = Split-Path $setting.File -Leaf

        try {
            $invokeSplat = @{
                Uri         = $gistUrl
                ErrorAction = 'Stop'
            }

            $gist = Invoke-RestMethod @invokeSplat
            $gistContent = $gist.Files.$fileName.Content
            Write-Verbose -Message '    Download COMPLETED.'
        } catch {
            Write-Error $_
            continue
        }

        try {
            Write-Verbose -Message '    Writing out content...'
            $setContentSplat = @{
                # Path        = "$path\$fileName"
                Path        = $setting.File
                Value       = $gistContent
                Confirm     = $false
                Force       = $true
                ErrorAction = 'Stop'
            }
            Set-Content @setContentSplat
            Write-Verbose -Message '    Setting applied!'
        } catch {
            Write-Error $_
            continue
        }
    }
}

function WSSetupPowerShellModule {
    param (
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )][hashtable[]]$Module
    )

    process {
        foreach ($item in $Module) {
            Write-Host -ForegroundColor Cyan ("{0}{1} {2}" -f $([Char]9), "[ $($item.ModuleName) ]", "Required Version [ $($item.Version) ]...") -NoNewline
            $Latest = [void](Find-Module -Name $item.ModuleName)
            $Result = [void](Get-InstalledModule -Name $item.ModuleName -AllowPrerelease -ErrorAction Stop)

            switch ($Result) {
                (([version]$Result.Version -lt [version]$Latest.Version) -and ($Module.Version -eq "Latest")) {
                    Write-Host "Updating to [ $($Latest.Version)]..."
                    # Update-Module $item -Confirm:$false -Force

                }

                (([version]$Result.Version -ne [version]$Latest.Version) -and ($Module.Version -ne "Latest")) {
                    Write-Host "Current Version [ $($Result.Version) ]. Latest Version [ $($Latest.Version) ]. Installing [ $($Module.Version)]..."
                    # Update-Module $item -Confirm:$false -Force

                }

                Default {
                    "Installing..."
                    # Install-Module $item.ModuleName -RequiredVersion $item.Version -Scope CurrentUser -Confirm:$false -ErrorAction Stop

                }
            }
        }
    }
}