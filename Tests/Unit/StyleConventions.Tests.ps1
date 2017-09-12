
Describe 'StyleConventions' {
    Import-Module -Name PSScriptAnalyzer
    
            $requiredPssaRuleNames = @(
                'PSAvoidDefaultValueForMandatoryParameter',
                'PSAvoidDefaultValueSwitchParameter',
                'PSAvoidInvokingEmptyMembers',
                'PSAvoidNullOrEmptyHelpMessageAttribute',
                'PSAvoidUsingCmdletAliases',
                'PSAvoidUsingComputerNameHardcoded',
                'PSAvoidUsingDeprecatedManifestFields',
                'PSAvoidUsingEmptyCatchBlock',
                'PSAvoidUsingInvokeExpression',
                'PSAvoidUsingPositionalParameters',
                'PSAvoidShouldContinueWithoutForce',
                'PSAvoidUsingWMICmdlet',
                'PSAvoidUsingWriteHost',
                'PSDSCReturnCorrectTypesForDSCFunctions',
                'PSDSCStandardDSCFunctionsInResource',
                'PSDSCUseIdenticalMandatoryParametersForDSC',
                'PSDSCUseIdenticalParametersForDSC',
                'PSMissingModuleManifestField',
                'PSPossibleIncorrectComparisonWithNull',
                'PSProvideCommentHelp',
                'PSReservedCmdletChar',
                'PSReservedParams',
                'PSUseApprovedVerbs',
                'PSUseCmdletCorrectly',
                'PSUseOutputTypeCorrectly'
            )
    
            $flaggedPssaRuleNames = @(
                'PSAvoidGlobalVars',
                'PSAvoidUsingConvertToSecureStringWithPlainText',
                'PSAvoidUsingPlainTextForPassword',
                'PSAvoidUsingUsernameAndPasswordParams',
                'PSDSCUseVerboseMessageInDSCResource',
                'PSShouldProcess',
                'PSUseDeclaredVarsMoreThanAssigments',
                'PSUsePSCredentialType'
            )
    
            $ignorePssaRuleNames = @(
                'PSDSCDscExamplesPresent',
                'PSDSCDscTestsPresent',
                'PSUseBOMForUnicodeEncodedFile',
                'PSUseShouldProcessForStateChangingFunctions',
                'PSUseSingularNouns',
                'PSUseToExportFieldsInManifest',
                'PSUseUTF8EncodingForHelpFile'
            )
    $dscResourceModules = Get-ChildItem -Path "$PSScriptRoot\..\..\DSCResources\**\*.psm1"
    $dscResourceModules
    Write-Host $result
    $result = Invoke-ScriptAnalyzer -Path $dscResourceModules -IncludeRule ($requiredPssaRuleNames + $flaggedPssaRuleNames + $ignorePssaRuleNames) -Severity Error
    
    It 'Has no style rules broken' {

        Write-Warning -Message 'The following PSScriptAnalyzer errors need to be fixed:'
        foreach ($errorRecord in $result)
        {
            Write-Warning -Message "$($errorRecord.ScriptName) (Line $($errorRecord.Line)): $($errorRecord.Message)"
        }

        $result | Should Be $null
    }

}