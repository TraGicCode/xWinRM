
Describe 'StyleConventions' {
    Import-Module -Name PSScriptAnalyzer
    $dscResourceModules = Get-ChildItem -Path "$PSScriptRoot\..\..\DSCResources\**\*.psm1"
    $result = Invoke-ScriptAnalyzer -Path $dscResourceModules -Severity Error, Warning
    
    It 'has no error or warning severity rules broken' {

        Write-Warning -Message 'The following PSScriptAnalyzer errors need to be fixed:'
        foreach ($errorRecord in $result)
        {
            Write-Warning -Message "[$($errorRecord.Severity)] - $($errorRecord.ScriptName) (Line $($errorRecord.Line)): $($errorRecord.Message)"
        }

        $result | Should Be $null
    }

}