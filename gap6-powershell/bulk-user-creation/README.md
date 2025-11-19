# Bulk Active Directory User Creation Script

## Overview
PowerShell automation script that creates multiple Active Directory users from CSV input, with automatic OU placement and security group assignment.

## Business Problem Solved
Manual AD user creation is time-consuming and error-prone. This script:
- Reduces user provisioning time from 10+ minutes per user to seconds for bulk operations
- Eliminates manual data entry errors
- Ensures consistent user account configuration
- Provides detailed audit logging for compliance

## Features
✅ CSV file import with error handling  
✅ Automatic OU placement based on department  
✅ Automatic security group assignment  
✅ Duplicate user detection and skip logic  
✅ Configurable default password  
✅ Force password change on first login  
✅ Detailed success/failure reporting  
✅ Timestamped CSV results export  
✅ Comprehensive error logging  

## Technical Skills Demonstrated
- PowerShell scripting with advanced parameters
- Active Directory cmdlet usage (New-ADUser, Get-ADUser, Add-ADGroupMember)
- CSV data processing and validation
- Error handling with try/catch blocks
- Hash table parameter splatting
- Switch statement logic for conditional processing
- Secure string password handling
- Object-oriented output with PSCustomObject

## Requirements
- Windows Server with Active Directory Domain Services
- Active Directory PowerShell module
- Domain Administrator or delegated user creation permissions
- Pre-created OUs: `OU=Departments`, `OU=IT`, `OU=HR`, `OU=Finance`
- Pre-created Security Groups: `IT-Staff`, `HR-Staff`, `Finance-Staff`

## CSV Format
```csv
FirstName,LastName,SamAccountName,Department,Title,Office
James,Wilson,jwilson,IT,Systems Administrator,Building A
Maria,Garcia,mgarcia,IT,Network Engineer,Building A
Robert,Chen,rchen,HR,HR Manager,Building B
Lisa,Anderson,landerson,HR,Recruiter,Building B
David,Brown,dbrown,Finance,Financial Analyst,Building C
```

## Usage

### Basic Usage
```powershell
.\New-BulkADUsers.ps1 -CsvPath "C:\ADScripts\NewUsers.csv"
```

### Custom Password
```powershell
.\New-BulkADUsers.ps1 -CsvPath "C:\ADScripts\NewUsers.csv" -DefaultPassword "SecurePass2025!"
```

### Without Forced Password Change
```powershell
.\New-BulkADUsers.ps1 -CsvPath "C:\ADScripts\NewUsers.csv" -ChangePasswordAtLogon $false
```

## Testing Results

### Test Execution: November 10, 2025
**Test Environment:**
- Domain: lab.local
- Domain Controller: DC01
- CSV Input: 5 users (IT, HR, Finance departments)

**Results:**
- ✅ Total Users Processed: 5
- ✅ Successfully Created: 5
- ✅ Failed: 0
- ✅ All users placed in correct OUs
- ✅ All users assigned to appropriate security groups

### Screenshot Evidence
![Success Summary](screenshots/ss-bulkusercreation-ouplacement-createdlist.png)
![User Verification](screenshots/ss-groupmembership-csvreport.png)


## Future Enhancements
- [ ] Email notification on completion
- [ ] Integration with HR system API
- [ ] Support for bulk user modifications
- [ ] Photo upload from CSV path
- [ ] Manager assignment from CSV
- [ ] Home directory creation
- [ ] Exchange mailbox provisioning

## Author
Robert Gorman  
Created: November 4, 2025  
Last Updated: November 10, 2025  
Portfolio: github.com/rbtgorman/active-directory-lab-portfolio# Bulk Active Directory User Creation

