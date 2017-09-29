<#
.EXAMPLE
    This example shows how to create a WinRM Listener on a node.
#>

Configuration AddListener
{
    Import-DscResource -ModuleName xWinRM

    Node $AllNodes.NodeName
    {
        xWinRMListener TestListener
        {
            Ensure    = $Node['AddListener']['Ensure']
            Address   = $Node['AddListener']['Address']
            Transport = $Node['AddListener']['Transport']
            Enabled   = $true
        }
    }
}


Configuration RemoveListener
{
    Import-DscResource -ModuleName xWinRM

    Node $AllNodes.NodeName
    {
        xWinRMListener TestListener
        {
            Ensure    = $Node['RemoveListener']['Ensure']
            Address   = $Node['RemoveListener']['Address']
            Transport = $Node['RemoveListener']['Transport']
            Enabled   = $true
        }
    }
}