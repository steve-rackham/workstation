# Services: ###################################################################
$script:Service = @(
    "diagnosticshub.standardcollector.service" # Diagnostics Hub Service
    "DiagTrack"                                # Diagnostics Tracking Service
    "dmwappushservice"                         # WAP Push Message Routing Service
    "SharedAccess"                             # Internet Connection Sharing
    "WMPNetworkSvc"                            # Windows Media Player Network Sharing
    "XblAuthManager"                           # Xbox Live Auth Manager
    "XblGameSave"                              # Xbox Live Game Save Service
    "XboxNetApiSvc"                            # Xbox Live Networking Service
)

# Remove Unwanted UWP Applications: ###########################################
$script:UWPackage = @(
    "Microsoft.BingFinance",
    "Microsoft.3DBuilder",
    "Microsoft.BingNews",
    "Microsoft.BingSports",
    "Microsoft.BingWeather",
    "Microsoft.CommsPhone",
    "Microsoft.Getstarted",
    "Microsoft.WindowsMaps",
    "*MarchofEmpires*",
    "Microsoft.GetHelp",
    "Microsoft.Messaging",
    "*Minecraft*",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.OneConnect",
    "Microsoft.WindowsPhone",
    "Microsoft.WindowsSoundRecorder",
    "*Solitaire*",
    "Microsoft.MicrosoftStickyNotes",
    "Microsoft.Office.Sway",
    "Microsoft.XboxApp",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "Microsoft.NetworkSpeedTest",
    "Microsoft.FreshPaint",
    "Microsoft.Print3D",
    "*Autodesk*",
    "*BubbleWitch*",
    "king.com*",
    "G5*",
    "*Dell*",
    "*Facebook*",
    "*Keeper*",
    "*Netflix*",
    "*Twitter*",
    "*Plex*",
    "*.Duolingo-LearnLanguagesforFree",
    "*.EclipseManager",
    "ActiproSoftwareLLC.562882FEEB491", # Code Writer
    "*.AdobePhotoshopExpress"
)