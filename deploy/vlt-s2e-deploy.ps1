#########################################################################################################################################################
# vlt workapp deploy S2E
# last revision:
# 24/06/2025
# lastchange:
# @ update added msapps & app TranslucentTB
#########################################################################################################################################################

# Richiesta dei privilegi Amministrativi se necessario
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
	Start-Process pwsh.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
	Exit
}

$logname = "vlt-s2e-deploy.txt"
$logFolder = "$env:USERPROFILE\.log"
$hostnamepc = "C-IT01S2E257-PC"

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

# Setto hostname del pc
Rename-Computer -NewName $hostnamepc -Force

# Lista delle applicazioni da installare
$apps = @(
"7zip.7zip",
"Zen-Team.Zen-Browser",
"Bitwarden.Bitwarden",
"Eugeny.Tabby",
"Git.Git",
"OpenJS.NodeJS",
"MartiCliment.UniGetUI",
"Flow-Launcher.Flow-Launcher",
"Pulsar-Edit.Pulsar",
"CharlesMilette.TranslucentTB",
"Microsoft.Office"
)

$msapps = @(
"9NT1R1C2HH7J", # chatgpt msstore
"9NCBCSZSJRSB", # spotify msstore
"9NKSQGP7F2NH", # whatsapp msstore
"9NBXBP78896Q"  # media flyout msstore
)

# installazione dei pacchetti base con winget standard
foreach ($app in $apps) {
	  Write-Output ""
    log "Installazione di $app in corso..." -ForegroundColor Cyan
		winget install --id $app --exact --source winget --accept-source-agreements --disable-interactivity --silent  --accept-package-agreements --force
    Write-Output ""
}

# installazione dei pacchetti msstore con winget
foreach ($msapp in $msapps) {
Write-Output ""
log "Installazione di $msapp in corso..." -ForegroundColor Cyan
winget.exe install --id $msapp --exact --source msstore --accept-source-agreements --disable-interactivity --silent --accept-package-agreements --force
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


#chiusura transript e disable script var
$Global:TranscriptEnabled = $false
Stop-Transcript
