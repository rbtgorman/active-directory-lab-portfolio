<#

.SYNOPSIS

    Creates security groups for lab environment

.DESCRIPTION

    Creates role-based security groups with descriptions

.NOTES

    Author: Robert Gorman

    Date: October 22, 2025

#>


$DomainDN = (Get-ADDomain).DistinguishedName

$GroupsOU = "OU=Security-Groups,OU=LAB-Groups,$DomainDN"


$SecurityGroups = @(

    @{Name="GRP-IT-Staff"; Description="IT Department Staff"},

    @{Name="GRP-IT-Helpdesk"; Description="Level 1 & 2 Help Desk Technicians"},

    @{Name="GRP-IT-Admins"; Description="Domain Administrators"},

    @{Name="GRP-Faculty"; Description="Faculty Members"},

    @{Name="GRP-Students"; Description="Student Users"},

    @{Name="GRP-Printer-Access"; Description="Users with printer access"},

    @{Name="GRP-VPN-Users"; Description="VPN Access"},

    @{Name="GRP-WiFi-Users"; Description="Wireless Network Access"}

)


Write-Host "=== Creating Security Groups ===" -ForegroundColor Green


foreach ($Group in $SecurityGroups) {

    try {

        New-ADGroup `

            -Name $Group.Name `

            -SamAccountName $Group.Name `

            -GroupCategory Security `

            -GroupScope Global `

            -DisplayName $Group.Name `

            -Path $GroupsOU `

            -Description $Group.Description

        

        Write-Host "[✓] Created group: $($Group.Name)" -ForegroundColor Cyan

    }

    catch {

        Write-Host "[!] Error creating $($Group.Name): $_" -ForegroundColor Yellow

    }

}


Write-Host "`n=== Security Group Creation Complete ===" -ForegroundColor Green

Write-Host "Total Groups Created: $($SecurityGroups.Count)" -ForegroundColor Yellow
