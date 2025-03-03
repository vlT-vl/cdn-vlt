#########################################################################################################################################################
# s2e deployment script
# last revision:
# 01/03/2025
# lastchange:
# @ script revision
#########################################################################################################################################################

# Definizione del file di log e output
$logname = "deployment-s2e.txt"
$logFolder = "$env:USERPROFILE\.log"
$logFile = "$logFolder\$logname"

# Verifica esistenza file e log folder
if (-not (Test-Path -Path $logFolder)) {
    New-Item -Path $logFolder -ItemType Directory
}
if (Test-Path $logFile) {
    Remove-Item $logFile -Force
}

# Abilita il logging automatico di tutti i comandi eseguiti
if (-not $TranscriptEnabled) {
    Start-Transcript -Path $logFile -Append
    $Global:TranscriptEnabled = $true
}

# Funzione per registrare i log sia su file che in console
Function log {
    Param ([string]$Message)
    $timestamp = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
    $logEntry = "[$timestamp] $Message"
    Write-Output $logEntry
}

# Ciclo while che attenge che winget risponda prima di proseguire con lo script
while (-not (winget --version 2>$null)) {
    Start-Sleep -Seconds 1
    # Ricarica le variabili d'ambiente nella sessione corrente
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
    $env:Path += ";" + [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
}

# Lista delle applicazioni da installare
$manifestsophos = "https://raw.githubusercontent.com/vlT-vl/winget-remote/refs/heads/main/manifest/sophos-s2e.yaml"
$apps = @(
    "7zip.7zip",
    "Google.Chrome",
		"Microsoft.PowerShell",
    "Microsoft.VCRedist.2015+.x64",
    "Microsoft.VCRedist.2015+.x86",
    "MartiCliment.UniGetUI",
		"Microsoft.Office",
)

# installazione dei pacchetti base con winget standard
foreach ($app in $apps) {
	  Write-Output ""
    log "Installazione di $app in corso..." -ForegroundColor Cyan
    winget install $app --silent --accept-package-agreements --accept-source-agreements
    Write-Output ""
}

# Se attivo forzo chiusura del processo di UniGetUI
Start-Sleep -Seconds 1
Get-Process -Name "UniGetUI" -ErrorAction SilentlyContinue | Stop-Process -Force

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
    log "Winget remote eseguito con successo, installato corretamente il manifest: $manifestsophos"
}

# aggiornamento di tutte le app presenti sul pc
try {
    Start-Sleep -Seconds 10
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

# rimozione di DevHome
try {
    Start-Sleep -Seconds 1
    log "Rimozione del pacchetto DevHome..."
    $removePackage = winget uninstall --id Microsoft.DevHome --silent
    if ($LASTEXITCODE -ne 0) {
        log "Errore durante la rimozione del pacchetto: $removePackage"
    } else {
        log "Rimozione del pacchetto DevHome completata con successo."
    }
} catch {
    log "Eccezione durante la rimozione del pacchetto: $_"
}

$Global:TranscriptEnabled = $false
Stop-Transcript

# Dpeloyment completato mostro form di completamento
try {
    log "deployment s2e completato."
    Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -c Invoke-RestMethod ''https://raw.githubusercontent.com/vlT-vl/cdn-vlt/refs/heads/main/s2e/deploymentform.ps1'' | Invoke-Expression' -WindowStyle Hidden
} catch {
    log "Errore nel recupero del deployment form."
}
