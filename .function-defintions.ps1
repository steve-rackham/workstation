function AppPackage {
    [CmdletBinding()]
    param (

    )

    # Counters: -------------------------------------------------------------------
    [int]$Counter = 0
    [int]$CounterTotal = $Collection.Count
    [int]$CounterErrors = 0

    Write-Host -ForegroundColor Cyan "[ UWP CONFIGURATION ]"
    Write-Host -ForegroundColor Cyan "Remove Unnecessary App Packages [ $($Collection.Count) ]..."

    foreach ($item in $script:AppPackage) {
        try {
            Write-Host ("{0}{1}" -f $([Char]9), $item)
            [void](Get-AppxPackage $item -AllUsers -ErrorAction Stop | Remove-AppxPackage -ErrorAction Stop)
            [void](Get-AppxProvisionedPackage -Online -ErrorAction Stop  | Where-Object DisplayName -Like $item -ErrorAction Stop | Remove-AppxProvisionedPackage -Online -ErrorAction Stop)

        } catch {
            $CounterErrors++
            { 1:<#Do this if a terminating exception happens#> }
        }

    } # END foreach ($item in $UWP)
    Write-Host -ForegroundColor Cyan "[ UWP CONFIGURATION ] Completed. Processed [ $Counter of $CounterTotal ] with [ $CounterErrrors ]"

}

function Services {
    [CmdletBinding()]
    param (

    )

    try {
        Write-Information "Disable Unnecessary Services [ $($Services.Count)]..."

        foreach ($item in $script:Services) {
            try {
                Write-Verbose ("{0}{1}" -f $([Char]9), $item)
                Get-Service -Name $item -ErrorAction Stop | Set-Service -Status Stopped -StartupType Disabled -ErrorAction Stop

            } catch {
                $CounterErrors++
                { 1:<#Do this if a terminating exception happens#> }
            }

        }

        Write-Information "[ CONFIGURE ENVIRONMENT ] Completed. Processed [ $Counter of $CounterTotal ] with [ $CounterErrrors ]"

    } catch {
        Write-Warning
        Write-Error
    }
}

function ScoopApp {
    [CmdletBinding()]
    param (

    )

    # Scoop Installation: ---------------------------------------------------------
    Write-Host -ForegroundColor Green "[ SCOOP ]"
    Write-Host -ForegroundColor Cyan "Scoop Installation..."

    $Result = (Get-Command scoop) ? ("Installed") : ($null)

    switch ($Result) {
        "Installed" {
            Write-Host ("{0}{1}" -f $([Char]9), "Scoop Installed. Updating...")
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

    Write-Host -ForegroundColor Cyan "[ INSTALL APPLICATIONS ]"
    Write-Host -ForegroundColor Cyan "Installing Applications [ $($Collection.Count) ]..."

    foreach ($item in $Collection) {
        Write-Host ("{0}{1}" -f $([Char]9), $item)
        if (-not(scoop info $item)) {
            scoop install $item
        } else {
            Write-Host ("{0}{1} {2}" -f $([Char]9), $item, "Installed")
        }
    } # END foreach ($item in $UWP)

    Write-Host -ForegroundColor Cyan "[ INSTALL APPLICATIONS ] Completed. Processed [ $Counter of $CounterTotal ] with [ $CounterErrrors ]"


}

function Settings {
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

function PowerShellModule {
    param (

    )

    Write-Host -ForegroundColor Cyan "Install PowerShell Modules [ $($script:PowerShellModule.Count) ]..."

    foreach ($item in $script:PowerShellModule) {
        Write-Verbose ("{0}{1} {2}" -f $([Char]9), $item.Name, "Required Version [ $($item.Version) ]...")
        $Result = [void](Get-InstalledModule -Name $item.Name -AllowPrerelease -ErrorAction Stop)

        switch ($Result) {
            ([version]$Result.Version -lt [version]$item.Version) {
                Write-Verbose ("{0}{1} {2}" -f $([Char]9), $item.Name, "Current Version [ $($Result.Version) ]. Updating...")
                Update-Module $item -Confirm:$false -Force

            }

            Default {
                Write-Verbose ("{0}{1} {2}" -f $([Char]9), $item.Name, "Required Version [ $($item.Version) ]. Installing...")
                Install-Module $item.Name -RequiredVersion $item.Version -Scope CurrentUser -Confirm:$false -ErrorAction Stop

            }
        }
    }
}