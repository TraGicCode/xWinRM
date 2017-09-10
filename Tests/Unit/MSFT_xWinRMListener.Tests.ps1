$Global:DSCResourceName = 'MSFT_xWinRMListener'  #<----- Just change this

Import-Module "$($PSScriptRoot)\..\..\DSCResources\$($Global:DSCResourceName)\$($Global:DSCResourceName).psm1" -Force

InModuleScope $Global:DSCResourceName {

    $mockParameters = @{
        Address = '127.0.0.1'
        Transport = 'HTTP'
    }
    Describe 'xWinRMListener' {

        It 'is syntactically correct' {
            Test-xDscSchema "$PSScriptRoot\..\..\DSCResources\MSFT_xWinRMListener\MSFT_xWinRMListener.schema.mof"
        }

        It 'is a well formed resource' {
            Test-xDscResource "$PSScriptRoot\..\..\DSCResources\MSFT_xWinRMListener"
        }

        It 'is returned from Get-DscResource' {
            { Get-Dscresource -Name xWinRMListener } | Should Not Throw
        }

        Describe 'Get-TargetResource' {

            $WinRMListener = Get-TargetResource @mockParameters

            It 'returns a hashtable' {
                $WinRMListener | Should BeOfType [Hashtable]
            }

            foreach($expectedKey in 'Address', 'Transport')
            {
                It "returns the expected key of $expectedKey in the hashtable" {
                    $WinRMListener.Contains($expectedKey) | Should Be $true
                }
            }
        }
    }

    Describe 'Set-TargetResource' {
    }

    Describe 'Test-TargetResource' {

        It 'returns a boolean' {
            (Test-TargetResource @mockParameters) | Should BeOfType [Boolean]
        }
    }


    Describe 'Get-WinRMListeners' {

    }

}
