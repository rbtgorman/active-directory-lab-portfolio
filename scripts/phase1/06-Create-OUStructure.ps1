<#

.SYNOPSIS

    Creates standardized OU structure for lab.local domain

.DESCRIPTION

    Implements organizational unit hierarchy for computer, user, and resource management

.NOTES

    Author: Robert Gorman

    Date: October 22, 2025

    Domain: lab.local

#>


# Get domain DN

$DomainDN = (Get-ADDomain).DistinguishedName


# Create top-level OUs

$TopLevelOUs = @(

    "LAB-Computers",

    "LAB-Users",

    "LAB-Groups",

    "LAB-Resources"

)


Write-Host "Creating top-level OUs..." -ForegroundColor Green

foreach ($OU in $TopLevelOUs) {

    try {

        New-ADOrganizationalUnit -Name $OU -Path $DomainDN -ProtectedFromAccidentalDeletion $true

        Write-Host "  [✓] Created $OU" -ForegroundColor Cyan

    }

    catch {

        Write-Host "  [!] $OU may already exist or error occurred: $_" -ForegroundColor Yellow

    }

}


# Create Computer sub-OUs

Write-Host "`nCreating Computer sub-OUs..." -ForegroundColor Green

$ComputerOUs = @("Workstations", "Laptops", "Servers")

foreach ($OU in $ComputerOUs) {

    try {

        New-ADOrganizationalUnit -Name $OU -Path "OU=LAB-Computers,$DomainDN" -ProtectedFromAccidentalDeletion $true

        Write-Host "  [✓] Created $OU" -ForegroundColor Cyan

    }

    catch {

        Write-Host "  [!] Error: $_" -ForegroundColor Yellow

    }

}


# Create User sub-OUs

Write-Host "`nCreating User sub-OUs..." -ForegroundColor Green

$UserOUs = @("IT-Staff", "Faculty", "Students", "Service-Accounts")

foreach ($OU in $UserOUs) {

    try {

        New-ADOrganizationalUnit -Name $OU -Path "OU=LAB-Users,$DomainDN" -ProtectedFromAccidentalDeletion $true

        Write-Host "  [✓] Created $OU" -ForegroundColor Cyan

    }

    catch {

        Write-Host "  [!] Error: $_" -ForegroundColor Yellow

    }

}


# Create Group sub-OUs

Write-Host "`nCreating Group sub-OUs..." -ForegroundColor Green

$GroupOUs = @("Security-Groups", "Distribution-Groups")

foreach ($OU in $GroupOUs) {

    try {

        New-ADOrganizationalUnit -Name $OU -Path "OU=LAB-Groups,$DomainDN" -ProtectedFromAccidentalDeletion $true

        Write-Host "  [✓] Created $OU" -ForegroundColor Cyan

    }

    catch {

        Write-Host "  [!] Error: $_" -ForegroundColor Yellow

    }

}


# Create Resource sub-OUs

Write-Host "`nCreating Resource sub-OUs..." -ForegroundColor Green

$ResourceOUs = @("Printers", "Shared-Folders")

foreach ($OU in $ResourceOUs) {

    try {

        New-ADOrganizationalUnit -Name $OU -Path "OU=LAB-Resources,$DomainDN" -ProtectedFromAccidentalDeletion $true

        Write-Host "  [✓] Created $OU" -ForegroundColor Cyan

    }

    catch {

        Write-Host "  [!] Error: $_" -ForegroundColor Yellow

    }

}


Write-Host "`n=== OU Structure Creation Complete ===" -ForegroundColor Green

Write-Host "Verify structure with: Get-ADOrganizationalUnit -Filter * | Select-Object Name, DistinguishedName" -ForegroundColor Yellow
