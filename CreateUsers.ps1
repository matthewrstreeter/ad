# Configuration
$DomainDN = (Get-ADDomain).DistinguishedName
$DefaultPassword = ConvertTo-SecureString "LabPassword123!" -AsPlainText -Force

# Department Mapping (4 users per dept)
$Users = @(
    @{Dept="Accounting"; Names=@("Alice.Banker", "Bob.Audit", "Charlie.Cash", "Diana.Debt")},
    @{Dept="Engineering"; Names=@("Edward.Code", "Fiona.Build", "George.Tech", "Hannah.Dev")},
    @{Dept="Human Resources"; Names=@("Ian.Hire", "Jane.Staff", "Kevin.Recruit", "Laura.Benefit")},
    @{Dept="Information Technology"; Names=@("Mike.Admin", "Nina.Net", "Oscar.Ops", "Paula.Patch")},
    @{Dept="Sales"; Names=@("Quincy.Deal", "Rachel.Lead", "Steve.Quota", "Tina.Trade")},
    @{Dept="Support"; Names=@("Umar.Help", "Vera.Ticket", "Will.Fix", "Xena.Desk")}
)

foreach ($Group in $Users) {
    $OUPath = "OU=$($Group.Dept),OU=Enterprise,$DomainDN"
    $GroupName = "SG-$($Group.Dept)"

    foreach ($Name in $Group.Names) {
        # Extract first/last names from the Name value (format: First.Last)
        $NameParts = $Name -split '\.'
        $GivenName = $NameParts[0]
        $Surname = $NameParts[1]
        $DisplayName = "$GivenName $Surname"
        $SamAccountName = "$($GivenName.Substring(0,1))$Surname".ToLower()
        $UserPrincipalName = "$GivenName.$Surname@$((Get-ADDomain).DNSRoot)"

        # Create the User
        $UserParams = @{
            Name = $DisplayName
            GivenName = $GivenName
            Surname = $Surname
            DisplayName = $DisplayName
            SamAccountName = $SamAccountName
            UserPrincipalName = $UserPrincipalName
            Path = $OUPath
            Department = $Group.Dept
            AccountPassword = $DefaultPassword
            Enabled = $true
            ChangePasswordAtLogon = $true
        }

        New-ADUser @UserParams

        # Add to matching Security Group
        Add-ADGroupMember -Identity $GroupName -Members $SamAccountName

        Write-Host "Created and Grouped: $DisplayName in $($Group.Dept)" -ForegroundColor Cyan
    }
}