<#

.SYNOPSIS

    Comprehensive verification of Phase 1 completion

.DESCRIPTION

    Verifies OUs, users, groups, and memberships

.NOTES

    Author: Robert Gorman

    Date: October 22, 2025

#>


Write-Host "=== Phase 1 Verification Report ===" -ForegroundColor Cyan

Write-Host "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray

Write-Host "Domain: $(Get-ADDomain | Select-Object -ExpandProperty DNSRoot)" -ForegroundColor Gray


# OU Count

Write-Host "`n========================================" -ForegroundColor Gray

Write-Host "1. ORGANIZATIONAL UNITS" -ForegroundColor Yellow

Write-Host "========================================" -ForegroundColor Gray


$OUs = Get-ADOrganizationalUnit -Filter * | Where-Object {$_.DistinguishedName -notlike "*Domain Controllers*"}

Write-Host "Total OUs Created: $($OUs.Count)" -ForegroundColor Cyan


Write-Host "`nOU Structure:" -ForegroundColor White

$OUs | Select-Object Name, @{Name='Path';Expression={$_.DistinguishedName}} | 

    Sort-Object Path | Format-Table -AutoSize


# User Count

Write-Host "`n========================================" -ForegroundColor Gray

Write-Host "2. USER ACCOUNTS" -ForegroundColor Yellow

Write-Host "========================================" -ForegroundColor Gray


$Users = Get-ADUser -Filter * -SearchBase "OU=LAB-Users,DC=lab,DC=local" -Properties Department, Title

Write-Host "Total Users: $($Users.Count)" -ForegroundColor Cyan


# Users by OU

Write-Host "`nUsers by OU:" -ForegroundColor White

$UsersByOU = $Users | Group-Object {($_.DistinguishedName -split ',',2)[1]}

foreach ($OU in $UsersByOU | Sort-Object Name) {

    $OUName = ($OU.Name -split ',')[0] -replace 'OU='

    Write-Host "  $OUName : $($OU.Count) users" -ForegroundColor Cyan

    foreach ($User in $OU.Group) {

        Write-Host "    - $($User.Name) ($($User.SamAccountName)) - $($User.Title)" -ForegroundColor Gray

    }

}


# Group Count

Write-Host "`n========================================" -ForegroundColor Gray

Write-Host "3. SECURITY GROUPS" -ForegroundColor Yellow

Write-Host "========================================" -ForegroundColor Gray


$Groups = Get-ADGroup -Filter {GroupCategory -eq 'Security'} -SearchBase "OU=LAB-Groups,DC=lab,DC=local" -Properties Description

Write-Host "Total Groups: $($Groups.Count)" -ForegroundColor Cyan


Write-Host "`nGroup Details:" -ForegroundColor White

$Groups | Select-Object Name, Description | Format-Table -AutoSize


# Group Memberships

Write-Host "`n========================================" -ForegroundColor Gray

Write-Host "4. GROUP MEMBERSHIPS" -ForegroundColor Yellow

Write-Host "========================================" -ForegroundColor Gray


foreach ($Group in $Groups | Sort-Object Name) {

    $Members = Get-ADGroupMember -Identity $Group -ErrorAction SilentlyContinue

    $MemberNames = $Members | Select-Object -ExpandProperty Name

    

    if ($Members) {

        Write-Host "`n$($Group.Name) ($($Members.Count) members):" -ForegroundColor Cyan

        foreach ($Member in $MemberNames | Sort-Object) {

            Write-Host "  - $Member" -ForegroundColor Gray

        }

    } else {

        Write-Host "`n$($Group.Name) : No members" -ForegroundColor Yellow

    }

}


# Domain Admin Check

Write-Host "`n========================================" -ForegroundColor Gray

Write-Host "5. PRIVILEGED ACCESS" -ForegroundColor Yellow

Write-Host "========================================" -ForegroundColor Gray


$DomainAdmins = Get-ADGroupMember -Identity "Domain Admins"

Write-Host "Domain Admins ($($DomainAdmins.Count) members):" -ForegroundColor Cyan

foreach ($Admin in $DomainAdmins) {

    Write-Host "  - $($Admin.Name)" -ForegroundColor Gray

}


# Final Summary

Write-Host "`n========================================" -ForegroundColor Gray

Write-Host "PHASE 1 SUMMARY" -ForegroundColor Green

Write-Host "========================================" -ForegroundColor Gray


Write-Host "  [✓] Domain Controller: $(hostname)" -ForegroundColor Green

Write-Host "  [✓] Domain: $(Get-ADDomain | Select-Object -ExpandProperty DNSRoot)" -ForegroundColor Green

Write-Host "  [✓] OUs Created: $($OUs.Count)" -ForegroundColor Green

Write-Host "  [✓] Users Created: $($Users.Count)" -ForegroundColor Green

Write-Host "  [✓] Groups Created: $($Groups.Count)" -ForegroundColor Green

Write-Host "  [✓] Domain Admins Configured: $($DomainAdmins.Count)" -ForegroundColor Green


$TotalMemberships = 0

foreach ($Group in $Groups) {

    $MemberCount = (Get-ADGroupMember -Identity $Group -ErrorAction SilentlyContinue).Count

    $TotalMemberships += $MemberCount

}

Write-Host "  [✓] Total Group Memberships: $TotalMemberships" -ForegroundColor Green


Write-Host "`n========================================" -ForegroundColor Gray

Write-Host "[✓] PHASE 1 COMPLETE!" -ForegroundColor Green

Write-Host "========================================" -ForegroundColor Gray


Write-Host "`nNext Steps:" -ForegroundColor Yellow

Write-Host "  - Take screenshots for documentation" -ForegroundColor White

Write-Host "  - Update README.md with completion status" -ForegroundColor White

Write-Host "  - Begin Phase 2: Group Policy Objects" -ForegroundColor White
