<#

.SYNOPSIS

    Promotes server to Domain Controller

.DESCRIPTION

    Creates new forest and domain: lab.local

.NOTES

    Server will restart automatically after promotion

#>


param(

    [string]$DomainName = "lab.local",

    [string]$DomainNetBIOSName = "LAB",

    [string]$SafeModePassword = "P@ssw0rd123!ForestRecovery"

)


Write-Host "=== Promoting to Domain Controller ===" -ForegroundColor Cyan

Write-Host "Domain: $DomainName" -ForegroundColor Yellow

Write-Host "NetBIOS: $DomainNetBIOSName" -ForegroundColor Yellow


# Import module

Import-Module ADDSDeployment


# Convert password to secure string

$SecurePassword = ConvertTo-SecureString $SafeModePassword -AsPlainText -Force


# Promote to DC

Write-Host "`nStarting promotion... (This will take several minutes)" -ForegroundColor Green

Write-Host "[!] Server will restart automatically when complete" -ForegroundColor Yellow


try {

    Install-ADDSForest `

        -DomainName $DomainName `

        -DomainNetbiosName $DomainNetBIOSName `

        -ForestMode "WinThreshold" `

        -DomainMode "WinThreshold" `

        -InstallDns:$true `

        -DatabasePath "C:\Windows\NTDS" `

        -LogPath "C:\Windows\NTDS" `

        -SysvolPath "C:\Windows\SYSVOL" `

        -SafeModeAdministratorPassword $SecurePassword `

        -Force:$true

}

catch {

    Write-Host "[X] Error during promotion: $_" -ForegroundColor Red

    exit 1

}
