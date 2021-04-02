function Create-FunctionApp {
    param (
        [parameter(Mandatory)]
        [string]$RGName,

        [parameter(Mandatory)]
        [string]$name,

        [parameter(Mandatory)]
        [string]$storageAccountName,

        [switch]$CreateRG,

        # Location for newly created RG if CreateRG is specified.
        # Defaults to westeurope
        [string]$RGLocation = "westeurope"
    )

    if ($CreateRG) {
        if ($RGLocation -ne "") {
            az group create -n $RGName -l $RGLocation
        }
        else {
            Write-Error "If -CreateRG is specified parameter -RGLocation must be used. (e.g.: -RGLocation westeurope"
        }
    }

    az storage account create --name $storageAccountName `
        --resource-group $RGName

    $plan = az functionapp plan create -g $RGName `
        -n $($name + 'plan') `
        --min-instances 1 `
        --max-burst 5 `
        --sku EP1
    $plan
    
    az functionapp create -g $RGName `
        -n $name `
        -p $($name + 'plan') `
        --runtime powershell `
        -s $storageAccountName `
        --functions-version 3
}