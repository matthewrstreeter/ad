# Get-UsersWithExtensionAttributes.ps1

This PowerShell script searches Active Directory for users whose `extensionAttribute1` through `extensionAttribute15` properties are populated within one or more specified Organizational Units (OUs).

## Purpose

The script helps identify AD user accounts that have any of the 15 extension attributes set. It exports the results to a timestamped CSV file and can optionally display the results in an interactive GridView window.

## Requirements

- Windows PowerShell with the Active Directory module installed.
- Permissions to query Active Directory.
- Run the script from a machine that can reach the domain controllers and has the `Get-ADUser` cmdlet available.

## Default Behavior

By default, the script searches the OUs configured in the `SearchBase` parameter within the script body. You should update these default OU Distinguished Names to match your environment before use.

## Parameters

- `-SearchBase <string[]>`
  - One or more OU distinguished names where the search should be performed.
  - If omitted, the script uses the default OUs defined in the script.
- `-NoGridView`
  - When present, the script skips the interactive `Out-GridView` display and only writes the results to CSV.

## Output

- The script exports a CSV file to `.Temp\UsersWithExtAttribs-<yyyyMMdd-HHmmss>.csv`.
- Each row contains the user name, UPN, and values for `extensionAttribute1` through `extensionAttribute15`.

## Example Usage

```powershell
# Use the default OUs configured in the script and show GridView
.\Get-UsersWithExtensionAttributes.ps1

# Specify one or more OUs explicitly and suppress GridView
.\Get-UsersWithExtensionAttributes.ps1 -SearchBase "OU=Users,DC=contoso,DC=com","OU=Staff,DC=contoso,DC=com" -NoGridView
```

## Notes

- Edit the `SearchBase` values in the script before running it if you want to use environment-specific OUs by default.
- The report is generated in the current working directory inside a `Temp` folder, so be sure the folder exists or create it beforehand.
