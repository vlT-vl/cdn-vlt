#########################################################################################################################################################
# s2e deployment script
#########################################################################################################################################################

# Richiesta dei privilegi Amministrativi se necessario
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
	Exit
}

# Definizione del file di log
$logFile = "s2e-deployment-log.txt"

# Funzione per registrare i log sia su file che in console
Function Write-Log {
    Param (
        [string]$Message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $Message"
    $logEntry | Out-File -Append -FilePath $logFile
    Write-Output $logEntry
}
# Abilita il logging automatico di tutti i comandi eseguiti
Start-Transcript -Path $logFile -Append

$manifestm365 = https://raw.githubusercontent.com/vlT-vl/winget-remote/refs/heads/main/manifest/m365.yaml
$manifestsophos = https://raw.githubusercontent.com/vlT-vl/winget-remote/refs/heads/main/manifest/sophos-s2e.yaml

# Import del modulo winget remote
Write-Log "importo il modulo remoto 'winget remote all'interno della sessione"
iex (irm "https://raw.githubusercontent.com/vlT-vl/winget-remote/refs/heads/main/WingetRemote.psm1")


# installazione dei pacchetti base con winget standard
Write-Log "Installazione di 7zip"
Write-Log ""
winget install --id=7zip.7zip -e --silent --accept-package-agreements --accept-source-agreements
Write-Log "Installazione di Google Chrome"
Write-Log ""
winget install --id=Google.Chrome -e --silent --accept-package-agreements --accept-source-agreements
Write-Log "Installazione di vcredist 2015-2022 x64 & x86"
Write-Log ""
winget install --id=Microsoft.VCRedist.2015+.x64 -e --silent --accept-package-agreements --accept-source-agreements
winget install --id=Microsoft.VCRedist.2015+.x86 -e --silent --accept-package-agreements --accept-source-agreements
Write-Log "Installazione di Office265"
Write-Log ""
# installazione con il modulo winget remote di m365 e sophos s2e
winget remote $manifestm365
Write-Log "Installazione di Sophos"
Write-Log ""
winget remote $manifestsophos
Write-Log ""
Write-Log "deployment s2e completato."
