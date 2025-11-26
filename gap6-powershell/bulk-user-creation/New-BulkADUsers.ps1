<#
    New-BulkADUsers.ps1 - Create AD users from CSV
#>

param(
    [Parameter(Mandatory)][string]$CsvPath,
    [string]$DefaultPassword = "Welcome2025!",
    [bool]$ChangePasswordAtLogon = $true
)

try {
    $users = Import-Csv $CsvPath
    Write-Host "Imported $($users.Count) users from CSV" -ForegroundColor Green
} catch {
    Write-Host "Error importing CSV: $_" -ForegroundColor Red
    exit 1
}

$created = 0
$failed = 0
$results = @()

foreach ($user in $users) {
    $ouPath = switch ($user.Department) {
        "IT"      { "OU=IT,OU=Departments,DC=lab,DC=local" }
        "HR"      { "OU=HR,OU=Departments,DC=lab,DC=local" }
        "Finance" { "OU=Finance,OU=Departments,DC=lab,DC=local" }
        default   { "OU=Departments,DC=lab,DC=local" }
    }
    
    # Skip if exists
    if (Get-ADUser -Filter "SamAccountName -eq '$($user.SamAccountName)'" -ErrorAction SilentlyContinue) {
        Write-Host "$($user.SamAccountName) already exists - skipping" -ForegroundColor Yellow
        $results += [PSCustomObject]@{ Username = $user.SamAccountName; Status = "Skipped"; Department = $user.Department }
        continue
    }
    
    try {
        New-ADUser -Name "$($user.FirstName) $($user.LastName)" `
            -GivenName $user.FirstName -Surname $user.LastName `
            -SamAccountName $user.SamAccountName `
            -UserPrincipalName "$($user.SamAccountName)@lab.local" `
            -DisplayName "$($user.FirstName) $($user.LastName)" `
            -Department $user.Department -Title $user.Title -Office $user.Office `
            -Path $ouPath `
            -AccountPassword (ConvertTo-SecureString $DefaultPassword -AsPlainText -Force) `
            -Enabled $true -ChangePasswordAtLogon $ChangePasswordAtLogon
        
        Write-Host "Created: $($user.FirstName) $($user.LastName) ($($user.SamAccountName))" -ForegroundColor Green
        
        # Add to department group if it exists
        $groupName = "$($user.Department)-Staff"
        if (Get-ADGroup -Filter "Name -eq '$groupName'" -ErrorAction SilentlyContinue) {
            Add-ADGroupMember $groupName -Members $user.SamAccountName
            Write-Host "  -> Added to $groupName" -ForegroundColor Cyan
        }
        
        $created++
        $results += [PSCustomObject]@{ Username = $user.SamAccountName; Status = "Created"; Department = $user.Department }
        
    } catch {
        Write-Host "Failed: $($user.SamAccountName) - $_" -ForegroundColor Red
        $failed++
        $results += [PSCustomObject]@{ Username = $user.SamAccountName; Status = "Failed: $_"; Department = $user.Department }
    }
}

Write-Host "`nProcessed: $($users.Count) | Created: $created | Failed: $failed" -ForegroundColor Cyan

$resultsPath = "C:\ADScripts\BulkUserCreation-$(Get-Date -f 'yyyyMMdd-HHmmss').csv"
$results | Export-Csv $resultsPath -NoTypeInformation
Write-Host "Results exported to: $resultsPath`n" -ForegroundColor Green