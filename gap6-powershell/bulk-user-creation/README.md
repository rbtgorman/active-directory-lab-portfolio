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
![Success Summary](screenshots/01-bulk-user-creation-success.png)
![User Verification](screenshots/02-ad-users-created-list.png)
![OU Placement](screenshots/03-ad-users-ou-placement.png)
![Group Membership](screenshots/04-group-membership-verification.png)

## Real-World Application
This script addresses a common enterprise need:
- **Onboarding**: Bulk create accounts for new employee cohorts
- **Contractors**: Rapidly provision temporary accounts
- **Testing**: Generate test users for development environments
- **Mergers**: Integrate acquired company employees efficiently

## Interview Talking Points (STAR Method)

**Situation:** Manual AD user creation was time-consuming and prone to inconsistent configuration.

**Task:** Develop an automated solution to create AD users from HR-provided data while ensuring consistent security group assignments and OU placement.

**Action:** Created a PowerShell script that:
- Imports CSV data with validation
- Automatically determines correct OU based on department
- Creates users with complete attribute sets
- Assigns security groups programmatically
- Logs all actions for audit compliance

**Result:** Reduced user provisioning time by 90% (from 10+ minutes per user to batch processing in seconds), eliminated manual entry errors, and provided complete audit trail through timestamped CSV reports.

## Lessons Learned
1. **Parameter Types Matter**: Initially used `[switch]` for boolean parameter, causing type conversion error. Corrected to `[bool]` type.
2. **Error Handling**: Comprehensive try/catch blocks prevent script failure on individual user errors.
3. **Duplicate Prevention**: Checking for existing users before creation prevents script errors.
4. **Splatting Efficiency**: Using hash tables for parameters improves code readability and maintenance.

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

## Overview
This PowerShell script automates the creation of multiple Active Directory users from a CSV file, demonstrating skills in:
- PowerShell scripting and automation
- Active Directory user management
- Error handling and logging
- CSV data processing
- Automated group assignment

## Prerequisites
- Windows Server with Active Directory Domain Services
- PowerShell 5.1 or later
- Active Directory PowerShell module
- Appropriate AD permissions (Domain Admin or delegated user creation rights)

## CSV Format
The input CSV file must contain the following columns:
```csv
FirstName,LastName,SamAccountName,Department,Title,Office
```

### Example:
```csv
FirstName,LastName,SamAccountName,Department,Title,Office
James,Wilson,jwilson,IT,Systems Administrator,Building A
Maria,Garcia,mgarcia,IT,Help Desk Technician,Building A
```

## Usage

### Basic Usage
```powershell
.\New-BulkADUsers.ps1 -CsvPath "C:\ADScripts\NewUsers.csv"
```

### Advanced Usage
```powershell
# Custom password without forced change at logon
.\New-BulkADUsers.ps1 -CsvPath "C:\ADScripts\NewUsers.csv" -DefaultPassword "CustomPass123!" -ChangePasswordAtLogon:$false
```

## Features
- ✅ **Error Handling**: Gracefully handles duplicate users and invalid data
- ✅ **Automatic OU Placement**: Places users in correct department OUs
- ✅ **Group Assignment**: Automatically adds users to department security groups
- ✅ **Detailed Logging**: Exports results to timestamped CSV file
- ✅ **Progress Feedback**: Color-coded console output for success/failure
- ✅ **Duplicate Detection**: Skips existing users instead of failing

## Script Workflow
1. Import and validate CSV file
2. For each user:
   - Check if user already exists
   - Determine correct OU based on department
   - Create AD user with all attributes
   - Add to appropriate security group
3. Generate summary report
4. Export detailed results to CSV

## Output
The script generates a results CSV file with:
- Username
- Creation status
- Department
- Timestamp

Example: `BulkUserCreation-Results-20251104-153045.csv`

## Skills Demonstrated
- **PowerShell**: Advanced scripting, parameter handling, error management
- **Active Directory**: User creation, OU management, group membership
- **Automation**: Bulk operations, data processing
- **Best Practices**: Logging, validation, professional script structure

## Lab Environment
- **Domain**: lab.local
- **Server**: Windows Server 2022
- **AD Structure**: 
  - Departments OU with IT, HR, Finance sub-OUs
  - Corresponding security groups for each department

## Author
Created as part of Active Directory home lab portfolio for IT systems administration role preparation.
