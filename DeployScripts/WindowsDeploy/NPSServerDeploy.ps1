# Instalar el rol de Network Policy Server (NPS)
Install-WindowsFeature -Name NPAS -IncludeManagementTools

# Importar el módulo NPS
Import-Module Nps

# Configurar NPS para registrar eventos en el visor de eventos
New-NpsRadiusClient -Name "RadiusClient" -Address "192.168.1.100" -SharedSecret "YourSharedSecret"
Set-NpsRadiusClient -Name "RadiusClient" -NasIdentifier "MyNASIdentifier"

# Crear una política de red para autenticar conexiones
$policy = New-NpsNetworkPolicy -Name "Allow Wi-Fi Access" -ProcessingOrder 1 -Description "Allow Wi-Fi access to domain users" -Enabled $true
Add-NpsCondition -PolicyName "Allow Wi-Fi Access" -Type "Windows-Groups" -AttributeValue "Domain Users"
Add-NpsCondition -PolicyName "Allow Wi-Fi Access" -Type "NAS-IP-Address" -AttributeValue "192.168.1.100"
Add-NpsConstraint -PolicyName "Allow Wi-Fi Access" -Type "Authentication-Type" -AttributeValue "EAP-MSCHAPv2"
Add-NpsSetting -PolicyName "Allow Wi-Fi Access" -Type "Service-Type" -AttributeValue "Framed"

# Crear una política de solicitud de conexión para reenviar las solicitudes de autenticación a un servidor RADIUS
$connectionPolicy = New-NpsConnectionRequestPolicy -Name "Forward to RADIUS" -ProcessingOrder 1 -Description "Forward requests to RADIUS server" -Enabled $true
Add-NpsCondition -PolicyName "Forward to RADIUS" -Type "NAS-IP-Address" -AttributeValue "192.168.1.100"
Add-NpsConstraint -PolicyName "Forward to RADIUS" -Type "Authentication-Type" -AttributeValue "EAP-MSCHAPv2"
Add-NpsSetting -PolicyName "Forward to RADIUS" -Type "Authentication-Provider" -AttributeValue "RADIUS"

Write-Host "Instalación y configuración del rol de NPS completada con éxito."