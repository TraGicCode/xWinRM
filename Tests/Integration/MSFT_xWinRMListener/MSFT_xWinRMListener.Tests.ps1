function Flatten($target)
{
  return [String]::Join("",$target)
}

describe 'WinRM HTTP Listener' {
  $normalResult = winrm get winrm/config/Listener?Address=*+Transport=http
  $result = Flatten($normalResult)
  It "has the expected properties" {
    $result | Should BeLike "*Address = `**"
    $result | Should BeLike "*Transport = http*"
  }
}