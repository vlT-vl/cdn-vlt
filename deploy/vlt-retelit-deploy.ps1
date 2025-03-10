#########################################################################################################################################################
# vlt workapp deploy RETELIT
# last revision:
# 03/03/2025
# lastchange:
# @ added win activation script
#########################################################################################################################################################

# Richiesta dei privilegi Amministrativi se necessario
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
	Start-Process pwsh.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
	Exit
}

$logname = "vlt-retelit-deploy.txt"
$logFolder = "$env:USERPROFILE\.log"

# Definizione del file di log e output
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

# Lista delle applicazioni da installare
$apps = @(
    "7zip.7zip",
    "Zen-Team.Zen-Browser",
    "Bitwarden.Bitwarden",
		"Flow-Launcher.Flow-Launcher",
    "Eugeny.Tabby",
    "MartiCliment.UniGetUI",
		"Robware.RVTools",
		"ONLYOFFICE.DesktopEditors"
)

# installazione dei pacchetti base con winget standard
foreach ($app in $apps) {
	  Write-Output ""
    log "Installazione di $app in corso..." -ForegroundColor Cyan
    winget install $app --silent --accept-package-agreements --accept-source-agreements
    Write-Output ""
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

# attivazione di windows from script
Write-Output ""
log "Avvio script attivazione di windows"
irm https://get.activated.win | iex

#chiusura transript e disable script var
$Global:TranscriptEnabled = $false
Stop-Transcript
