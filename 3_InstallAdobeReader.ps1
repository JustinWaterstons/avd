# Software install Script
#
# Application to install: Adobe Acrobat Reader DC
#

#region Set logging 
$logFile = "c:\temp\" + (get-date -format 'yyyyMMdd') + '_softwareinstall.log'
function Write-Log {
    Param($message)
    Write-Output "$(get-date -format 'yyyyMMdd HH:mm:ss') $message" | Out-File -Encoding utf8 $logFile -Append
}
#endregion


# Setup of the required environment variables
$appName = 'Adobe'
$tempDirectory = 'C:\Temp\'
New-Item `
    -Path $tempDirectory `
    -Name $appName `
    -ItemType Directory `
    -ErrorAction SilentlyContinue
$LocalPath = $tempDirectory + $appName

# Update Adobe-Acrobat-Reader-DC
Write-Host 'AIB Customisation: Downloading the Adobe-Acrobat-Reader-DC app'
$webSocketsURL = 'https://stappinkavdscripts.blob.core.windows.net/scripts/AcroRdrDC2200220191_en_US.exe'
$downloadedFile = 'AcroRdrDC2200220191_en_US.exe'
$outputPath = $LocalPath + '\' + $downloadedFile
(New-Object System.Net.WebClient).DownloadFile("$webSocketsURL","$outputPath")
Write-Host 'AIB Customisation: Downloading of the Adobe-Acrobat-Reader-DC app finished'


#region Adobe Acrobat Reader
try {
    Start-Process -filepath 'C:\temp\Adobe\AcroRdrDC2200220191_en_US.exe' -Wait -ErrorAction Stop -ArgumentList '/sAll', '/rs', '/msi', 'EULA_ACCEPT=YES'
    if (Test-Path "C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRD32.exe") {
        Write-Host "Acrobat Reader has been installed"
    }
    else {
        write-Host "Error locating the Acrobat Reader executable"
    }
}
catch {
    $ErrorMessage = $_.Exception.message
    write-Host "Error installing Acrobat Reader: $ErrorMessage"
}
#endregion