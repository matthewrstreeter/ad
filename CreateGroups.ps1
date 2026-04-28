# Define paths
$DomainDN = (Get-ADDomain).DistinguishedName
$GroupsOUName = "Groups"
$GroupsPath = "OU=$GroupsOUName,$DomainDN"

# Create the Groups container if it doesn't exist
if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$GroupsOUName'")) {
    New-ADOrganizationalUnit -Name $GroupsOUName -Path $DomainDN
}

# List of departments (matching your OUs)
$DeptList = @("Accounting", "Engineering", "Human Resources", "Information Technology", "Sales", "Support")

foreach ($Dept in $DeptList) {
    # Define group name (e.g., SG-Accounting)
    $GroupName = "SG-$Dept"
    
    # Create the Security Group
    New-ADGroup -Name $GroupName -GroupCategory Security -GroupScope Global -Path $GroupsPath -Description "Security group for all members of the $Dept department."
    
    Write-Host "Created Group: $GroupName" -ForegroundColor Green
}