
$msdeploy = "C:\Program Files (x86)\IIS\Microsoft Web Deploy V3\msdeploy.exe";

$source = $args[0]
$destination = $args[1]
$recycleApp = $args[2]
$computerName = $args[3]
$username = $args[4]
$password = $args[5]
$delete = $args[6]

$computerNameArgument = $computerName + '/MsDeploy.axd?site='+$recycleApp.Replace(" ","+");
$directory = Split-Path -Path (Get-Location) -Parent
$baseName = (Get-Item $directory).BaseName
$contentPath = Join-Path $directory $source
$targetPath = $recycleApp + $destination

[System.Collections.ArrayList]$msdeployArguments = 
    "-verb:sync",
    "-allowUntrusted",
    "-enableRule:DoNotDeleteRule",
    "-enableRule:AppOffline",
    "-disableLink:AppPoolExtension",
    "-disableLink:ContentExtension",
    "-disableLink:CertificateExtension",
    "-source:contentPath='${source}'," +
    ("-dest:" + 
        "contentPath='${targetPath}'," +
        "computerName=${computerNameArgument}," + 
        "username=${username}," +
        "password=${password}," +
        "IncludeAcls='False'," +
        "AuthType='Basic'"
    )

$source
$command = "& `$msdeploy --% $msdeployArguments"
$sb = $ExecutionContext.InvokeCommand.NewScriptBlock($command)
& $sb
