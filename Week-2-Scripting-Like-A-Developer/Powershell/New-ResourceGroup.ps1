function New-ResourceGroup {
    [cmdletbinding(SupportsShouldProcess)]

    param (
        [Parameter(Mandatory)]
        [String]$rgName,

        [Parameter(Mandatory)]
        [String]$location
    )

    $params = @{
        'Name'     = $rgName
        'Location' = $location
    }

    if ($PSCmdlet.ShouldProcess("location")) {

        New-AzResourceGroup @params
    }
}