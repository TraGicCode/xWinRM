<#
.EXAMPLE
    This example shows how to create a WinRM Listener on a node.
#>

Configuration CreateHTTPListener
{
    Import-DscResource -ModuleName xWinRM

    Node localhost
    {
        xWinRMListener CreateListener
        {
            Ensure = 'Present'
            Address = '127.0.0.1'
            Transport = 'HTTP'
        }
    }
}
