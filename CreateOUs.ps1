# Define the parent OU name
$ParentOU = "Enterprise"
$DomainDN = (Get-ADDomain).DistinguishedName

# Create the Parent OU first
New-ADOrganizationalUnit -Name $ParentOU -Path $DomainDN

# List of departments to create
$DeptList = @("Accounting", "Engineering", "Human Resources", "Information Technology", "Sales", "Support")

# Loop through and create each nested OU
foreach ($Dept in $DeptList) {
    $TargetPaths = "OU=$ParentOU,$DomainDN"
    New-ADOrganizationalUnit -Name $Dept -Path $TargetPaths
    Write-Host "Created OU: $Dept" -ForegroundColor Cyan
}