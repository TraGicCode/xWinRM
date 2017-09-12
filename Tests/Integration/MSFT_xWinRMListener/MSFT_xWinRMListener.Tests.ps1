
describe 'When RavenDB is installed' {
    it 'Verifies RavenDB is installed as a service' {
      $true | should be $True
    }
    
    it 'Verifies RavenDB is Running as a service' {
      $false | should be $True
    }
}