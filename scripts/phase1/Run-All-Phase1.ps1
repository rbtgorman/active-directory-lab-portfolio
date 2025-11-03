<#

.SYNOPSIS

    Master script to run all Phase 1 scripts in order

.DESCRIPTION

    Executes all Phase 1 scripts sequentially after DC promotion

.NOTES

    Author: Robert Gorman

    Date: October 22, 2025

    

    PREREQUISITES:

    - Scripts 01-04 must be run manually (they require reboots)

    - DC must be promoted and online

    - Run this script as LAB\Administrator

#>


Write-Host "========================================" -ForegroundColor Cyan

Write-Host "  PHASE 1: ACTIVE DIRECTORY LAB SETUP" -ForegroundColor Cyan

Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`nThis script assumes DC promotion is complete" -ForegroundColor Yellow

Write-Host "Press Ctrl+C to cancel, or" -ForegroundColor Yellow

Write-Host "Press any key to continue..." -ForegroundColor Yellow

$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


$Scripts = @(

    "05-Verify-DC.ps1",

    "06-Create-OUStructure.ps1",

    "07-Create-SecurityGroups.ps1",

    "08-Create-TestUsers.ps1",

    "09-Add-UsersToGroups.ps1",

    "10-Verify-Complete.ps1"

)


$CurrentDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$SuccessCount = 0

$FailCount = 0


Write-Host "`nStarting Phase 1 execution...`n" -ForegroundColor Green


foreach ($Script in $Scripts) {

    $ScriptPath = Join-Path $CurrentDir $Script

    

    Write-Host "========================================" -ForegroundColor Gray

    Write-Host "Executing: $Script" -ForegroundColor Cyan

    Write-Host "========================================" -ForegroundColor Gray

    

    if (Test-Path $ScriptPath) {

        try {

            & $ScriptPath

            Write-Host "`n[✓] $Script completed successfully`n" -ForegroundColor Green

            $SuccessCount++

        }

        catch {

            Write-Host "`n[X] Error in $Script : $_`n" -ForegroundColor Red

            $FailCount++

            

            $Continue = Read-Host "Continue with next script? (Y/N)"

            if ($Continue -ne "Y") { 

                Write-Host "`nExecution halted by user" -ForegroundColor Yellow

                break 

            }

        }

    } else {

        Write-Host "[X] Script not found: $ScriptPath`n" -ForegroundColor Red

        $FailCount++

    }

    

    Start-Sleep -Seconds 2

}


# Final Summary

Write-Host "`n========================================" -ForegroundColor Cyan

Write-Host "  PHASE 1 EXECUTION SUMMARY" -ForegroundColor Cyan

Write-Host "========================================" -ForegroundColor Cyan

Write-Host "Scripts Executed: $($Scripts.Count)" -ForegroundColor White

Write-Host "Successful: $SuccessCount" -ForegroundColor Green

Write-Host "Failed: $FailCount" -ForegroundColor $(if($FailCount -eq 0){"Green"}else{"Red"})


if ($FailCount -eq 0) {

    Write-Host "`n[✓] ALL SCRIPTS COMPLETED SUCCESSFULLY!" -ForegroundColor Green

    Write-Host "`nYour Active Directory lab is ready for Phase 2!" -ForegroundColor Cyan

} else {

    Write-Host "`n[!] Some scripts encountered errors" -ForegroundColor Yellow

    Write-Host "Review the output above for details" -ForegroundColor Yellow

}


Write-Host "`nNext Steps:" -ForegroundColor Yellow

Write-Host "  1. Review output above for any errors" -ForegroundColor White

Write-Host "  2. Take screenshots for documentation:" -ForegroundColor White

Write-Host "     - ADUC showing OU structure" -ForegroundColor Gray

Write-Host "     - Users in each OU" -ForegroundColor Gray

Write-Host "     - Security groups" -ForegroundColor Gray

Write-Host "     - Group memberships" -ForegroundColor Gray

Write-Host "  3. Update your README.md" -ForegroundColor White

Write-Host "  4. Commit scripts to GitHub" -ForegroundColor White

Write-Host "  5. Begin Phase 2: Group Policy Objects" -ForegroundColor White


Write-Host "`nPress any key to exit..." -ForegroundColor Gray

$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
