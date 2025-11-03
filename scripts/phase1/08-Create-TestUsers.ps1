<#

.SYNOPSIS

    Creates test users for Active Directory lab

.DESCRIPTION

    Generates realistic test accounts across different OUs with proper attributes

.NOTES

    Author: Robert Gorman

    Date: October 22, 2025

    Default Password: P@ssw0rd123!

#>


$DomainDN = (Get-ADDomain).DistinguishedName

$DefaultPassword = ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force


# IT Staff Users

$ITStaffOU = "OU=IT-Staff,OU=LAB-Users,$DomainDN"

$ITUsers = @(

    @{First="John"; Last="Smith"; Title="IT Manager"; Dept="Information Technology"},

    @{First="Sarah"; Last="Johnson"; Title="Systems Administrator"; Dept="Information Technology"},

    @{First="Mike"; Last="Williams"; Title="Help Desk Technician"; Dept="Information Technology"}

)


Write-Host "=== Creating Test Users ===" -ForegroundColor Green

Write-Host "`nCreating IT Staff..." -ForegroundColor Yellow


foreach ($User in $ITUsers) {

    $Username = "$($User.First).$($User.Last)".ToLower()

    $DisplayName = "$($User.First) $($User.Last)"

    $Email = "$Username@lab.local"

    

    try {

        New-ADUser `

            -Name $DisplayName `

            -GivenName $User.First `

            -Surname $User.Last `

            -SamAccountName $Username `

            -UserPrincipalName $Email `

            -EmailAddress $Email `

            -Title $User.Title `

            -Department $User.Dept `

            -Path $ITStaffOU `

            -AccountPassword $DefaultPassword `

            -Enabled $true `

            -ChangePasswordAtLogon $true

        

        Write-Host "  [✓] Created: $DisplayName ($Username)" -ForegroundColor Cyan

    }

    catch {

        Write-Host "  [!] Error creating $DisplayName : $_" -ForegroundColor Red

    }

}


# Faculty Users

$FacultyOU = "OU=Faculty,OU=LAB-Users,$DomainDN"

$FacultyUsers = @(

    @{First="Robert"; Last="Brown"; Title="Professor"; Dept="Computer Science"},

    @{First="Emily"; Last="Davis"; Title="Associate Professor"; Dept="Mathematics"},

    @{First="David"; Last="Miller"; Title="Assistant Professor"; Dept="Engineering"}

)


Write-Host "`nCreating Faculty..." -ForegroundColor Yellow


foreach ($User in $FacultyUsers) {

    $Username = "$($User.First).$($User.Last)".ToLower()

    $DisplayName = "$($User.First) $($User.Last)"

    $Email = "$Username@lab.local"

    

    try {

        New-ADUser `

            -Name $DisplayName `

            -GivenName $User.First `

            -Surname $User.Last `

            -SamAccountName $Username `

            -UserPrincipalName $Email `

            -EmailAddress $Email `

            -Title $User.Title `

            -Department $User.Dept `

            -Path $FacultyOU `

            -AccountPassword $DefaultPassword `

            -Enabled $true `

            -ChangePasswordAtLogon $true

        

        Write-Host "  [✓] Created: $DisplayName ($Username)" -ForegroundColor Cyan

    }

    catch {

        Write-Host "  [!] Error creating $DisplayName : $_" -ForegroundColor Red

    }

}


# Student Users

$StudentOU = "OU=Students,OU=LAB-Users,$DomainDN"

$StudentUsers = @(

    @{First="Alex"; Last="Wilson"; Dept="Computer Science"},

    @{First="Jessica"; Last="Moore"; Dept="Engineering"},

    @{First="Chris"; Last="Taylor"; Dept="Mathematics"},

    @{First="Amanda"; Last="Anderson"; Dept="Computer Science"}

)


Write-Host "`nCreating Students..." -ForegroundColor Yellow


foreach ($User in $StudentUsers) {

    $Username = "$($User.First).$($User.Last)".ToLower()

    $DisplayName = "$($User.First) $($User.Last)"

    $Email = "$username@student.lab.local"

    

    try {

        New-ADUser `

            -Name $DisplayName `

            -GivenName $User.First `

            -Surname $User.Last `

            -SamAccountName $Username `

            -UserPrincipalName $Email `

            -EmailAddress $Email `

            -Title "Student" `

            -Department $User.Dept `

            -Path $StudentOU `

            -AccountPassword $DefaultPassword `

            -Enabled $true `

            -ChangePasswordAtLogon $true

        

        Write-Host "  [✓] Created: $DisplayName ($Username)" -ForegroundColor Cyan

    }

    catch {

        Write-Host "  [!] Error creating $DisplayName : $_" -ForegroundColor Red

    }

}


Write-Host "`n=== User Creation Complete ===" -ForegroundColor Green

Write-Host "Total Users Created: $($ITUsers.Count + $FacultyUsers.Count + $StudentUsers.Count)" -ForegroundColor Yellow

Write-Host "`nDefault Password: P@ssw0rd123!" -ForegroundColor Yellow

Write-Host "Users must change password at next logon" -ForegroundColor Yellow
