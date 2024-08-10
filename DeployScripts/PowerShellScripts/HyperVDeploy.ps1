# Instalar la característica de Hyper-V
Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart

# Habilitar administración remota de Hyper-V
Enable-PSRemoting -Force

# Configurar el servicio WinRM para administración remota
Set-WSManQuickConfig -Force

# Configurar la administración remota de Hyper-V para permitir conexiones desde otro Hyper-V Manager
Invoke-Command -ScriptBlock {
    Enable-WSManCredSSP -Role Server
} -ComputerName $env:COMPUTERNAME

# Permitir que el cliente use la delegación de credenciales
Enable-WSManCredSSP -Role Client -DelegateComputer $env:COMPUTERNAME

# Configurar el firewall para permitir la conexión a la consola de Hyper-V
New-NetFirewallRule -DisplayName "Hyper-V Remote Management" -Direction Inbound -Protocol TCP -LocalPort 2179 -Action Allow

# Habilitar las reglas predefinidas para la administración remota de Hyper-V en el firewall
Get-NetFirewallRule -DisplayName "Hyper-V-VMMS-In-TCP" | Set-NetFirewallRule -Enabled True
Get-NetFirewallRule -DisplayName "Hyper-V-VMMS-Spooler-In-TCP" | Set-NetFirewallRule -Enabled True
Get-NetFirewallRule -DisplayName "Hyper-V-VMMS-Dcom-In-TCP" | Set-NetFirewallRule -Enabled True
Get-NetFirewallRule -DisplayName "Hyper-V-VMMS-In-UDP" | Set-NetFirewallRule -Enabled True
Get-NetFirewallRule -DisplayName "Hyper-V-VMMS-Out-UDP" | Set-NetFirewallRule -Enabled True

Write-Host "Implementación de Hyper-V y configuración de administración remota completada con éxito."
