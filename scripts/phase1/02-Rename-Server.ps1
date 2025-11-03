<#

.SYNOPSIS

    Renames server to DC01

.DESCRIPTION

    Sets computer name and restarts

#>


param(

    [string]$NewName = "DC01"

)


$CurrentName = $env:COMPUTERNAME


if ($CurrentName -eq $NewName) {

    Write-Host "Computer is already named $NewName" -ForegroundColor Yellow

} else {

    Write-Host "Renaming computer from $CurrentName to $NewName..." -ForegroundColor Green

    Rename-Computer -NewName $NewName -Force -PassThru

    

    Write-Host "`n[!] Computer will restart in 10 seconds..." -ForegroundColor Yellow

    Write-Host "Press Ctrl+C to cancel" -ForegroundColor Yellow

    Start-Sleep -Seconds 10

    Restart-Computer -Force

}
