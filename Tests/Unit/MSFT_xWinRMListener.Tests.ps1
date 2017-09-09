
Describe 'xWinRMListener' {

    It 'is syntactically correct' {
        Test-xDscSchema "$PSScriptRoot\..\..\DSCResources\MSFT_xWinRMListener\MSFT_xWinRMListener.schema.mof"
    }

    It 'is a well formed resource' {
        Test-xDscResource "$PSScriptRoot\..\..\DSCResources\MSFT_xWinRMListener"
    }

    Describe 'Get-TargetResource' {
    }


    Describe 'Set-TargetResource' {
    }

    Describe 'Test-TargetResource' {
    }

}
