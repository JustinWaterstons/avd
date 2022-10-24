# Setup of the required environment variables
$appName = 'PrintDrivers'
$tempDirectory = 'C:\Temp\'
New-Item `
    -Path $tempDirectory `
    -Name $appName `
    -ItemType Directory `
    -ErrorAction SilentlyContinue
$LocalPath = $tempDirectory + $appName

# Download the SAP database client
Write-Host 'AIB Customisation: Downloading Print Drivers'
$webSocketsURL = 'https://stappinkavdscripts.blob.core.windows.net/scripts/HP_LaserJet_200_color_MFP_M276.zip'
$webSocketsInstallerZip = 'HP_LaserJet_200_color_MFP_M276.zip'
$outputPath = $LocalPath + '\' + $webSocketsInstallerZip
(New-Object System.Net.WebClient).DownloadFile("$webSocketsURL","$outputPath")
Write-Host 'AIB Customisation: Downloading of the Print Drivers finished'


# expand archive
Expand-Archive $outputPath -DestinationPath $LocalPath -Force -Verbose

# install sap database client
Write-Host 'AIB Customisation: Installing Printers'
pnputil.exe /a "$($LocalPath)\HP_LaserJet_200_color_MFP_M276\*.inf"
Add-PrinterPort -Name "IP_172_16_2_33" -PrinterHostAddress "172.16.2.33"
Add-PrinterDriver -Name "HP LaserJet 200 color MFP M276 PCL 6" # -InfPath "$($LocalPath)\HP_LaserJet_200_color_MFP_M276\hpcm276u.inf"
Add-Printer -DriverName "HP LaserJet 200 color MFP M276 PCL 6" -Name "HP LaserJet 200 color MFP M276 PCL 6" -PortName IP_172_16_2_33
Write-Host "$($LocalPath)\HP_LaserJet_200_color_MFP_M276\hpcm276c.inf"
