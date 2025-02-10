#########################################################################################################################################################
# s2e deployment script
#########################################################################################################################################################

# Definizione del file di log
$logFile = "deployment-s2e.txt"

# Funzione per registrare i log sia su file che in console
Function log {
    Param ([string]$Message)
    $timestamp = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
    $logEntry = "[$timestamp] $Message"
    Write-Output $logEntry
}

# Abilita il logging automatico di tutti i comandi eseguiti
if (-not $TranscriptEnabled) {
    Start-Transcript -Path $logFile -Append
    $Global:TranscriptEnabled = $true
}

# Lista delle applicazioni da installare
$apps = @(
	"7zip.7zip",
	"Google.Chrome",
	"Microsoft.Office",
	"Microsoft.VCRedist.2015+.x64",
	"Microsoft.VCRedist.2015+.x86",
  "Microsoft.PowerShell"
)
$manifestsophos = "https://raw.githubusercontent.com/vlT-vl/winget-remote/refs/heads/main/manifest/sophos-s2e.yaml"

# installazione dei pacchetti base con winget standard
foreach ($app in $apps) {
    Start-Sleep -Seconds 1
	  log ""
    log "Installazione di $app in corso..." -ForegroundColor Cyan
    winget install $app --silent --accept-package-agreements --accept-source-agreements
}
# Import del modulo winget remote
log "Importo il modulo remoto 'winget remote' all'interno della sessione"
try {
    Invoke-RestMethod "https://raw.githubusercontent.com/vlT-vl/winget-remote/refs/heads/main/WingetRemote.psm1" | Invoke-Expression
    log "Modulo 'winget remote' caricato correttamente."
} catch {
    log "Errore nell'importazione del modulo 'winget remote'."
}

# installazione con il modulo winget remote di sophos s2e
$result = winget remote $manifestsophos
if ($LASTEXITCODE -ne 0) {
    log "Errore durante l'esecuzione di winget remote: $result"
} else {
    log "Winget remote eseguito con successo."
}

# aggiornamento di tutte le app presenti sul pc
try {
    Start-Sleep -Seconds 2
    log "Aggiornamento di tutte le applicazioni in corso..."
    $upgradeResult = winget upgrade --all --silent --accept-source-agreements --accept-package-agreements
    if ($LASTEXITCODE -ne 0) {
        log "Errore durante l'aggiornamento delle applicazioni: $upgradeResult"
    } else {
        log "Aggiornamento delle applicazioni completato con successo."
    }
} catch {
    log "Eccezione catturata durante l'aggiornamento delle applicazioni: $_"
}

# Dpeloyment completato mostro form di completamento
try {
    log "deployment s2e completato."
    Invoke-RestMethod "https://raw.githubusercontent.com/vlT-vl/cdn-vlt/refs/heads/main/s2e/deploymentform.ps1" | Invoke-Expression; exit
} catch {
    log "Errore nel recupero del deployment form."
}
