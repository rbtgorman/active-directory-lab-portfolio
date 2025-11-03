<#

.SYNOPSIS

    Configures static IP for Domain Controller

.DESCRIPTION

    Sets static IP, DNS, and prepares server for DC promotion

.NOTES

    Run this BEFORE promoting to DC

#>


param(

    [string]$IPAddress = "192.168.1.10",

    [string]$PrefixLength = "24",

    [string]$DefaultGateway = "192.168.1.1",

    [string]$InterfaceAlias = "Ethernet"

)


Write-Host "=== Configuring Static IP ===" -ForegroundColor Cyan


# Show current configuration

Write-Host "`nCurrent IP Configuration:" -ForegroundColor Yellow

Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias $InterfaceAlias


# Remove existing IP if DHCP

$ExistingIP = Get-NetIPAddress -InterfaceAlias $InterfaceAlias -AddressFamily IPv4 -ErrorAction SilentlyContinue

if ($ExistingIP.PrefixOrigin -eq "Dhcp") {

    Write-Host "Removing DHCP configuration..." -ForegroundColor Yellow

    Remove-NetIPAddress -InterfaceAlias $InterfaceAlias -AddressFamily IPv4 -Confirm:$false

    Remove-NetRoute -InterfaceAlias $InterfaceAlias -Confirm:$false

}


# Set static IP

Write-Host "`nSetting static IP: $IPAddress/$PrefixLength" -ForegroundColor Green

New-NetIPAddress -InterfaceAlias $InterfaceAlias -IPAddress $IPAddress -PrefixLength $PrefixLength -DefaultGateway $DefaultGateway


# Set DNS to loopback (for future DC)

Write-Host "Setting DNS to loopback (127.0.0.1)..." -ForegroundColor Green

Set-DnsClientServerAddress -InterfaceAlias $InterfaceAlias -ServerAddresses "127.0.0.1"


# Verify

Write-Host "`nNew IP Configuration:" -ForegroundColor Yellow

Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias $InterfaceAlias

Get-DnsClientServerAddress -InterfaceAlias $InterfaceAlias


Write-Host "`n[✓] Static IP configuration complete!" -ForegroundColor Green
