<#
.EXAMPLE
    This example shows how to create a WinRM Listener on a node.
#>

Configuration CreateHTTPListener
{
    Import-DscResource -ModuleName xWinRM


    xWinRMListener CreateListener
    {
        Ensure    = 'Present'
        Address   = '*'
        Transport = 'HTTP'
        Enabled   = $true
    }
}