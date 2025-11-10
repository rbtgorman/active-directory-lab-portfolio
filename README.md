# Bulk AD User Creation Script

## Why I Built This

I'm building hands-on Active Directory skills to land a System Administrator role. Manual user creation is something every sysadmin does, but automating it with PowerShell shows I can work smarter and handle real production workloads.

This script directly addresses **Gap #6 (PowerShell Automation)** from the Rutgers System Admin IV job posting I'm targeting.

## What It Does

Takes a CSV file of new users and creates them all in Active Directory automatically - with proper department OUs, security group assignments, and error handling. No more clicking through AD Users & Computers for 20 minutes per user.

**Key Features:**
- Reads user data from CSV (like HR would provide)
- Automatically puts users in the right department OU
- Adds them to the right security groups
- Handles errors without crashing
- Logs everything for audit trails
- Generates a completion report

## Why This Matters for System Admin Work

**What I learned building this:**
- Writing production-ready PowerShell scripts
- Working with Active Directory cmdlets (`New-ADUser`, `Get-ADUser`, `Add-ADGroupMember`)
- Handling CSV data imports (real HR departments send these)
- Error handling so the script doesn't fail halfway through 100 users
- Creating audit logs for compliance

**Real scenarios this solves:**
- New employee onboarding (HR sends you 20 new hires on Monday morning)
- Contractor provisioning (need 50 temp accounts set up by end of day)
- Lab environments (need test users quickly)
- After acquisitions (integrating hundreds of new employees)

## How to Use It

### Basic command:
```powershell
.\New-BulkADUsers.ps1 -CsvPath "C:\ADScripts\NewUsers.csv"
```

### CSV format (what HR would send):
```csv
FirstName,LastName,SamAccountName,Department,Title,Office
James,Wilson,jwilson,IT,Systems Administrator,Building A
Maria,Garcia,mgarcia,IT,Network Engineer,Building A
```

### Custom password:
```powershell
.\New-BulkADUsers.ps1 -CsvPath "C:\ADScripts\NewUsers.csv" -DefaultPassword "SecurePass2025!"
```

## My Test Results

**Lab Environment:**
- Domain: lab.local
- Domain Controller: DC01
- Test: 5 users across IT, HR, and Finance departments

**Results:**
- ✅ All 5 users created successfully
- ✅ Automatically placed in correct OUs
- ✅ Security groups assigned properly
- ✅ No errors

![Script Success](screenshots/01-bulk-user-creation-success.png)
![Verifying Users](screenshots/02-ad-users-created-list.png)
![OU Placement](screenshots/03-ad-users-ou-placement.png)
![Group Memberships](screenshots/04-group-membership-verification.png)

## What I'd Say in an Interview

**Situation:** In enterprise environments, IT gets requests to create multiple user accounts regularly - especially during onboarding cycles. Doing this manually through ADUC is slow and error-prone.

**Task:** I needed to demonstrate I could automate repetitive AD tasks with PowerShell, which is essential for any modern System Admin role.

**Action:** I built a PowerShell script that:
- Imports CSV data (standard HR format)
- Creates AD users with full attributes
- Determines the correct OU based on department
- Assigns security group memberships automatically
- Provides detailed logging and error reporting

**Result:** This script reduces user creation time by 90% - from 10+ minutes per user manually to batch processing in seconds. It eliminates typos, ensures consistent configuration, and creates an audit trail.

## Technical Skills This Demonstrates

- PowerShell scripting (parameters, error handling, logging)
- Active Directory administration (user creation, OU management, group assignments)
- CSV data processing (working with HR/business data)
- Automation mindset (identifying repetitive tasks to script)
- Production readiness (error handling, reporting, documentation)

## What I Learned

**Mistakes I made:**
- First version used `[switch]` for a boolean parameter - PowerShell threw a type conversion error
- Learned the difference between switch parameters and boolean values
- Fixed it by changing to `[bool]$ChangePasswordAtLogon = $true`

**Why error handling matters:**
- Without try/catch blocks, one bad CSV row would crash the entire script
- In production, you need the script to skip bad entries and keep going
- Logging failures lets you follow up on what didn't work

## What's Next

Now that I've got bulk user creation down, I'm building more PowerShell automation scripts:
- Password reset tool for Help Desk scenarios
- AD health check report (finding inactive accounts)
- Group membership auditing
- Eventually: full user lifecycle management (create → modify → disable → delete)

## My Lab Setup

This runs on my home lab:
- Windows Server 2022 Domain Controller
- KVM virtualization on Linux host
- Development workflow: VS Code on Linux → SSH to Windows VM → test scripts
- All documented in GitHub for portfolio

---

**Bottom line:** This proves I can write PowerShell to automate AD tasks, which is exactly what the System Admin IV job requires. I'm not just reading about PowerShell - I'm actually building working automation in a real AD environment.

**Portfolio:** [github.com/rbtgorman/active-directory-lab-portfolio](https://github.com/rbtgorman/active-directory-lab-portfolio)# Bulk Active Directory User Creation Script

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
Portfolio: github.com/rbtgorman/active-directory-lab-portfolio
# Active Directory Lab Portfolio




## Project Overview



Building a Windows Server 2022 Active Directory lab to demonstrate enterprise administration skills.

## Screenshots

### Windows Server 2022 Installation

![DC01 Installation](screenshots/VMSS.png)


## Progress



- [x] Virtualization configured (KVM/Intel VT-x)

- [x] Windows Server 2022 installed

- [ ] Domain Controller promotion

- [ ] OU structure



## Technical Skills



- Windows Server 2022

- Active Directory

- Group Policy

- PowerShell



**Last Updated:** October 20, 2025

