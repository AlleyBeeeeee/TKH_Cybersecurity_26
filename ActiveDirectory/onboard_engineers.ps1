# ==================================================
# SESSION 13: THE AUTOMATED ONBOARDING
# Operator Deployment Script
# ==================================================

Write-Host "[*] Beginning Engineering Onboarding..." -ForegroundColor Cyan

# INSTRUCTION 1: Create a loop (For 1 to 5)
# We use a standard for-loop to iterate precisely 5 times.
for ($i = 1; $i -le 5; $i++) {

    # Define the username dynamically using the loop index
    $UserName = "Eng_User$i"
    
    Write-Host "[*] Provisioning account: $UserName" -ForegroundColor Yellow

    # INSTRUCTION 2: Inside the loop, use New-ADUser to create accounts.
    # We specify the Distinguished Name (DN) for the Path to place them in the Engineering OU.
    New-ADUser -Name $UserName `
               -SamAccountName $UserName `
               -UserPrincipalName "$UserName@titan.local" `
               -Path "OU=Engineering,DC=titan,DC=local" `
               -Enabled $true `
               -ChangePasswordAtLogon $true `
               -AccountPassword (Read-Host -AsSecureString "Enter temporary password for $UserName")

}

Write-Host "[+] All engineers onboarded successfully." -ForegroundColor Green