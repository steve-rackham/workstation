# Install Applications: #######################################################
# Definitions: ################################################################

$Collection = @(
    "7zip"
    "vscode"
    "pshazz"
    "pwsh"
    "curl"
    "sudo"
    "starship"
    "kitty"
    "python"
    "slack"
    "sysinternals"
    "zaproxy"
    "hugo-extended"
    "wireshark"
    "winscp"
    "rufus"

)

$DevOps = @(
    "git"
    "wslgit"
    "poshgit"
    "terraform"
    "tflint"
    "tfsec"
    "terraform-docs"
    "aztfy"
    "azure-cli"
    "draw.io"
    "fiddler"
    "graphviz"
    "pester"
    "postman"
    "windows-terminal"
    "terraform-graph-beautifier"
    "azcopy"
    "azurestorageexplorer"
    "azure-ps"
    "azuredatastudio"
    "infracost" # custom bucket scoop bucket add hoilc_scoop-lemon https://github.com/hoilc/scoop-lemon





)

# Counters: -------------------------------------------------------------------
Write-Host -ForegroundColor Cyan "[ INSTALL APPLICATIONS ]"
Write-Host -ForegroundColor Cyan "Installing Applications [ $($Collection.Count) ]..."

foreach ($item in $Collection) {
    Write-Host ("{0}{1}" -f $([Char]9), $item)
    scoop install $item

} # END foreach ($item in $UWP)

Write-Host -ForegroundColor Cyan "[ INSTALL APPLICATIONS ] Completed. Processed [ $Counter of $CounterTotal ] with [ $CounterErrrors ]"


