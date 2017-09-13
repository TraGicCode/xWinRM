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

    Write-Verbose -Message "Retrieving information for WinRM Listener Address=$Address+Transport=$Transport"

    $listener = Get-WinRMListeners | Where-Object -FilterScript { $PSItem.Address -eq $Address -and $PSItem.Transport -eq $Transport }
    if ($listener.Count -eq 0) {
        $EnsureResult = 'Absent'
    }
    else
    {
        $EnsureResult = 'Present'
    }


    @{
        Ensure    = $EnsureResult
        Address   = $listener.Address
        Transport = $listener.Transport
        Enabled   = $listener.Enabled
    }
}


function Set-TargetResource
{
    [CmdletBinding(SupportsShouldProcess=$true)]
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
        $Transport,
        
        [parameter(Mandatory = $true)]
        [Boolean]
        $Enabled
    )
    # Determine if i need to create or update or delete
    $currentState = Get-TargetResource -Address $Address -Transport $Transport

    if ($Ensure -eq 'Absent' -and $currentState.Ensure -eq 'Absent') {
        # Do Nothing
    }
    else 
    {
        if ($Ensure -eq 'Absent' -and $currentState.Ensure -eq 'Present')
        {
            $operation = 'Delete'
        }
        if ($Ensure -eq 'Present' -and $currentState.Ensure -eq 'Present') {
            # $operation = 'Update'
            # Now check if i need to update something that is not a key
            return 
        }
        if ($Ensure -eq 'Present' -and $currentState.Ensure -eq 'Absent')
        {
            $operation = 'Create'
        }
    
        Configure-WinRMListener -Operation $operation -Address $Address -Transport $Transport -Enabled $Enabled
    }
}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure,

        [parameter(Mandatory = $true)]
        [System.String]
        $Address,

        [parameter(Mandatory = $true)]
        [ValidateSet("HTTP","HTTPS")]
        [System.String]
        $Transport,

        [parameter(Mandatory = $true)]
        [Boolean]
        $Enabled
    )

    #Write-Verbose "Use this cmdlet to deliver information about command processing."
    #Write-Debug "Use this cmdlet to write debug information while troubleshooting."
    $inDesiredState = $false
    $currentState = Get-TargetResource -Address $Address -Transport $Transport
    if ($null -eq $currentState)
    {
        Write-Verbose -Message 'The Resource being tested could not be found on the system.'
        $inDesiredState = $false
    }
    else
    {
        if ($currentState.Ensure    -ne $Ensure  -or
            $currentState.Address   -ne $Address -or
            $currentState.Transport -ne $Transport -or
            $currentState.Enabled   -ne $Enabled)
        {
            $inDesiredState = $false
        }
        else
        {
            $inDesiredState = $true
        }
    }    
    $inDesiredState
}

<#
    .SYNOPSIS
        Gets the current WinRM listeners on a system.
    .OUTPUTS
        Returns an array of WinRM Listeners
#>
    Function Get-WinRMListeners
    {
        $allListeners = @()
    
        $listenerOutput = winrm enumerate winrm/config/Listener
        $listenerOutput | Select-String -Pattern "Listener" -SimpleMatch | ForEach-Object {
     
        $ListenerStartLineNumber = $_.LineNumber
        #"Range begins on line $startOfPermissionConfig"
        $startOfListenerConfig = [int]$ListenerStartLineNumber - 1
     
        #Get all instances of '\\'
        $EndOfListenerSection = $listenerOutput | Select-String -Pattern "Listener" -SimpleMatch | Select-Object -expand LineNumber
     
        #Get the closest '\\' to the beginning of my config
        $endOfThisConfigSec = ($EndOfListenerSection | Where-Object -FilterScript { $_-ge (($startOfListenerConfig)+1) })[1]
    
        if ($null -eq $endOfThisConfigSec) {$endOfThisConfigSec = $listenerOutput.Count + 1}
    
        #Get all lines from $startofPermissionConfig to $endOfThisConfigSection
        $ThisSetOfListenerSettings = $listenerOutput[([int]$startOfListenerConfig..([int]$endOfThisConfigSec-3))]
    
        #if specified, grab the defaultrouter
        $ThisSetOfListenerSettings = $ThisSetOfListenerSettings | Select-Object -Skip 1
        $hashtable = @{}
        ForEach ($setting in $ThisSetOfListenerSettings){
            $key = ($setting.Split("`n").Trim() -split ' = ')[0]
            $value = ($setting.Split("`n").Trim() -split ' = ')[1]
            $hashtable.Add($key, $value)
        }
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssigments", "")]
        $allListeners += $hashtable
    }
    
    return $allListeners
}


function Configure-WinRMListener {
    [CmdletBinding()]
    [OutputType([System.Int32])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("Create","Update","Delete")]
        [System.String]
        $Operation,

        [parameter(Mandatory = $true)]
        [System.String]
        $Address,

        [parameter(Mandatory = $true)]
        [ValidateSet("HTTP","HTTPS")]
        [System.String]
        $Transport,

        [parameter(Mandatory = $true)]
        [Boolean]
        $Enabled
    )
    if ($Operation -eq 'Create')
    {
        $subcommand = 'create'
    }
    elseif ($Operation -eq 'Update')
    {
        $subcommand = 'set'
    }
    else
    {
        $subcommand = 'delete'
    }
    if ($subcommand -eq 'delete') {
        Write-Verbose "winrm $subcommand winrm/config/Listener?Address=$Address+Transport=$Transport"
        winrm $subcommand winrm/config/Listener?Address=$Address+Transport=$Transport
    }
    else
    {
        # Remove keys
        $PSBoundParameters.Remove('Address') | Out-Null
        $PSBoundParameters.Remove('Transport') | Out-Null
        # Remove parameters specific to this function and not the state of the resource
        $PSBoundParameters.Remove('Operation') | Out-Null
        $hashtable = "@{"
        ForEach ($key in $PSBoundParameters.Keys) {
            $hashTable += "$key=`"$($PSBoundParameters[$key])`";"
        }
        $hashtable = $hashtable.Remove($hashtable.Length - 1)
        $hashtable += "}"
        Write-Verbose "winrm $subcommand winrm/config/Listener?Address=$Address+Transport=$Transport $hashtable"
        winrm $subcommand winrm/config/Listener?Address=$Address+Transport=$Transport $hashtable
    }
}


Export-ModuleMember -Function *-TargetResource