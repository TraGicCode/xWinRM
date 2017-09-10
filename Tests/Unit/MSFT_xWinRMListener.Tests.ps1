$Global:DSCResourceName = 'MSFT_xWinRMListener'  #<----- Just change this

Import-Module "$($PSScriptRoot)\..\..\DSCResources\$($Global:DSCResourceName)\$($Global:DSCResourceName).psm1" -Force

InModuleScope $Global:DSCResourceName {
    Describe 'xWinRMListener' {

        $mockParameters = @{
            Address = '127.0.0.1'
            Transport = 'HTTP'
        }

        It 'is syntactically correct' {
            Test-xDscSchema "$PSScriptRoot\..\..\DSCResources\MSFT_xWinRMListener\MSFT_xWinRMListener.schema.mof"
        }

        It 'is a well formed resource' {
            Test-xDscResource "$PSScriptRoot\..\..\DSCResources\MSFT_xWinRMListener"
        }

        Describe 'Get-TargetResource' {

            It 'returns a hashtable' {
                (Get-TargetResource @mockParameters) | Should BeOfType [Hashtable]
            }
        }
    }

    Describe 'Set-TargetResource' {
    }

    Describe 'Test-TargetResource' {
    }


    Describe 'Get-WinRMListeners' {

    }

}
