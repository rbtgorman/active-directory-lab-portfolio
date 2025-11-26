<#
    Reset-ADPassword.ps1
    Resets password and optionally unlocks account
#>

param(
    [Parameter(Mandatory)]
    [string]$Username,
    [string]$NewPassword,
    [switch]$UnlockAccount,
    [string]$LogPath = "C:\Logs\PasswordResets.log"
)

function New-RandomPassword {
    $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%"
    -join (1..12 | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
}

function Write-Log($Message) {
    $logDir = Split-Path $LogPath
    if (!(Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }
    
    "$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) - $Message" | Add-Content $LogPath
}

# Main
try {
    Import-Module ActiveDirectory -ErrorAction Stop
    
    $user = Get-ADUser $Username -Properties LockedOut -ErrorAction Stop
    Write-Log "Password reset initiated for $Username"
    
    if (!$NewPassword) {
        $NewPassword = New-RandomPassword
    }
    
    $SecurePass = ConvertTo-SecureString $NewPassword -AsPlainText -Force
    Set-ADAccountPassword -Identity $Username -NewPassword $SecurePass -Reset
    Set-ADUser $Username -ChangePasswordAtLogon $true
    
    if ($UnlockAccount -and $user.LockedOut) {
        Unlock-ADAccount $Username
        Write-Log "Unlocked account: $Username"
    }
    
    Write-Log "Password reset completed for $Username"
    
    Write-Host ""
    Write-Host "Password reset for $Username" -ForegroundColor Green
    Write-Host "Temp password: $NewPassword" -ForegroundColor Yellow
    Write-Host "User must change password at next logon"
    Write-Host ""

} catch {
    Write-Log "FAILED: $Username - $($_.Exception.Message)"
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}