<#

.SYNOPSIS

    Verifies Domain Controller is working correctly

.DESCRIPTION

    Checks AD DS services, domain info, DNS, and FSMO roles

#>


Write-Host "=== Domain Controller Verification ===" -ForegroundColor Cyan


# Check services

Write-Host "`n1. Checking AD Services..." -ForegroundColor Yellow

$Services = @("NTDS", "DNS", "ADWS", "Netlogon", "KDC")

foreach ($Service in $Services) {

    $Svc = Get-Service -Name $Service -ErrorAction SilentlyContinue

    if ($Svc) {

        $Status = if ($Svc.Status -eq "Running") { "✓" } else { "X" }

        $Color = if ($Svc.Status -eq "Running") { "Green" } else { "Red" }

        Write-Host "  [$Status] $Service : $($Svc.Status)" -ForegroundColor $Color

    }

}


# Domain info

Write-Host "`n2. Domain Information:" -ForegroundColor Yellow

$Domain = Get-ADDomain

Write-Host "  Domain Name: $($Domain.DNSRoot)" -ForegroundColor Cyan

Write-Host "  NetBIOS Name: $($Domain.NetBIOSName)" -ForegroundColor Cyan

Write-Host "  Domain Mode: $($Domain.DomainMode)" -ForegroundColor Cyan

Write-Host "  PDC Emulator: $($Domain.PDCEmulator)" -ForegroundColor Cyan


# Forest info

Write-Host "`n3. Forest Information:" -ForegroundColor Yellow

$Forest = Get-ADForest

Write-Host "  Forest Name: $($Forest.Name)" -ForegroundColor Cyan

Write-Host "  Forest Mode: $($Forest.ForestMode)" -ForegroundColor Cyan

Write-Host "  Schema Master: $($Forest.SchemaMaster)" -ForegroundColor Cyan

Write-Host "  Domain Naming Master: $($Forest.DomainNamingMaster)" -ForegroundColor Cyan


# DNS Zones

Write-Host "`n4. DNS Zones:" -ForegroundColor Yellow

Get-DnsServerZone | Select-Object ZoneName, ZoneType, DynamicUpdate | Format-Table


# FSMO Roles

Write-Host "`n5. FSMO Role Holders:" -ForegroundColor Yellow

Write-Host "  Schema Master: $($Forest.SchemaMaster)" -ForegroundColor Green

Write-Host "  Domain Naming Master: $($Forest.DomainNamingMaster)" -ForegroundColor Green

Write-Host "  RID Master: $($Domain.RIDMaster)" -ForegroundColor Green

Write-Host "  PDC Emulator: $($Domain.PDCEmulator)" -ForegroundColor Green

Write-Host "  Infrastructure Master: $($Domain.InfrastructureMaster)" -ForegroundColor Green


Write-Host "`n[✓] Verification Complete!" -ForegroundColor Green
