#########################################################################################################################################################
# vlt otherapps script
# last revision:
# 03/09/2025
# lastchange:
# @ update remove obsidian & add spotify in msapps
#########################################################################################################################################################

# Richiesta dei privilegi Amministrativi se necessario
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
	Start-Process pwsh.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
	Exit
}

$logname = "vlt-otherapps.txt"
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
"KDE.Krita",
"MartiCliment.UniGetUI",
"Git.Git",
"OpenJS.NodeJS",
"CharlesMilette.TranslucentTB"
)

$msapps = @(
"9NT1R1C2HH7J", # chatgpt msstore
"9NCBCSZSJRSB", # spotify msstore
"9NKSQGP7F2NH", # whatsapp msstore
"9P8LTPGCBZXD"  # wintoys
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

log "Installazione otherapps completata."

#chiusura transript e disable script var
Write-Output ""
$Global:TranscriptEnabled = $false
Stop-Transcript
