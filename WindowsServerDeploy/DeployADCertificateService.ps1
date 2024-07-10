# Definir las variables de configuración
$CAName = "MyCA"
$CACommonName = "My CA"
$CADistinguishedName = "CN=My CA, O=MyOrganization, C=US"
$CAType = "EnterpriseRootCA"
$DatabasePath = "C:\Windows\System32\CertLog"
$LogPath = "C:\Windows\System32\CertLog"
$ValidityPeriod = 5 # en años

# Instalar el rol de AD CS
Install-WindowsFeature -Name ADCS-Cert-Authority -IncludeManagementTools

# Importar el módulo de AD CS
Import-Module ADCSDeployment

# Instalar y configurar la CA
Install-AdcsCertificationAuthority -CACommonName $CACommonName -CAType $CAType -CryptoProviderName "RSA#Microsoft Software Key Storage Provider" -HashAlgorithmName SHA256 -KeyLength 2048 -ValidityPeriod $ValidityPeriod -DatabaseDirectory $DatabasePath -LogDirectory $LogPath

# Configurar la CA para emitir certificados automáticamente a los miembros del dominio
certutil -setreg CA\CRLPeriodUnits 1
certutil -setreg CA\CRLPeriod "Weeks"
certutil -setreg CA\CRLOverlapPeriodUnits 12
certutil -setreg CA\CRLOverlapPeriod "Hours"
certutil -setreg CA\ValidityPeriodUnits $ValidityPeriod
certutil -setreg CA\ValidityPeriod "Years"
certutil -setreg CA\AuditFilter 127
net stop certsvc
net start certsvc

# Confirmar la instalación y configuración
Write-Host "Instalación y configuración del Servicio de Certificados de Active Directory completada con éxito."
