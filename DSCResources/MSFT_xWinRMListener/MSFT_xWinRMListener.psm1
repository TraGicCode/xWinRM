# winrm enumerate winrm/config/Listener

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Address,

        [parameter(Mandatory = $true)]
        [ValidateSet("HTTP","HTTPS")]
        [System.String]
        $Transport
    )

    Write-Verbose -Message 'Retrieving information for WinRM Listener BLAH.'

    #Write-Debug "Use this cmdlet to write debug information while troubleshooting."


    <#
    $returnValue = @{
    Ensure = [System.String]
    Address = [System.String]
    Transport = [System.String]
    }

    $returnValue
    #>
}


function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure,

        [parameter(Mandatory = $true)]
        [System.String]
        $Address,

        [parameter(Mandatory = $true)]
        [ValidateSet("HTTP","HTTPS")]
        [System.String]
        $Transport
    )

    #Write-Verbose "Use this cmdlet to deliver information about command processing."

    #Write-Debug "Use this cmdlet to write debug information while troubleshooting."

    #Include this line if the resource requires a system reboot.
    #$global:DSCMachineStatus = 1


}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure,

        [parameter(Mandatory = $true)]
        [System.String]
        $Address,

        [parameter(Mandatory = $true)]
        [ValidateSet("HTTP","HTTPS")]
        [System.String]
        $Transport
    )

    #Write-Verbose "Use this cmdlet to deliver information about command processing."

    #Write-Debug "Use this cmdlet to write debug information while troubleshooting."


    <#
    $result = [System.Boolean]
    
    $result
    #>
}


Export-ModuleMember -Function *-TargetResource


<#
    .SYNOPSIS
        Gets the current WinRM listeners on a system.
    .OUTPUTS
        Returns an array of WinRM Listeners
#>
Function Get-WinRMListers()
{
    $allListeners = @()

    $listenerOutput = winrm enumerate winrm/config/Listener
    $listenerOutput | Select-String -Pattern "Listener" -SimpleMatch | % {
 
    $settings = @()
    $ListenerStart = $_.Line
    $ListenerStartLineNumber = $_.LineNumber
    #"Range begins on line $startOfPermissionConfig"
    $startOfListenerConfig = [int]$ListenerStartLineNumber - 1
 
    #Get all instances of '\\'
    $EndOfListenerSection = $listenerOutput | select-string -Pattern "Listener" -SimpleMatch | select -expand LineNumber
 
    #Get the closest '\\' to the beginning of my config
    $endOfThisConfigSec = ($EndOfListenerSection | ?{ $_-ge (($startOfListenerConfig)+1) })[1]

    if ($endOfThisConfigSec -eq $null) {$endOfThisConfigSec = $listenerOutput.Count + 1}

    #Get all lines from $startofPermissionConfig to $endOfThisConfigSection
    $ThisSetOfListenerSettings = $listenerOutput[([int]$startOfListenerConfig..([int]$endOfThisConfigSec-3))]

    $ThisSetOfListenerSettings
    #if specified, grab the defaultrouter
    $ThisSetOfListenerSettings = $ThisSetOfListenerSettings | select -Skip 1
 
    ForEach ($setting in $ThisSetOfListenerSettings){
        $key = ($setting.Split("`n").Trim() -split ' = ')[0]
        $value = ($setting.Split("`n").Trim() -split ' = ')[1]
        $settings += [pscustomobject]@{$key=$value;}
}
$allListeners += [pscustomobject]@{Listener = $settings}
}

$allListeners
}

