# function Flatten($target)
# {
#   return [String]::Join("",$target)
# }

# describe 'Add-And-Remove-Listener' {
#   $normalResult = winrm get winrm/config/Listener?Address=*+Transport=http
#   $result = Flatten($normalResult)
  
#   It "has the expected properties" {
#     $result | Should BeLike "*Address = `**"
#     $result | Should BeLike "*Transport = http*"
#   }
# }

function Flatten($target)
{
  return [String]::Join("",$target)
}

describe 'Add-And-Remove-Listener' {
  $normalResult = winrm get winrm/config/Listener?Address=IP:128.0.0.1+Transport=http 2>&1
  $result = Flatten($normalResult)
  
  It "does not exist" {
    $result | Should BeLike "*The service cannot find the resource identified by the resource URI and selectors*"
  }
}