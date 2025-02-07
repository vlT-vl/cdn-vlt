#########################################################################################################################################################
# s2e deployment script
#########################################################################################################################################################
Start-Sleep -Seconds 5

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
    Write-Output $logEntry
}
# Abilita il logging automatico di tutti i comandi eseguiti
Start-Transcript -Path $logFile -Append

$manifestm365 = "https://raw.githubusercontent.com/vlT-vl/winget-remote/refs/heads/main/manifest/m365.yaml"
$manifestsophos = "https://raw.githubusercontent.com/vlT-vl/winget-remote/refs/heads/main/manifest/sophos-s2e.yaml"

# Lista delle applicazioni da installare
$apps = @(
	  "7zip.7zip",
    "Google.Chrome",
    "Microsoft.VCRedist.2015+.x64",
    "Microsoft.VCRedist.2015+.x86"
)

# Import del modulo winget remote
Write-Log "importo il modulo remoto 'winget remote all'interno della sessione"
iex (irm "https://raw.githubusercontent.com/vlT-vl/winget-remote/refs/heads/main/WingetRemote.psm1")

# installazione dei pacchetti base con winget standard
foreach ($app in $apps) {
	  Write-Log ""
    Write-Log "Installazione di $app in corso..." -ForegroundColor Cyan
    winget install $app --silent --accept-package-agreements --accept-source-agreements
}

# installazione con il modulo winget remote di m365 e sophos s2e
winget remote $manifestm365
Write-Log "Installazione di Sophos"
Write-Log ""
winget remote $manifestsophos
Write-Log ""
Write-Log "deployment s2e completato."
