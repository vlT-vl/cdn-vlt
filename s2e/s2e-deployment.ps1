#########################################################################################################################################################
# s2e deployment script
#########################################################################################################################################################

# Richiesta dei privilegi Amministrativi se necessario
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Rilanciare lo script con privilegi amministrativi!" -ForegroundColor Red
    Start-Process powershell.exe "-File $($MyInvocation.MyCommand.Path)" -Verb RunAs
    Exit
}

# Definizione del file di log
$logFile = "deployment-s2e.txt"

# Funzione per registrare i log sia su file che in console
Function log {
    Param (
        [string]$Message
    )
    $timestamp = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
    $logEntry = "$timestamp - $Message"
    Write-Output $logEntry
}
# Abilita il logging automatico di tutti i comandi eseguiti
Start-Transcript -Path $logFile -Append
$manifestsophos = "https://raw.githubusercontent.com/vlT-vl/winget-remote/refs/heads/main/manifest/sophos-s2e.yaml"

# Lista delle applicazioni da installare
$apps = @(
	"7zip.7zip",
	"Google.Chrome",
	"Microsoft.Office",
	"Microsoft.VCRedist.2015+.x64",
	"Microsoft.VCRedist.2015+.x86"
)

# installazione dei pacchetti base con winget standard
foreach ($app in $apps) {
    Start-Sleep -Seconds 1
	  log ""
    log "Installazione di $app in corso..." -ForegroundColor Cyan
    winget install $app --silent --accept-package-agreements --accept-source-agreements
}
# Import del modulo winget remote
log "importo il modulo remoto 'winget remote all'interno della sessione"
iex (irm "https://raw.githubusercontent.com/vlT-vl/winget-remote/refs/heads/main/WingetRemote.psm1")

# installazione con il modulo winget remote di sophos s2e
winget remote $manifestsophos
log ""

# sleep di 3 secondi e poi tenta aggiornamento di tutte le app presenti sul pc
Start-Sleep -Seconds 1
winget upgrade --all --silent --accept-source-agreements --accept-package-agreements

log "deployment s2e completato."
irm https://raw.githubusercontent.com/vlT-vl/cdn-vlt/refs/heads/main/s2e/deploymentform.ps1| iex
