<#
Active Directory health check and security audit tool
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [int]$InactiveDays = 90,
    
    [Parameter(Mandatory=$false)]
    [int]$PasswordExpiryWarning = 7,
    
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = "C:\Reports"
)

# Import Active Directory module
Import-Module ActiveDirectory -ErrorAction Stop

# Create output directory if it doesn't exist
if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    Write-Host "Created output directory: $OutputPath" -ForegroundColor Green
}

# Initialize report timestamp
$Timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$ReportDate = Get-Date -Format "MMMM dd, yyyy HH:mm:ss"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Active Directory Health Check Report" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Calculate date thresholds
$InactiveDate = (Get-Date).AddDays(-$InactiveDays)
$PasswordExpiryDate = (Get-Date).AddDays($PasswordExpiryWarning)

Write-Host "Checking for accounts inactive since: $($InactiveDate.ToString('yyyy-MM-dd'))" -ForegroundColor Yellow
Write-Host "Checking for passwords expiring before: $($PasswordExpiryDate.ToString('yyyy-MM-dd'))" -ForegroundColor Yellow
Write-Host ""

# 1. Find Inactive User Accounts
Write-Host "[1/4] Scanning for inactive user accounts..." -ForegroundColor Cyan
try {
    $InactiveUsers = Get-ADUser -Filter {Enabled -eq $true} -Properties LastLogonDate, Department, Title |
        Where-Object {
            ($_.LastLogonDate -eq $null) -or ($_.LastLogonDate -lt $InactiveDate)
        } |
        Select-Object Name, SamAccountName, Department, Title, LastLogonDate, 
            @{Name='DaysInactive';Expression={
                if ($_.LastLogonDate) {
                    [math]::Round((New-TimeSpan -Start $_.LastLogonDate -End (Get-Date)).TotalDays)
                } else {
                    "Never logged in"
                }
            }}
    
    Write-Host "   Found $($InactiveUsers.Count) inactive accounts" -ForegroundColor $(if($InactiveUsers.Count -gt 0){"Yellow"}else{"Green"})
} catch {
    Write-Host "   ERROR: Failed to check inactive accounts - $($_.Exception.Message)" -ForegroundColor Red
    $InactiveUsers = @()
}

# 2. Find Locked Out Accounts
Write-Host "[2/4] Scanning for locked out accounts..." -ForegroundColor Cyan
try {
    $LockedAccounts = Search-ADAccount -LockedOut |
        Get-ADUser -Properties Department, Title, LockedOut, LastBadPasswordAttempt |
        Select-Object Name, SamAccountName, Department, Title, LockedOut, LastBadPasswordAttempt
    
    Write-Host "   Found $($LockedAccounts.Count) locked accounts" -ForegroundColor $(if($LockedAccounts.Count -gt 0){"Red"}else{"Green"})
} catch {
    Write-Host "   ERROR: Failed to check locked accounts - $($_.Exception.Message)" -ForegroundColor Red
    $LockedAccounts = @()
}

# 3. Find Users with Expiring Passwords
Write-Host "[3/4] Scanning for expiring passwords..." -ForegroundColor Cyan
try {
    # Get domain password policy
    $DefaultMaxPasswordAge = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.Days
    
    $ExpiringPasswords = Get-ADUser -Filter {Enabled -eq $true -and PasswordNeverExpires -eq $false} -Properties PasswordLastSet, PasswordNeverExpires, Department, Title |
        Where-Object {
            $_.PasswordLastSet -ne $null -and 
            ($_.PasswordLastSet.AddDays($DefaultMaxPasswordAge)) -lt $PasswordExpiryDate
        } |
        Select-Object Name, SamAccountName, Department, Title, PasswordLastSet,
            @{Name='ExpiryDate';Expression={$_.PasswordLastSet.AddDays($DefaultMaxPasswordAge)}},
            @{Name='DaysUntilExpiry';Expression={
                [math]::Round((New-TimeSpan -Start (Get-Date) -End ($_.PasswordLastSet.AddDays($DefaultMaxPasswordAge))).TotalDays)
            }}
    
    Write-Host "   Found $($ExpiringPasswords.Count) expiring passwords" -ForegroundColor $(if($ExpiringPasswords.Count -gt 0){"Yellow"}else{"Green"})
} catch {
    Write-Host "   ERROR: Failed to check expiring passwords - $($_.Exception.Message)" -ForegroundColor Red
    $ExpiringPasswords = @()
}

# 4. Find Disabled Accounts in Active OUs (potential cleanup needed)
Write-Host "[4/4] Scanning for disabled accounts in active OUs..." -ForegroundColor Cyan
try {
    # Get all disabled users NOT in Disabled Users OU
    $DisabledInWrongOU = Get-ADUser -Filter {Enabled -eq $false} -Properties DistinguishedName, Department, Title, WhenChanged |
        Where-Object {$_.DistinguishedName -notmatch "OU=Disabled"} |
        Select-Object Name, SamAccountName, Department, Title, 
            @{Name='CurrentOU';Expression={($_.DistinguishedName -split ',',2)[1]}},
            WhenChanged
    
    Write-Host "   Found $($DisabledInWrongOU.Count) disabled accounts needing relocation" -ForegroundColor $(if($DisabledInWrongOU.Count -gt 0){"Yellow"}else{"Green"})
} catch {
    Write-Host "   ERROR: Failed to check disabled accounts - $($_.Exception.Message)" -ForegroundColor Red
    $DisabledInWrongOU = @()
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Summary Statistics" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Inactive Accounts: $($InactiveUsers.Count)" -ForegroundColor $(if($InactiveUsers.Count -gt 0){"Yellow"}else{"Green"})
Write-Host "Locked Accounts: $($LockedAccounts.Count)" -ForegroundColor $(if($LockedAccounts.Count -gt 0){"Red"}else{"Green"})
Write-Host "Expiring Passwords: $($ExpiringPasswords.Count)" -ForegroundColor $(if($ExpiringPasswords.Count -gt 0){"Yellow"}else{"Green"})
Write-Host "Disabled (Wrong OU): $($DisabledInWrongOU.Count)" -ForegroundColor $(if($DisabledInWrongOU.Count -gt 0){"Yellow"}else{"Green"})

# Generate HTML Report
Write-Host "`nGenerating HTML report..." -ForegroundColor Cyan

$HtmlReport = @"
<!DOCTYPE html>
<html>
<head>
    <title>AD Health Check Report</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        .header { background-color: #0078d4; color: white; padding: 20px; border-radius: 5px; }
        .summary { display: flex; justify-content: space-around; margin: 20px 0; }
        .summary-box { background-color: white; padding: 20px; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); text-align: center; min-width: 150px; }
        .summary-box.warning { border-left: 4px solid #ff8c00; }
        .summary-box.critical { border-left: 4px solid #d13438; }
        .summary-box.good { border-left: 4px solid #107c10; }
        .summary-box h2 { margin: 0; font-size: 36px; }
        .summary-box p { margin: 5px 0 0 0; color: #666; }
        .section { background-color: white; margin: 20px 0; padding: 20px; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .section h2 { color: #0078d4; margin-top: 0; }
        table { width: 100%; border-collapse: collapse; }
        th { background-color: #0078d4; color: white; padding: 12px; text-align: left; }
        td { padding: 10px; border-bottom: 1px solid #ddd; }
        tr:hover { background-color: #f5f5f5; }
        .footer { text-align: center; color: #666; margin-top: 30px; padding: 20px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Active Directory Health Check Report</h1>
        <p>Generated: $ReportDate</p>
        <p>Domain: $((Get-ADDomain).DNSRoot)</p>
    </div>

    <div class="summary">
        <div class="summary-box $(if($InactiveUsers.Count -gt 0){'warning'}else{'good'})">
            <h2>$($InactiveUsers.Count)</h2>
            <p>Inactive Accounts</p>
        </div>
        <div class="summary-box $(if($LockedAccounts.Count -gt 0){'critical'}else{'good'})">
            <h2>$($LockedAccounts.Count)</h2>
            <p>Locked Accounts</p>
        </div>
        <div class="summary-box $(if($ExpiringPasswords.Count -gt 0){'warning'}else{'good'})">
            <h2>$($ExpiringPasswords.Count)</h2>
            <p>Expiring Passwords</p>
        </div>
        <div class="summary-box $(if($DisabledInWrongOU.Count -gt 0){'warning'}else{'good'})">
            <h2>$($DisabledInWrongOU.Count)</h2>
            <p>Disabled (Wrong OU)</p>
        </div>
    </div>

    <div class="section">
        <h2> Inactive User Accounts ($($InactiveUsers.Count))</h2>
        <p>Accounts with no logon activity in the last $InactiveDays days:</p>
        $(if ($InactiveUsers.Count -gt 0) {
            "<table><tr><th>Name</th><th>Username</th><th>Department</th><th>Title</th><th>Last Logon</th><th>Days Inactive</th></tr>"
            $InactiveUsers | ForEach-Object {
                "<tr><td>$($_.Name)</td><td>$($_.SamAccountName)</td><td>$($_.Department)</td><td>$($_.Title)</td><td>$($_.LastLogonDate)</td><td>$($_.DaysInactive)</td></tr>"
            }
            "</table>"
        } else {
            "<p style='color: green;'>[OK] No inactive accounts found</p>"
        })
    </div>

    <div class="section">
        <h2> Locked Out Accounts ($($LockedAccounts.Count))</h2>
        <p>User accounts currently locked due to failed login attempts:</p>
        $(if ($LockedAccounts.Count -gt 0) {
            "<table><tr><th>Name</th><th>Username</th><th>Department</th><th>Title</th><th>Last Bad Password</th></tr>"
            $LockedAccounts | ForEach-Object {
                "<tr><td>$($_.Name)</td><td>$($_.SamAccountName)</td><td>$($_.Department)</td><td>$($_.Title)</td><td>$($_.LastBadPasswordAttempt)</td></tr>"
            }
            "</table>"
        } else {
            "<p style='color: green;'>[OK] No locked accounts found</p>"
        })
    </div>

    <div class="section">
        <h2> Expiring Passwords ($($ExpiringPasswords.Count))</h2>
        <p>Passwords expiring within the next $PasswordExpiryWarning days:</p>
        $(if ($ExpiringPasswords.Count -gt 0) {
            "<table><tr><th>Name</th><th>Username</th><th>Department</th><th>Password Last Set</th><th>Expiry Date</th><th>Days Until Expiry</th></tr>"
            $ExpiringPasswords | ForEach-Object {
                "<tr><td>$($_.Name)</td><td>$($_.SamAccountName)</td><td>$($_.Department)</td><td>$($_.PasswordLastSet)</td><td>$($_.ExpiryDate)</td><td>$($_.DaysUntilExpiry)</td></tr>"
            }
            "</table>"
        } else {
            "<p style='color: green;'>[OK] No passwords expiring soon</p>"
        })
    </div>

    <div class="section">
        <h2> Disabled Accounts in Active OUs ($($DisabledInWrongOU.Count))</h2>
        <p>Disabled accounts that should be moved to Disabled Users OU:</p>
        $(if ($DisabledInWrongOU.Count -gt 0) {
            "<table><tr><th>Name</th><th>Username</th><th>Department</th><th>Current OU</th><th>Last Changed</th></tr>"
            $DisabledInWrongOU | ForEach-Object {
                "<tr><td>$($_.Name)</td><td>$($_.SamAccountName)</td><td>$($_.Department)</td><td>$($_.CurrentOU)</td><td>$($_.WhenChanged)</td></tr>"
            }
            "</table>"
        } else {
            "<p style='color: green;'>[OK] All disabled accounts in correct location</p>"
        })
    </div>

    <div class="footer">
        <p>Report generated by AD Health Check Tool | Robert Gorman</p>
        <p>Domain Controller: $env:COMPUTERNAME</p>
    </div>
</body>
</html>
"@

# Save HTML Report
$HtmlPath = Join-Path $OutputPath "ADHealthCheck_$Timestamp.html"
$HtmlReport | Out-File -FilePath $HtmlPath -Encoding UTF8

# Export detailed CSV files
if ($InactiveUsers.Count -gt 0) {
    $CsvPath = Join-Path $OutputPath "InactiveUsers_$Timestamp.csv"
    $InactiveUsers | Export-Csv -Path $CsvPath -NoTypeInformation
    Write-Host "Exported inactive users to: $CsvPath" -ForegroundColor Green
}

if ($LockedAccounts.Count -gt 0) {
    $CsvPath = Join-Path $OutputPath "LockedAccounts_$Timestamp.csv"
    $LockedAccounts | Export-Csv -Path $CsvPath -NoTypeInformation
    Write-Host "Exported locked accounts to: $CsvPath" -ForegroundColor Green
}

if ($ExpiringPasswords.Count -gt 0) {
    $CsvPath = Join-Path $OutputPath "ExpiringPasswords_$Timestamp.csv"
    $ExpiringPasswords | Export-Csv -Path $CsvPath -NoTypeInformation
    Write-Host "Exported expiring passwords to: $CsvPath" -ForegroundColor Green
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "[OK] Health check complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "HTML Report saved to: $HtmlPath" -ForegroundColor Cyan
Write-Host "`nOpen the report in a browser to view full details." -ForegroundColor Yellow