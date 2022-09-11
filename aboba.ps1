<#$t = '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);'
add-type -name win -member $t -namespace native
[native.win]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 0)#>
try {
    $scriptPath = $PSScriptRoot
    if (!$scriptPath)
    {
        if ($psISE)
        {
            $scriptPath = Split-Path -Parent -Path $psISE.CurrentFile.FullPath
        } else {
            #Write-Host -ForegroundColor Red "Cannot resolve script file's path"
            exit 1
        }
    }
} catch {
    #Write-Host -ForegroundColor Red "Caught Exception: $($Error[0].Exception.Message)"
    exit 2
}
#Write-Host "$scriptPath"
<#
-------------------------------------------------------------------------------------------------------------------------------------------
$reg = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
New-ItemProperty -Path $eg\NewKey -Name "HiddenDrive" -Value ”32”  -PropertyType "DWord"
-------------------------------------------------------------------------------------------------------------------------------------------
#>
function Write-Log ($msg){
    $msg >> ${scriptPath}"test.log"
}
function Search-Files ($path){
    Write-Log -msg(Get-ChildItem -Path $path -Recurse | Where {$_.Name -like "*.doc*" <#-or $_.Name -like "*.docm" -or $_.Name -like "*.docx"#> -or $_.Name -like "*.dot*"<# -or $_.Name -like "*.dotm" -or $_.Name -like "*.dotx"#> -or $_.Name -like "*.*htm*" <#-or $_.Name -like "*.htm" -or $_.Name -like "*.mhtml"#> -or $_.Name -like "*.odt" -or $_.Name -like "*.pdf" -or $_.Name -like "*.rtf" -or $_.Name -like "*.wps" -or $_.Name -like "*.xml" -or $_.Name -like "*.xps" -or $_.Name -like "*.cvs" -or $_.Name -like "*.dbf" -or $_.Name -like "*.dif" -or $_.Name -like "*.ods" -or $_.Name -like "*.pdf" -or $_.Name -like "*.prn" -or $_.Name -like "*.slk" -or $_.Name -like "*.xl*" <#-or $_.Name -like "*.xlam" -or $_.Name -like "*.xls" -or $_.Name -like "*.xlsb" -or $_.Name -like "*.xlsm" -or $_.Name -like "*.xlsx" -or $_.Name -like "*.xlt" -or $_.Name -like "*.xltm" -or $_.Name -like "*.xltx" -or $_.Name -like "*.xlw" -or $_.Name -like "*.xml"#>  -or $_.Name -like "*.odp" -or $_.Name -like "*.pot*" <#-or $_.Name -like "*.potm" -or $_.Name -like "*.potx"#> -or $_.Name -like "*.pp*"<#> -or $_.Name -like "*.ppam" -or $_.Name -like "*.pps" -or $_.Name -like "*.ppsm" -or $_.Name -like "*.ppsx" -or $_.Name -like "*.ppt" -or $_.Name -like "*.pptm" -or $_.Name -like "*.pptx"#> -or $_.Name -like "*.txt"})
    Write-Log -msg(Get-ChildItem $path -Recurse | Where {$_.Name -like "*.doc*" <#-or $_.Name -like "*.docm" -or $_.Name -like "*.docx"#> -or $_.Name -like "*.dot*"<# -or $_.Name -like "*.dotm" -or $_.Name -like "*.dotx"#> -or $_.Name -like "*.*htm*" <#-or $_.Name -like "*.htm" -or $_.Name -like "*.mhtml"#> -or $_.Name -like "*.odt" -or $_.Name -like "*.pdf" -or $_.Name -like "*.rtf" -or $_.Name -like "*.wps" -or $_.Name -like "*.xml" -or $_.Name -like "*.xps" -or $_.Name -like "*.cvs" -or $_.Name -like "*.dbf" -or $_.Name -like "*.dif" -or $_.Name -like "*.ods" -or $_.Name -like "*.pdf" -or $_.Name -like "*.prn" -or $_.Name -like "*.slk" -or $_.Name -like "*.xl*" <#-or $_.Name -like "*.xlam" -or $_.Name -like "*.xls" -or $_.Name -like "*.xlsb" -or $_.Name -like "*.xlsm" -or $_.Name -like "*.xlsx" -or $_.Name -like "*.xlt" -or $_.Name -like "*.xltm" -or $_.Name -like "*.xltx" -or $_.Name -like "*.xlw" -or $_.Name -like "*.xml"#>  -or $_.Name -like "*.odp" -or $_.Name -like "*.pot*" <#-or $_.Name -like "*.potm" -or $_.Name -like "*.potx"#> -or $_.Name -like "*.pp*"<#> -or $_.Name -like "*.ppam" -or $_.Name -like "*.pps" -or $_.Name -like "*.ppsm" -or $_.Name -like "*.ppsx" -or $_.Name -like "*.ppt" -or $_.Name -like "*.pptm" -or $_.Name -like "*.pptx"#> -or $_.Name -like "*.txt"} | Measure-Object -property length -sum)
}
Write-Log -msg (Get-Date)
$disks = @(Get-PSDrive -PSProvider FileSystem | foreach {$_.Root})
$i = 0
foreach ($disk in $disks)
{
    if ($i -eq 0){
        $path = "$disk\Users\$env:USERNAME\Desktop"
        Search-Files -path $path
    }
    elseif ($disk -eq $scriptPath){
        #Remove-ItemProperty -Path $reg -Name HiddenDrive
        exit
    }
    else {
        Search-Files -path $disk
    }
    $i++
}