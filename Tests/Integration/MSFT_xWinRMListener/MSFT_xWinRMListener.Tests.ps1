
describe 'WinRM HTTP Listener' {
  $result = winrm get winrm/config/Listener?Address=*+Transport=http

  It "has the expected properties" {
    $result | Should BeLike "Address = `*"
    $result | Should BeLike "Transport = http"
  }
}