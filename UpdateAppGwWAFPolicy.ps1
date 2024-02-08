function setAppGwPolicy
 {
    param(
        [Parameter(Mandatory=$true)]
        [string]$appGwWafPolicyName,
        [Parameter(Mandatory=$true)]
        [string]$resourceGroupName,
        [Parameter(Mandatory=$true)]
        [string]$ruleName,
        [Parameter(Mandatory=$true)]
        [string[]]$newIpAddressRestrictions,
        [Parameter(Mandatory=$true)]
        [bool]$appendToList,
        [Parameter(Mandatory=$false)]
        [int]$priority
    )
    $policy = Get-AzApplicationGatewayFirewallPolicy -Name $appGwWafPolicyName -ResourceGroupName $resourceGroupName
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
            $ipDenyList = @(($customRule.MatchConditions | Where-Object -FilterScript { $_.OperatorProperty -eq 'IPMatch' }).MatchValues)
            foreach ($ip in $newIpAddressRestrictions) {
                if ($ipDenyList -notcontains $ip) {
                    $ipDenyList += $ip
                }
            }
        }
    }
    #Clone the custom rule and update the match conditions
    $newMatchConditions = @(
        new-AzApplicationGatewayFirewallCondition -MatchVariable (new-AzApplicationGatewayFirewallMatchVariable -VariableName 'RemoteAddr') -Operator IPMatch -MatchValue $ipDenyList
    )
    $newRule = new-AzApplicationGatewayFirewallCustomRule -Name $ruleName -Priority $priority -RuleType $ruleType -MatchCondition $newMatchConditions -Action $action
    $policy.CustomRules.Remove($customRule)
    $policy.CustomRules.Add($newRule)
    Set-AzApplicationGatewayFirewallPolicy -InputObject $policy
}
setAppGwPolicy -appGwWafPolicyName 'wafTesting' -resourceGroupName 'ase-westus2-rg' -ruleName 'denyIP' -newIpAddressRestrictions @("208.65.91.7", "209.65.92.8") -appendToList $true
