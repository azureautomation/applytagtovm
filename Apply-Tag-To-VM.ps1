workflow Apply-Tag-To-VM
{
    Param
    (   
        [Parameter(Mandatory=$true)]
        [String]
        $TagName,
        [Parameter(Mandatory=$true)]
        [String]
        $TagValue
    )
	
	#The name of the Automation Credential Asset this runbook will use to authenticate to Azure.
    $CredentialAssetName = "DefaultAzureCredentials";
	
	#Get the credential with the above name from the Automation Asset store
    $Cred = Get-AutomationPSCredential -Name $CredentialAssetName
    if(!$Cred) {
        Throw "Could not find an Automation Credential Asset named '${CredentialAssetName}'. Make sure you have created one in this Automation Account."
    }

    #Connect to your Azure Account   	
	Add-AzureRmAccount -Credential $Cred
	
    Get-AzureRmResourceGroup | ForEach-Object { Get-AzureRmVM -ResourceGroupName $_.ResourceGroupName | ForEach-Object { $tags = (Get-AzureRmResource -ResourceGroupName $_.ResourceGroupName -Name $_.Name).Tags; $tags+= @{$TagName=$TagValue}; Set-AzureRmResource -ResourceGroupName $_.ResourceGroupName -Name $_.Name -ResourceType "Microsoft.Compute/VirtualMachines" -Tag $tags -Force }
}
}