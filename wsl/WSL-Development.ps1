#Requires -RunAsAdministrator
#Requires -Version 7
# WSL-Development: ############################################################
# Definitions: ################################################################
# Collection: -----------------------------------------------------------------
$Collection = @()

# Counters: -------------------------------------------------------------------
[int]$Counter = 0
[int]$CounterTotal = $Collection.Count
[int]$CounterErrors = 0

# INSTALLATION: ###############################################################
wsl --install
sudo apt update && sudo apt upgrate -y

# APPLICATIONS: ###############################################################
sudo install zsh git o
# INTEGRATIONS: ###############################################################

# CUSTOMISATIONS: #############################################################