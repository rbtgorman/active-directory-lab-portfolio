<#
.SYNOPSIS
    Bulk Active Directory user creation from CSV file
.DESCRIPTION
    Reads a CSV file and creates AD users with proper attributes and group assignments
.PARAMETER CsvPath
    Path to the CSV file containing user data
.EXAMPLE
    .\New-BulkADUsers.ps1 -CsvPath "C:\ADScripts\NewUsers.csv"
.NOTES
    Author: Your Name
    Date: 2025-11-04
    CSV Format: FirstName,LastName,SamAccountName,Department,Title,Office
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$CsvPath,
    
    [Parameter(Mandatory=$false)]
    [string]$DefaultPassword = "Welcome2025!",
    
    [Parameter(Mandatory=$false)]
    [bool]$ChangePasswordAtLogon = $true
)

# Import CSV
try {
    $users = Import-Csv -Path $CsvPath
    Write-Host "Successfully imported $($users.Count) users from CSV" -ForegroundColor Green
} catch {
    Write-Host "Error importing CSV: $_" -ForegroundColor Red
    exit 1
}

# Counter for success/failures
$successCount = 0
$failCount = 0
$results = @()

# Process each user
foreach ($user in $users) {
    $ouPath = switch ($user.Department) {
        "IT"      { "OU=IT,OU=Departments,DC=lab,DC=local" }
        "HR"      { "OU=HR,OU=Departments,DC=lab,DC=local" }
        "Finance" { "OU=Finance,OU=Departments,DC=lab,DC=local" }
        default   { "OU=Departments,DC=lab,DC=local" }
    }
    
    $userParams = @{
        Name                  = "$($user.FirstName) $($user.LastName)"
        GivenName            = $user.FirstName
        Surname              = $user.LastName
        SamAccountName       = $user.SamAccountName
        UserPrincipalName    = "$($user.SamAccountName)" + "@lab.local"
        DisplayName          = "$($user.FirstName) $($user.LastName)"
        Department           = $user.Department
        Title                = $user.Title
        Office               = $user.Office
        Path                 = $ouPath
        AccountPassword      = (ConvertTo-SecureString $DefaultPassword -AsPlainText -Force)
        Enabled              = $true
        ChangePasswordAtLogon = $ChangePasswordAtLogon
    }
    
    try {
        # Check if user already exists
        if (Get-ADUser -Filter "SamAccountName -eq '$($user.SamAccountName)'" -ErrorAction SilentlyContinue) {
            Write-Host "User $($user.SamAccountName) already exists - skipping" -ForegroundColor Yellow
            $results += [PSCustomObject]@{
                Username = $user.SamAccountName
                Status = "Skipped - Already Exists"
                Department = $user.Department
            }
            continue
        }
        
        # Create the user
        New-ADUser @userParams
        Write-Host "Created user: $($user.FirstName) $($user.LastName) ($($user.SamAccountName))" -ForegroundColor Green
        
        # Add to department group if exists
        $groupName = "$($user.Department)-Staff"
        if (Get-ADGroup -Filter "Name -eq '$groupName'" -ErrorAction SilentlyContinue) {
            Add-ADGroupMember -Identity $groupName -Members $user.SamAccountName
            Write-Host "  Added to group: $groupName" -ForegroundColor Cyan
        }
        
        $successCount++
        $results += [PSCustomObject]@{
            Username = $user.SamAccountName
            Status = "Created Successfully"
            Department = $user.Department
        }
        
    } catch {
        Write-Host "Failed to create $($user.SamAccountName): $_" -ForegroundColor Red
        $failCount++
        $results += [PSCustomObject]@{
            Username = $user.SamAccountName
            Status = "Failed: $_"
            Department = $user.Department
        }
    }
}

# Summary Report
Write-Host ""
Write-Host "========== SUMMARY ==========" -ForegroundColor Cyan
Write-Host "Total Users Processed: $($users.Count)" -ForegroundColor White
Write-Host "Successfully Created: $successCount" -ForegroundColor Green
Write-Host "Failed: $failCount" -ForegroundColor Red
Write-Host "============================" -ForegroundColor Cyan
Write-Host ""

# Export results to CSV
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$resultsPath = "C:\ADScripts\BulkUserCreation-Results-$timestamp.csv"
$results | Export-Csv -Path $resultsPath -NoTypeInformation
Write-Host "Detailed results exported to: $resultsPath" -ForegroundColor Green
