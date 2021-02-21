# Week 2 Scripting Like A Developer

The code found in this repositore is to help you learn how to script like a Developer.

## Prepare Your DEV Environment

Things I needed to install for these labs:

### AWS & Python

AWS-CLI - [Download here](https://aws.amazon.com/cli/)
Python3 - `choco install python`
Boto3 - `pip install boto3`
Pylint - `pip install pylint`

### Azure & PowerShell

Powershell-core (PS 7.1) - `choco install powershell-core`
PS-Module Az (Had to remove AzureRM because they are not compatible) - `Install-Module -Name Az -AllowClobber -Scope AllUsers`
PSScriptAnalyzer - `Install-Module PSScriptAnalyzer -Force -Repository PSGallery`

## PowerShell Code

The PowerShell code found in `Week-2-Scripting-Like-A-Developer` is for anyone that wants to create a Resource Group in Azure.

## How To Use The Powershell Code

The `New-ResourceGroup` function is found under the `Powershell` directory and can be used as a reusable function. A user has the ability to pass in parameters at runtime to ensure they can re-use the script at any point in any environment.

## Python Code

The Python code found in `Week-2-Scripting-Like-A-Developer` is for anyone that wants to create an S3 bucket in AWS.

## How To Use The Python Code

The `s3bucket.py` script is designed to be re-used at any point for any environment. There are no hard-coded values.

## Examples

```Pwsh
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

New-ResourceGroup -rgname 'cloudskills' -location 'westeurope'
```

```Python
import sys
import boto3

try:
    def main():
        create_s3bucket(bucket_name)

except Exception as e:
    print(e)

def create_s3bucket(bucket_name):
    s3_bucket=boto3.client(
        's3',
         region_name='eu-west-2'
    )

    # Had to add location and region because of set default region
    # https://boto3.amazonaws.com/v1/documentation/api/latest/guide/s3-example-creating-buckets.html
    location = {'LocationConstraint':'eu-west-2'}

    bucket = s3_bucket.create_bucket(
        Bucket=bucket_name,
        ACL='private',
        CreateBucketConfiguration=location,
    )

    print(bucket)

bucket_name = sys.argv[1]

if __name__ == '__main__':
    main()

python s3bucket.py 'cloudskillss3bucket'
```

## Testing

Both the PowerShell and Python code have unit tests available to ensure that the desired outcomes, including values and types, are accurate.

The tests can be found in the `PowerShell` and `Python` directories.

## Contributors

1. Daniel Komaz
