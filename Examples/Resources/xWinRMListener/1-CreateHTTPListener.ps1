<#
.EXAMPLE
    This example shows how to create a WinRM Listener on a node.
#>

Configuration CreateHTTPListener
{
    Import-DscResource -ModuleName xWinRM

    Node $AllNodes.NodeName
    {
        xWinRMListener CreateListener
        {
            Ensure    = $Node['AddListener']['Ensure']
            Address   = $Node['AddListener']['Address']
            Transport = $Node['AddListener']['Transport']
            Enabled   = $Node['AddListener']['Enabled']
        }
    }
}


Configuration RemoveHTTPListener
{
    Import-DscResource -ModuleName xWinRM

    Node $AllNodes.NodeName
    {
        xWinRMListener RemoveListener
        {
            Ensure    = $Node['RemoveListener']['Ensure']
            Address   = $Node['RemoveListener']['Address']
            Transport = $Node['RemoveListener']['Transport']
            Enabled   = $Node['RemoveListener']['Enabled']
        }
    }
}



$ConfigurationData =
@{
    AllNodes =
    @(
        @{
            NodeName = "localhost"
            AddListener = @{
                Ensure = "Present"
                Address = "IP:128.0.0.1"
                Transport = "HTTP"
                Enabled = $true
            }
            RemoveListener = @{
                Ensure = "Absent"
                Address = "IP:128.0.0.1"
                Transport = "HTTP"
                Enabled = $true
            }
        }
    ); 
}