<#

.SYNOPSIS

    Installs Active Directory Domain Services role

.DESCRIPTION

    Installs AD DS and management tools

#>


Write-Host "=== Installing AD DS Role ===" -ForegroundColor Cyan


# Check if already installed

$ADDSFeature = Get-WindowsFeature -Name AD-Domain-Services


if ($ADDSFeature.Installed) {

    Write-Host "[!] AD DS is already installed" -ForegroundColor Yellow

} else {

    Write-Host "Installing Active Directory Domain Services..." -ForegroundColor Green

    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

    

    Write-Host "`n[✓] AD DS Role installed successfully!" -ForegroundColor Green

}


# Verify

Write-Host "`nInstalled Features:" -ForegroundColor Yellow

Get-WindowsFeature | Where-Object {$_.Name -like "*AD-Domain*" -and $_.Installed} | 

    Format-Table Name, DisplayName, InstallState
