function WSSetupAppPackage {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string[]]$Name
    )
    begin {
        $OffSet = 0 - ($Name | Measure-Object -Maximum -Property Length).Maximum

    }

    process {
        foreach ($item in $Name) {
            try {
                Write-Output ("{0}{1, $Offset} {2}" -f $([Char]9), "[ $item ]", "Removing AppPackage...")
                [void](Get-AppxPackage $item -AllUsers -ErrorAction Stop | Remove-AppxPackage -ErrorAction Stop)
                [void](Get-AppxProvisionedPackage -Online -ErrorAction Stop  | Where-Object DisplayName -Like $item -ErrorAction Stop | Remove-AppxProvisionedPackage -Online -ErrorAction Stop)

            } catch {
                Write-Warning ("{0}{1, $Offset} {2}" -f $([Char]9), "[ $item ]", "Error Removing AppPackage...")
                Write-Error ("{0}{1, $Offset} {2}" -f $([Char]9), "[ $item ]", $Error[0].ErrorRecord.Message)
            }
        } # END foreach ($item in $UWP)
    }
}

function WSSetupService {
    [CmdletBinding()]
    param (
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string[]]$Name
    )

    Begin {
        $OffSet = 0 - ($Name | Measure-Object -Maximum -Property Length).Maximum

    }

    Process {
        foreach ($item in $Name ) {
            try {
                Write-Output ("{0}{1, $Offset} {2}" -f $([Char]9), "[ $item ]", "Disabling Service...")
                Get-Service -Name $item -ErrorAction Stop | Set-Service -Status Stopped -StartupType Disabled -ErrorAction Stop

            } catch {
                Write-Warning ("{0}{1, $Offset} {2}" -f $([Char]9), "[ $item ]", "Error Disabling Service...")
                Write-Error ("{0}{1, $Offset} {2}" -f $([Char]9), "[ $item ]", $Error[0].ErrorRecord.Message)
            }
        }
    }
}

