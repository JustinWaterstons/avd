# Setup of the required environment variables
$appName = 'SAP'
$tempDirectory = 'C:\Temp\'
New-Item `
    -Path $tempDirectory `
    -Name $appName `
    -ItemType Directory `
    -ErrorAction SilentlyContinue
$LocalPath = $tempDirectory + $appName

# Download the SAP database client
Write-Host 'AIB Customisation: Downloading the SAP HANA Database Client'
$webSocketsURL = 'https://stappinkavdscripts.blob.core.windows.net/scripts/SAP_HANA_CLIENT.zip'
$webSocketsInstallerZip = 'SAP_HANA_CLIENT.zip'
$outputPath = $LocalPath + '\' + $webSocketsInstallerZip
(New-Object System.Net.WebClient).DownloadFile("$webSocketsURL","$outputPath")
Write-Host 'AIB Customisation: Downloading of the SAP HANA Database Client finished'

# install sap database client
Write-Host 'AIB Customisation: Installing the SAP HANA Database Client'

$installPath = "c:\program files\sap\hdbclient"
$Args = @"
"--path=$installPath" "--batch"
"@

Write-Host 'AIB Customisation: Extracting the SAP HANA Database Client'
Expand-Archive $outputPath -DestinationPath $LocalPath -Force -Verbose
$extractLocation = $LocalPath + "\SAP_HANA_CLIENT"
Set-Location $extractLocation

Start-Process `
    -FilePath .\hdbinst.exe `
    -Args $Args `
    -Wait
Write-Host 'AIB Customisation: Installation of the SAP HANA Database Client finished'

# Copy the SAP installation folder
Write-Host 'AIB Customisation: Copying the SAP Business 1 Client'
Copy-Item -Path "\\10.1.10.4\software\B1H100002111HF_1-70004122" -Destination $LocalPath -Force -Recurse

# Install SAP B1 Client
Write-Host 'AIB Customisation: Installing the SAP Business 1 Client'
$clientPath = $LocalPath + "\\B1H100002111HF_1-70004122\Packages.x64\Client"

Set-Location $clientPath
Start-Process `
    -FilePath .\setup.exe `
    -Args "/S /z""C:\Program Files\SAP\SAP Business One Client\HDB@10.1.10.4:30013"""`
    -Wait
Write-Host 'AIB Customisation: Installation of the SAP Business 1 Client finished'

Set-Location $LocalPath
curl https://stappinkavdscripts.blob.core.windows.net/scripts/b1-local-machine.xml -UseBasicParsing
Copy-Item .\b1-local-machine.xml -Destination "C:\Program Files\sap\SAP Business One\Conf" -Force
Set-Location C:\temp
Remove-Item $LocalPath -Force -Recurse