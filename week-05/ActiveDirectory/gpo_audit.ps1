# S14 Provisioning: GPO Audit Artifact Seeding
$TargetDir = "C:\Users\Administrator\Desktop"
$ArtifactPath = "$TargetDir\gpo_audit.txt"

Write-Host "[*] Initializing Session 14 Environment..." -ForegroundColor Cyan

$Template = @"
==================================================
SESSION 14: GROUP POLICY AUDIT REPORT
==================================================

QUESTION 1: What specific command do you run on a client machine to force it to download the latest Group Policy from the Domain Controller?
ANSWER: gpupdate /force. Without the /force flag, Windows might only update changed settings. This flag ensures everything is re-applied and refreshed immediately.

QUESTION 2: Explain the LSDOU acronym. If a Local Policy says "Enable USB" but the Domain Policy says "Disable USB", which one wins and why?
ANSWER: Local, Site, Domain, Organizational Unit. The Domain Policy wins. This is because of the hierarchy of Group Policy processing. The order of precedence is Local, Site, Domain, and then Organizational Unit. Since the Domain Policy is higher in the hierarchy than the Local Policy, it will override the Local Policy settings. Therefore, in this case, USB would be disabled on the client machine due to the Domain Policy taking precedence over the Local Policy.
In the sequence of application (Local → Site → Domain → OU), the policy applied later in the process overwrites the earlier ones. Since Domain comes after Local, it has the "final word" in this specific scenario.

QUESTION 3: Why is it best practice to apply GPOs to Organizational Units (OUs) rather than the entire Domain?
ANSWER: Applying to OUs allows for Granular Control and the Principle of Least Privilege. If you apply a "Lockdown" to the whole Domain, you lock out the Administrators, the CEO, and the IT team. By targeting the Engineering OU, you only restrict the specific group that needs it, without breaking the rest of the company.
ANSWER: Applying to OUs allows for Granular Control and the Principle of Least Privilege. By targeting specific OUs, administrators can ensure that only the relevant users and computers receive the policies, reducing the risk of unintended consequences on other parts of the domain. This approach also enhances security by limiting the scope of policy application, adhering to the principle of least privilege, which minimizes potential attack surfaces and prevents widespread disruptions in case of misconfigurations or malicious activities. 
"@

Set-Content -Path $ArtifactPath -Value $Template
Write-Host "[+] PROVISIONING COMPLETE. Artifact template seeded at: $ArtifactPath" -ForegroundColor Green
