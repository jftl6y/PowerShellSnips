function setFdWafPolicy {
    param(
        [Parameter(Mandatory = $true)]
        [string]$appGwWafPolicyName,
        [Parameter(Mandatory = $true)]
        [string]$resourceGroupName,
        [Parameter(Mandatory = $true)]
        [string]$ruleName,
        [Parameter(Mandatory = $true)]
        [string[]]$newIpAddressRestrictions,
        [Parameter(Mandatory = $true)]
        [bool]$appendToList,
        [Parameter(Mandatory = $false)]
        [int]$priority
    )
    
    $policy = Get-AzFrontDoorWafPolicy -ResourceGroupName frontDoor-rg -Name fdTesting
    $customRule = $policy.CustomRules | Where-Object -FilterScript { $_.Name -eq $ruleName }
    if ($null -eq $customRule) {
        $ipDenyList = @( $newIpAddressRestrictions )
        $ruleType = "MatchRule"
        $action = "Block"
    }
    else {
        $priority = $customRule.Priority
        $ruleType = $customRule.RuleType
        $action = $customRule.Action
        if (!$appendToList) {
            $ipDenyList = @( $newIpAddressRestrictions )
        }
        else {
            $ipDenyList = @(($customRule.MatchConditions | Where-Object -FilterScript { $_.OperatorProperty -eq 'IPMatch' }).MatchValue)
            foreach ($ip in $newIpAddressRestrictions) {
                if ($ipDenyList -notcontains $ip) {
                    $ipDenyList += $ip
                }
            }
        }
    }
    #Clone the custom rule and update the match conditions
    $newMatchConditions = @(
        New-AzFrontDoorWafMatchConditionObject -MatchVariable 'RemoteAddr' -MatchValue $ipDenyList -OperatorProperty IPMatch
    )
    $newRule = New-AzFrontDoorWafCustomRuleObject -Name $ruleName -Priority $priority -RuleType $ruleType -MatchCondition $newMatchConditions -Action $action
    $policy.CustomRules.Remove($customRule)
    $policy.CustomRules.Add($newRule)
    Update-AzFrontDoorWafPolicy -ResourceGroupName $resourceGroupName -Name $appGwWafPolicyName -CustomRule $policy.CustomRules
}
setFdWafPolicy -appGwWafPolicyName 'fdTesting' -resourceGroupName 'frontDoor-rg' -ruleName 'ipDeny' -newIpAddressRestrictions @("207.65.91.7","208.66.92.8") -appendToList $true
