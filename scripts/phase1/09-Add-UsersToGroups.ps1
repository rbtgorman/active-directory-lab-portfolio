<#

.SYNOPSIS

    Adds users to appropriate security groups

.DESCRIPTION

    Configures group memberships based on user roles

.NOTES

    Author: Robert Gorman

    Date: October 22, 2025

#>


Write-Host "=== Adding Users to Security Groups ===" -ForegroundColor Green


# Add IT staff to groups

Write-Host "`nConfiguring IT Staff group memberships..." -ForegroundColor Yellow

try {

    Add-ADGroupMember -Identity "GRP-IT-Staff" -Members "john.smith", "sarah.johnson", "mike.williams"

    Write-Host "  [✓] Added IT staff to GRP-IT-Staff" -ForegroundColor Cyan

    

    Add-ADGroupMember -Identity "GRP-IT-Helpdesk" -Members "mike.williams"

    Write-Host "  [✓] Added help desk technician to GRP-IT-Helpdesk" -ForegroundColor Cyan

    

    Add-ADGroupMember -Identity "GRP-IT-Admins" -Members "john.smith", "sarah.johnson"

    Write-Host "  [✓] Added administrators to GRP-IT-Admins" -ForegroundColor Cyan

}

catch {

    Write-Host "  [!] Error adding IT staff to groups: $_" -ForegroundColor Red

}


# Add faculty to groups

Write-Host "`nConfiguring Faculty group memberships..." -ForegroundColor Yellow

try {

    Add-ADGroupMember -Identity "GRP-Faculty" -Members "robert.brown", "emily.davis", "david.miller"

    Write-Host "  [✓] Added faculty to GRP-Faculty" -ForegroundColor Cyan

}

catch {

    Write-Host "  [!] Error adding faculty to groups: $_" -ForegroundColor Red

}


# Add students to groups

Write-Host "`nConfiguring Student group memberships..." -ForegroundColor Yellow

try {

    Add-ADGroupMember -Identity "GRP-Students" -Members "alex.wilson", "jessica.moore", "chris.taylor", "amanda.anderson"

    Write-Host "  [✓] Added students to GRP-Students" -ForegroundColor Cyan

}

catch {

    Write-Host "  [!] Error adding students to groups: $_" -ForegroundColor Red

}


# Add everyone to printer and WiFi access

Write-Host "`nConfiguring universal access groups (Printer & WiFi)..." -ForegroundColor Yellow

try {

    $AllUsers = Get-ADUser -Filter * -SearchBase "OU=LAB-Users,DC=lab,DC=local"

    $UserCount = 0

    

    foreach ($User in $AllUsers) {

        try {

            Add-ADGroupMember -Identity "GRP-Printer-Access" -Members $User.SamAccountName -ErrorAction SilentlyContinue

            Add-ADGroupMember -Identity "GRP-WiFi-Users" -Members $User.SamAccountName -ErrorAction SilentlyContinue

            $UserCount++

        }

        catch {

            # User might already be a member

        }

    }

    

    Write-Host "  [✓] Added $UserCount users to GRP-Printer-Access" -ForegroundColor Cyan

    Write-Host "  [✓] Added $UserCount users to GRP-WiFi-Users" -ForegroundColor Cyan

}

catch {

    Write-Host "  [!] Error adding users to universal access groups: $_" -ForegroundColor Red

}


# Add IT Admins to Domain Admins (for lab purposes)

Write-Host "`nConfiguring elevated permissions..." -ForegroundColor Yellow

try {

    Add-ADGroupMember -Identity "Domain Admins" -Members "john.smith", "sarah.johnson"

    Write-Host "  [✓] Added IT Admins to Domain Admins group" -ForegroundColor Cyan

}

catch {

    Write-Host "  [!] Error adding to Domain Admins: $_" -ForegroundColor Red

}


Write-Host "`n=== Group Membership Configuration Complete ===" -ForegroundColor Green


# Display summary

Write-Host "`nGroup Membership Summary:" -ForegroundColor Yellow

$Groups = @("GRP-IT-Staff", "GRP-IT-Helpdesk", "GRP-IT-Admins", "GRP-Faculty", "GRP-Students", "GRP-Printer-Access", "GRP-WiFi-Users")


foreach ($GroupName in $Groups) {

    try {

        $Members = Get-ADGroupMember -Identity $GroupName

        Write-Host "  $GroupName : $($Members.Count) members" -ForegroundColor Cyan

    }

    catch {

        Write-Host "  $GroupName : Error retrieving members" -ForegroundColor Red

    }

}
