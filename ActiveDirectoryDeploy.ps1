# Script para implementar Active Directory en Windows Server 2022

# Crear variables para el dominio y la contraseña del administrador del dominio
$domainName = Read-Host -Prompt "Ingrese el nombre del dominio"
$adminPassword = Read-Host -Prompt "Ingrese la contraseña del administrador del dominio" -AsSecureString

# Instalar el rol de Active Directory Domain Services
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Importar el módulo ADDSDeployment
Import-Module ADDSDeployment

# Configurar un nuevo bosque de Active Directory
Install-ADDSForest `
    -DomainName $domainName `
    -SafeModeAdministratorPassword $adminPassword `
    -InstallDns

Write-Host "La implementación de Active Directory se ha completado."
