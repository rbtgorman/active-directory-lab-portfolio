<#
.SYNOPSIS
    Resets Active Directory user passwords and unlocks accounts.

.DESCRIPTION
    This script automates password reset requests for help desk operations.
    It validates the user exists, generates or accepts a temporary password,
    unlocks the account if locked, and logs all actions for audit compliance.

.PARAMETER Username
    The SAM account name of the user whose password needs to be reset.

.PARAMETER NewPassword
    Optional. The temporary password to set. If not provided, a secure random password is generated.

.PARAMETER UnlockAccount
    Switch. If specified, unlocks the account if it's locked out.

.PARAMETER LogPath
    Path to the log file. Default: C:\Logs\PasswordResets.log

.EXAMPLE
    .\Reset-ADUserPassword.ps1 -Username "jsmith"
    Resets password for jsmith with an auto-generated password.

.EXAMPLE
    .\Reset-ADUserPassword.ps1 -Username "jsmith" -NewPassword "TempPass123!" -UnlockAccount
    Resets password to specified value and unlocks the account.

.NOTES
    Author: Robert Gorman
    Purpose: Help desk automation for password reset tickets
    Requirements: Active Directory PowerShell module, appropriate AD permissions
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$Username,

    [Parameter(Mandatory=$false)]
    [string]$NewPassword,

    [Parameter(Mandatory=$false)]
    [switch]$UnlockAccount,

    [Parameter(Mandatory=$false)]
    [string]$LogPath = "C:\Logs\PasswordResets.log"
)

# Function to generate secure random password
function New-RandomPassword {
    param([int]$Length = 12)
    
    $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%"
    $password = -join ((1..$Length) | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
    return $password
}

# Function to write to log file
function Write-Log {
    param([string]$Message)
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $Message"
    
    # Create log directory if it doesn't exist
    $logDir = Split-Path -Path $LogPath -Parent
    if (!(Test-Path -Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }
    
    Add-Content -Path $LogPath -Value $logMessage
    Write-Verbose $logMessage
}

# Main script logic
try {
    Write-Log "Starting password reset process for user: $Username"
    
    # Import Active Directory module
    Import-Module ActiveDirectory -ErrorAction Stop
    Write-Log "Active Directory module loaded successfully"
    
    # Check if user exists
    $user = Get-ADUser -Identity $Username -Properties LockedOut -ErrorAction Stop
    Write-Log "User $Username found in Active Directory (DN: $($user.DistinguishedName))"
    
    # Generate password if not provided
    if ([string]::IsNullOrEmpty($NewPassword)) {
        $NewPassword = New-RandomPassword
        Write-Log "Generated secure random password for $Username"
    } else {
        Write-Log "Using provided password for $Username"
    }
    
    # Convert password to secure string
    $SecurePassword = ConvertTo-SecureString -String $NewPassword -AsPlainText -Force
    
    # Reset the password
    Set-ADAccountPassword -Identity $Username -NewPassword $SecurePassword -Reset -ErrorAction Stop
    Write-Log "Password reset successful for $Username"
    
    # Force password change at next logon
    Set-ADUser -Identity $Username -ChangePasswordAtLogon $true -ErrorAction Stop
    Write-Log "Set ChangePasswordAtLogon flag for $Username"
    
    # Unlock account if requested and if locked
    if ($UnlockAccount) {
        if ($user.LockedOut) {
            Unlock-ADAccount -Identity $Username -ErrorAction Stop
            Write-Log "Account unlocked for $Username"
        } else {
            Write-Log "Account was not locked for $Username - no unlock needed"
        }
    }
    
    # Display success message
    Write-Host "`n=== Password Reset Successful ===" -ForegroundColor Green
    Write-Host "User: $Username" -ForegroundColor Cyan
    Write-Host "Temporary Password: $NewPassword" -ForegroundColor Yellow
    Write-Host "Password Change Required: Yes" -ForegroundColor Cyan
    if ($UnlockAccount -and $user.LockedOut) {
        Write-Host "Account Status: Unlocked" -ForegroundColor Green
    }
    Write-Host "`nLog file: $LogPath" -ForegroundColor Gray
    Write-Host "=================================`n" -ForegroundColor Green
    
    Write-Log "Password reset process completed successfully for $Username"
    
} catch {
    $errorMessage = $_.Exception.Message
    Write-Log "ERROR: Password reset failed for $Username - $errorMessage"
    Write-Host "`nERROR: $errorMessage`n" -ForegroundColor Red
    exit 1
}
