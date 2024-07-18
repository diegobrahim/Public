# Instalar el rol de DHCP Server
Install-WindowsFeature -Name DHCP -IncludeManagementTools

# Importar el módulo de DHCP Server
Import-Module DHCPServer

# Crear un ámbito DHCP
$ScopeName = "Scope1"
$ScopeStartRange = "192.168.1.100"
$ScopeEndRange = "192.168.1.200"
$SubnetMask = "255.255.255.0"
$DefaultGateway = "192.168.1.1"
$DNSServer = "192.168.1.1"
$ScopeLeaseTime = (New-TimeSpan -Days 8)

Add-DhcpServerv4Scope -Name $ScopeName -StartRange $ScopeStartRange -EndRange $ScopeEndRange -SubnetMask $SubnetMask -LeaseDuration $ScopeLeaseTime

# Configurar opciones del ámbito DHCP
Set-DhcpServerv4OptionValue -ScopeId $SubnetMask -Router $DefaultGateway
Set-DhcpServerv4OptionValue -ScopeId $SubnetMask -DnsServer $DNSServer

# Autorizar el servidor DHCP en Active Directory
$DhcpServer = $env:COMPUTERNAME
Add-DhcpServerInDC -DnsName $DhcpServer -IPAddress (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -eq "Ethernet" }).IPAddress

Write-Host "Configuración del servidor DHCP completada con éxito."
