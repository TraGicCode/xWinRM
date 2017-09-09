<#
.EXAMPLE
    This example shows how to create a WinRM Listener on a node.
#>

Configuration Example
{
    Import-DscResource -ModuleName xWinRM

    Node localhost
    {
        xWinRMListener CreateListener
        {
            Ensure = 'Present'
            Name   = 'test'
        }
    }
}
