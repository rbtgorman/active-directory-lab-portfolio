# Active Directory Lab Portfolio

Hands-on Windows Server and Active Directory administration portfolio demonstrating enterprise IT skills through practical lab projects. Built on Windows Server 2022 with KVM virtualization.

## About This Portfolio

This repository documents my journey building System Administrator skills through a home lab environment. Each project addresses real-world enterprise scenarios with production-ready solutions, comprehensive documentation, and quantifiable business impact.

**Target Role:** System Administrator (Windows/AD focus)

**Lab Environment:**
- Windows Server 2022 Domain Controller (DC01.lab.local)
- KVM/QEMU virtualization on Linux host
- NAT network (192.168.122.0/24)
- Organizational Units: IT, HR, Finance departments

---

## Completed Projects

### PowerShell Automation (gap6-powershell/)

| Project | Description | Business Impact |
|---------|-------------|-----------------|
| [AD Health Check Report](gap6-powershell/ad-healthcheck-report/) | Automated AD auditing with HTML dashboard and CSV exports | Reduced manual audit time by 85% |
| [Bulk User Creation](gap6-powershell/bulk-user-creation/) | CSV-driven user provisioning with OU placement and group membership | Cut onboarding time from 15 min to 30 sec per user |
| [Password Reset Tool](gap6-powershell/password-reset-tool/) | Secure password reset with logging and email notification framework | Reduced help desk ticket resolution by 60% |

---

## Skills Demonstrated

### Windows Server Administration
- Active Directory Domain Services (AD DS)
- Organizational Unit (OU) design and management
- Security group creation and membership management
- User account lifecycle management

### PowerShell Automation
- Production-ready scripts with error handling
- ActiveDirectory module for LDAP operations
- HTML report generation
- CSV import/export for data processing
- Parameterized scripts for flexible deployment

### Enterprise Practices
- Comprehensive logging and audit trails
- Documentation with business impact metrics
- Version control with Git/GitHub
- Professional reporting for management review

---

## In Progress

| Skill Gap | Focus Area | Status |
|-----------|------------|--------|
| Endpoint Management | KACE, Intune, Autopilot | Planned |
| Imaging & Deployment | Windows imaging, deployment automation | Planned |
| Enterprise Printing | Papercut, print queue management | Planned |
| Network Troubleshooting | DHCP, DNS, VLAN configuration | Planned |

---

## Repository Structure

```
active-directory-lab-portfolio/
├── README.md                    # This file
├── gap6-powershell/             # PowerShell automation projects
│   ├── ad-healthcheck-report/   # ✅ Complete
│   ├── bulk-user-creation/      # ✅ Complete
│   └── password-reset-tool/     # ✅ Complete
├── gap2-endpoint-mgmt/          # Endpoint deployment (planned)
├── gap3-imaging-autopilot/      # Imaging solutions (planned)
├── gap4-printing/               # Enterprise printing (planned)
├── gap5-networking/             # Network troubleshooting (planned)
├── gap7-servicenow-cases/       # ServiceNow scenarios (planned)
├── case-studies/                # Real-world scenario documentation
├── documentation/               # Guides and references
├── metrics/                     # Project metrics and KPIs
└── screenshots/                 # Additional screenshots
```

---

## Lab Setup

**Domain Controller:** Windows Server 2022 Standard (Evaluation)
- Hostname: DC01
- Domain: lab.local
- IP: 192.168.122.10

**Virtualization:** KVM/QEMU on Linux host
- 4GB RAM allocated to DC
- NAT networking for internet access

**Development Workflow:**
1. Script development in VS Code on Linux
2. File transfer via HTTP server or SCP
3. Testing on Windows Server VM
4. Documentation with screenshots
5. Git commits to GitHub

---

## Contact

**Robert Gorman**
- GitHub: [rbtgorman](https://github.com/rbtgorman)
- Education: MS Business Analytics (FinTech), Rutgers University

---

## License

This project is for educational and portfolio demonstration purposes.
