# Active Directory Lab Portfolio

## Overview
Hands-on Windows Server and Active Directory administration lab demonstrating enterprise IT skills for System Administrator roles. This portfolio showcases practical automation, troubleshooting, and administration capabilities built in a real domain environment.

## Purpose
Building demonstrable technical competencies to qualify for System Administrator positions, with focus on:
- Windows Server & Active Directory administration
- PowerShell automation and scripting
- Help desk and systems administration workflows
- Enterprise IT best practices

## Lab Environment
- **Platform:** Windows Server 2022 Domain Controller
- **Domain:** lab.local
- **Infrastructure:** KVM virtualization on Linux host
- **Development:** VS Code on Linux → SSH to Windows Server
- **Version Control:** Git with documentation and screenshots

## Projects & Skills

### PowerShell Automation (`gap6-powershell/`)
Real-world automation scripts demonstrating help desk and systems administration capabilities:

#### 1. [Bulk AD User Creation](gap6-powershell/bulk-user-creation/)
- **Business Impact:** Reduces user provisioning time from 10+ minutes to seconds
- **Skills:** CSV parsing, AD user management, OU placement, security group assignment
- **Features:** Error handling, audit logging, batch processing

#### 2. [Password Reset Automation](gap6-powershell/password-reset-tool/)
- **Business Impact:** Reduces password reset ticket resolution time by 75%
- **Skills:** AD user account management, secure password generation, account unlock
- **Features:** Audit logging, error handling, help desk workflow automation

### Coming Soon
- AD health check reporting (inactive accounts, password expiry)
- Group membership auditing
- Endpoint management (KACE/Intune concepts)
- Network troubleshooting scenarios (DHCP/DNS)

## Technical Skills Demonstrated
- ✅ Windows Server 2022 administration
- ✅ Active Directory Users and Computers
- ✅ PowerShell scripting and automation
- ✅ Organizational Unit (OU) design and management
- ✅ Security group management
- ✅ Error handling and input validation
- ✅ Audit logging and compliance
- ✅ Git version control and documentation

## How to Navigate This Portfolio
1. **Start with PowerShell projects:** `/gap6-powershell/` directory
2. **Each project folder contains:**
   - Complete script with comments
   - Detailed README with business impact
   - Screenshots demonstrating functionality
   - Testing methodology and results

## Lab Setup Details
- **Virtualization:** KVM/QEMU on Linux
- **Domain Controller:** DC01.lab.local (Windows Server 2022)
- **Development Workflow:** 
  - Write scripts in VS Code on Linux
  - Transfer via SSH/SCP to Windows VM
  - Test in real AD environment
  - Document with screenshots
  - Commit to GitHub portfolio

## Target Role Requirements
This portfolio directly addresses System Administrator IV requirements:
- Windows Server and Active Directory administration ✅
- PowerShell automation ✅ (in progress)
- Endpoint deployment concepts (KACE/Intune) 🔄
- Network troubleshooting (DHCP/DNS/VLAN) 🔄
- Enterprise printing (Papercut/queues) 🔄

---

**Created by Robert Gorman** | Building practical enterprise IT skills through hands-on lab work

**Contact:** [LinkedIn] (https://www.linkedin.com/in/robert-gorman-638852149) 
