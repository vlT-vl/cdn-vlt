#########################################################################################################################################################
# windows activation script
#########################################################################################################################################################

# Richiesta dei privilegi Amministrativi se necessario - powershell old
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
	Exit
}

irm https://get.activated.win | iex
