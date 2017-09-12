$Global:DSCResourceName = 'MSFT_xWinRMListener'  #<----- Just change this

Import-Module "$($PSScriptRoot)\..\..\DSCResources\$($Global:DSCResourceName)\$($Global:DSCResourceName).psm1" -Force

InModuleScope $Global:DSCResourceName {

$mockParameters = @{
  Address   = '127.0.0.1'
  Transport = 'HTTP'
}

  Describe 'xWinRMListener' {

    It 'is syntactically correct' {
      Test-xDscSchema "$PSScriptRoot\..\..\DSCResources\MSFT_xWinRMListener\MSFT_xWinRMListener.schema.mof"
    }

    # It 'is a well formed resource' {
    #     Test-xDscResource "$PSScriptRoot\..\..\DSCResources\MSFT_xWinRMListener"
    # }

    # It 'is returned from Get-DscResource' {
    #     { Get-Dscresource -Name xWinRMListener } | Should Not Throw
    # }

    # get-dscresource -Name xWinRMListener | Select-Object -ExpandProperty Properties
    # get-dscresource -Name xWinRMListener -Syntax



    Describe 'Get-TargetResource' {

      $WinRMListener = Get-TargetResource @mockParameters

      It 'returns a hashtable' {
        $WinRMListener | Should BeOfType [Hashtable]
      }

      foreach($expectedKey in 'Address', 'Transport', 'Enabled')
      {
        It "returns the expected key of $expectedKey in the hashtable" {
          $WinRMListener.Contains($expectedKey) | Should Be $true
        }
      }

      Context 'when the listener exists' {

        Mock Get-WinRMListeners { return @(@{ Address='127.0.0.1'; Transport='http'; Enabled=$true }) }
        $WinRMListener = Get-TargetResource -Address '127.0.0.1' -Transport 'http'
        It 'should return the correct hashtable' { 
          $WinRMListener.Ensure | Should Be 'Present'
          $WinRMListener.Address | Should Be '127.0.0.1'
          $WinRMListener.Transport | Should Be 'http'
          $WinRMListener.Enabled | Should Be $true
        }
      }

      Context 'when the listener does not exist' {
        Mock Get-WinRMListeners { return @(@{ Address='10.20.1.2'; Transport='http' }) }

        $WinRMListener = Get-TargetResource -Address '127.0.0.1' -Transport 'http'

        It 'does not throw an error' {
          { Get-TargetResource -Address '127.0.0.1' -Transport 'http' } | Should Not Throw
        }

        it 'should reutrn the correct hashtable' {
          $WinRMListener.Ensure | Should Be 'Absent'
        }
      }

      Context 'when the listener exists and its disabled' {

        Mock Get-WinRMListeners { return @(@{ Address='127.0.0.1'; Transport='http'; Enabled=$false }) }
        
        $WinRMListener = Get-TargetResource -Address '127.0.0.1' -Transport 'http'
        It 'returns false for enabled' {
          $WinRMListener.Enabled | should Be $false
        }
      }
    }


    Describe 'Set-TargetResource' {

      It 'calls Get-TargetResource' {
        Mock Get-TargetResource { return @{Ensure='Present'; Address='127.0.0.1'; Transport='http'; Enabled=$true} }
        Mock Configure-WinRMListener
        Set-TargetResource -Ensure 'Present' -Address '127.0.0.1' -Transport 'http' -Enabled $true

        Assert-MockCalled Get-TargetResource -Exactly -Times 1
      }

      Context 'When calling Get-TargetResource' {
        Context 'When the resource exists and has not drifted' {
          Mock Get-TargetResource { return @{Ensure='Present'; Address='127.0.0.1'; Transport='http'; Enabled=$true } }
          It 'will not call Configure-WinRMListener' {
            Mock Configure-WinRMListener
            Set-TargetResource -Ensure 'Present' -Address '127.0.0.1' -Transport 'http' -Enabled $true
            Assert-MockCalled Configure-WinRMListener -Exactly -Times 0
          }
        }

        Context 'When the resource exists but needs to be deleted' {
          It 'calls winrm.exe delete subcommand' {
            Mock Configure-WinRMListener
            Mock Get-TargetResource { return @{Ensure='Present'; } }
            Set-TargetResource -Ensure 'Absent' -Address '127.0.0.1' -Transport 'http' -Enabled $true
            Assert-MockCalled Configure-WinRMListener -Exactly -Times 1 -ParameterFilter {
              $Operation -eq 'delete' -and
              $Address   -eq '127.0.0.1' -and
              $Transport -eq 'http' -and
              $Enabled   -eq $true
            }
          }
        }

        Context 'When the resource does not exist' {
          Mock Get-TargetResource { return @{Ensure='Absent'; } }
          It 'calls winrm.exe create subcommand' {
            Mock Configure-WinRMListener
            Set-TargetResource -Ensure 'Present' -Address '127.0.0.1' -Transport 'http' -Enabled $true
            Assert-MockCalled Configure-WinRMListener -Exactly -Times 1 -ParameterFilter {
              $Operation -eq 'create' -and
              $Address   -eq '127.0.0.1' -and
              $Transport -eq 'http' -and
              $Enabled   -eq $true
            }
          }
        }

      }

    }

    Describe "Test-TargetResource" {

      It 'returns a boolean' {
        (Test-TargetResource -Ensure 'Present' -Address '127.0.0.1' -Transport 'http' -Enabled $true) | Should BeOfType [Boolean]
      }

      Context 'When calling Get-TargetResource' {
        Mock Get-TargetResource
        Test-TargetResource -Ensure 'Present' -Address '127.0.0.1' -Transport 'http'  -Enabled $true

        It 'forwarders parameters to Get-TargetResource Correctly' {
          Assert-MockCalled Get-TargetResource -ParameterFilter {
            $Address -eq '127.0.0.1' -and
            $Transport -eq 'http'
          }
        }
        It 'is called 1 time' {
          Assert-MockCalled Get-TargetResource -Exactly -Times 1
        }
      }

      Context 'When the resource does not exist' {
        Mock Get-TargetResource { return $null }
        It 'returns false' {
          Test-TargetResource -Ensure 'Present' -Address '127.0.0.1' -Transport 'http' -Enabled $true | Should be $false
        }
      }

      Context 'When the resource is in the desired state' {
        Mock Get-TargetResource { return @{Ensure='Present';Address='127.0.0.1'; Transport='http'; Enabled=$true } }
        It 'returns true' {
          Test-TargetResource -Ensure 'Present' -Address '127.0.0.1' -Transport 'http' -Enabled $true | Should be $true
        }
      }

      Context 'When Ensure is absent' {
        Context 'When the resource is present on the system' {
          Mock Get-TargetResource { return @{ Ensure='Present';Address='127.0.0.1'; Transport='http' } }
          It 'returns false' {
            Test-TargetResource -Ensure 'Absent' -Address '127.0.0.1' -Transport 'http' -Enabled $true | Should be $false
          }
        }

        

        Context 'When the resource is absent' {

        }

      }
      Context 'When Enabled is false' {

        Context 'When the listener is Enabled' {
          Mock Get-TargetResource { return @{Ensure='Present';Address='127.0.0.1'; Transport='http'; Enabled=$true } }
          Test-TargetResource -Ensure 'Present' -Address '127.0.0.1' -Transport 'http' -Enabled $false | Should Be $false
        }

        Context 'When the listener is disabled' {
          Mock Get-TargetResource { return @{Ensure='Present';Address='127.0.0.1'; Transport='http'; Enabled=$false } }

        }
      }

    }


    Describe 'Get-WinRMListeners' {

    }
  }
}
