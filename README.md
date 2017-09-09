A DSC Resource is a powershell module that contains the following
1.) Schema of the dsc resource in mof file format
2.) the dsc implementation code in powershell format

NOTE: in powershell v5 you can use class based resources and not worry about the schema.  Therefore a dsc module would only contain powershell code


# Parameters much match
Your Get-TargetResource, Test-TargetResource, and Set-TargetResource MUST always
have the same parameters


# Brings the state of the system to the desired state
# Idempotency is implemented here
# No Return value simply throw exception if failure else its success
Set-TargetResource


# Compare current state to expected state
# returns true if in desired state or false otherwise
function Test-TargetResource

# Must return all paramaeters along with their corresponding values for the target system
Get-TargetResource



# Automatic creation of dsc resource files structure
Install-Package xDscResourceDesigner

$Ensure = New-xDscResourceProperty -Name "Ensure" -Type "String" -Attribute Write -ValidateSet "Present","Absent" -Description "Ensure Present or Absent"

$Address = New-xDscResourceProperty -Name "Address" -Type "String" -Attribute Key -Description "Address????"

New-xDscResource -Name "MSFT_xWinRMListener" -Property $Ensure, $Address

# Update dsc resource when adding new parameter
$Transport = New-xDscResourceProperty -Name "Transport" -Type "String" -ValidateSet "HTTP", "HTTPS" -Attribute Key -Description "The Protocol for connections"

Update-xDscResource -Name "MSFT_xWinRMListener" -Property $Ensure, $Address, $Transport -ClassVersion 1.0 -Force


# Testing
## Test schema and powershell file have same parameters
Test-xDscSchema -Path .\DSCResources\MSFT_xWinRMListener\MSFT_xWinRMListener.schema.mof

## Determines if the given resource will work with the Dsc Engine
Test-xDscResource -Name .\DSCResources\MSFT_xWinRMListener





# Best Practices
Please see the BestPractices.md in DscResources repo, especially the sections Get-TargetResource should not contain unused non-mandatory parameters and Use Identical Parameters for Set-TargetResource and Test-TargetResource (unfortunately this section has not ben completed).

I will add a more complete contributions section in the README.md as I did in xSQLServer README.md Contribution section

https://github.com/PowerShell/DscResources/blob/master/BestPractices.md#use-identical-parameters-for-set-targetresource-and-test-targetresource