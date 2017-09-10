Function Test-Service
{
   [OutputType([Boolean])]
   Param(      
    [Parameter(Mandatory=$true)]
    [String] $ServiceName  
   )  
   If (Get-Service -Name $ServiceName -ErrorAction Continue)
   {
       return $True
   }
   else
   {
       return $False
   }
}

describe 'When RavenDB is installed' {
    it 'Verifies RavenDB is installed as a service' {
      Test-Service -ServiceName RavenDB | should be $True
    }
    
    it 'Verifies RavenDB is Running as a service' {
      (Get-Service -Name RavenDB).Status | should be 'Running'
    }
    
    it 'Verifies RavenDB has a service startup type as automatic' {
      (Get-WmiObject -Query "Select StartMode From Win32_Service Where Name='winmgmt'").StartMode | should be 'Auto'
    }
}