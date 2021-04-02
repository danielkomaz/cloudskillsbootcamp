# Week 6 - Serverless in Azure and AWS

## Project 1 - Build an Azure Function App

### Software (Azure Function App)

| Name                       | Installation Method           | Install Command                                                |
| -------------------------- | ----------------------------- | -------------------------------------------------------------- |
| Powershell-core (PS 7.1)   | Chocolatey                    | `choco install powershell-core`                                |
| Azure Functions Core Tools | Chocolatey                    | `choco install azure-functions-core-tools-3 --params "'/x64'"` |
| VSCode                     | Chocolatey                    | `choco install vscode.install`                                 |
| cURL                       | Chocolatey                    | `choco install curl`                                           |
| PS-Module Az               | PowerShell (Module Installer) | `Install-Module -Name Az -AllowClobber -Scope AllUsers`        |

### Helpful VSCode Plugins (Azure Function App)

| Name            | Identifier                          | Short Description                                                                                                     |
| --------------- | ----------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| Azure Functions | ms-azuretools.vscode-azurefunctions | Use the Azure Functions extension to quickly create, debug, manage, and deploy serverless apps directly from VS Code. |

### Set Variables

```PowerShell
$rgName = "<RESOURCE_GROUP_NAME>"
$saName = "<STORAGE_ACCOUNT_NAME>"
$projectName = "<YOUR_FUNCTION_PROJECT_NAME>"
$functionName = "<YOUR_FUNCTION_NAME>"
$yourName = "<YOUR_NAME>"
```

### Create Azure Function App

1. Login to azure via `az login`
2. To create the Function App copy the content Powershell script `createfunctionapp.ps1` found in folder `Project-1`
3. Paste the code into your shell
4. Run th following command and change the placeholders to your variables:

   ```PowerShell
   Create-FunctionApp -RGName $rgName -name $projectName -storageAccountName $saName
   ```

**Note:**  
I modified the code to create the Resource Group if you add the `-CreateRG` flag, optionally you can also add a location with the `-RGLocation` flag.  
Also I modified the script to create afunction of version 3 instead of 2. I did this to remove the migration error when uploading the function to Azure.

### Create Azure Function (locally)

1. Create a new Azure Function project in your working directory:

   ```PowerShell
   func init $projectName --worker-runtime powershell
   ```

2. Change working directory to Project directory:

   ```PowerShell
   cd $projectName
   ```

3. Create new function within project:

   ```PowerShell
   func new --template "Http Trigger" --name $functionName -l powershell
   ```

4. Now you can edit the functions response at line 18 in file `.\$projectName\$functionName\run.ps1`

5. Start the function within the project directory:

   ```PowerShell
   func start --powershell
   ```

6. From another shell call upon your function:

   ```PowerShell
   curl http://localhost:7071/api/HttpTrigger1?name=$yourName
   ```

7. Your code works when you receive an outpu like this:

   ```PowerShell
   StatusCode        : 200
   StatusDescription : OK
   Content           : Hello, Theo. Cloudskills Labtime.
   RawContent        : HTTP/1.1 200 OK
                       Transfer-Encoding: chunked
                       Content-Type: text/plain; charset=utf-8
                       Date: Thu, 01 Apr 2021 19:56:04 GMT
                       Server: Kestrel

                       Hello, Daniel. Cloudskills Labtime.
   Forms             : {}
   Headers           : {[Transfer-Encoding, chunked], [Content-Type, text/plain; charset=utf-8], [Date, Thu, 01 Apr 2021 19:56:04 GMT], [Server, Kestrel]}
   Images            : {}
   InputFields       : {}
   Links             : {}
   ParsedHtml        : mshtml.HTMLDocumentClass
   RawContentLength  : 33
   ```

### Upload Function to Azure

We can now upload our new tested function to azure:

```PowerShell
func azure functionapp publish $projectName
```

After the command finished, you will get an URL to test your new functions availability, and you also should be able to find it in the Azure Portal.

**Note:**  
I also included the generated code of the function (named `cloudskillsiodk`) in this repo as a reference.

## Project 2 - Build an Azure Web App

### Software (Terraform Azure Web App)

| Name      | Installation Method | Install Command                              |
| --------- | ------------------- | -------------------------------------------- |
| Terraform | Chocolatey          | `choco install terraform`                    |
| AWS-CLI   | Download & Install  | [Download here](https://aws.amazon.com/cli/) |

### Helpful VSCode Plugins (Terraform Azure Web App)

| Name                | Identifier                          | Short Description                                                                                           |
| ------------------- | ----------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| Terraform           | 4ops.terraform                      | Adds syntax support for the Terraform and Terragrunt configuration language                                 |
| HashiCorp Terraform | hashicorp.terraform                 | Adds syntax highlighting and other editing features for Terraform files using the Terraform Language Server |
| Azure Terraform     | ms-azuretools.vscode-azureterraform | Provides terraform command support, resource graph visualization and CloudShell integration inside VSCode   |

### Create Azure Web App via Terraform

**Note:** The following steps will deploy all needed resources in your default subscription in Azure, since we do not specify one in our terraform code.

1. Copy all files within the Terraform directory.
2. Move to the Terraform directory.
3. Initialize Terraform

   ```Terraform
   terraform init
   ```

4. Plan terraform changes (The parameter `out` will create a named planfile)

   ```Terraform
   terraform plan -out=plan
   ```

5. Apply terraform changes (Using the planfile omits the confirmation request)

   ```Terraform
   terraform apply plan
   ```

### Deploy JavaScript Demo App

1. Fork repo `https://github.com/AdminTurnedDevOps/javascript-sdk-demo-app` into your account
2. Open the Azure Portal and move to the newly created App Service
3. Open "Deployment Center (Classic)"
4. Select "GitHub" as source control
5. As build provider select "App Service build service"
6. Select your GitHub account, repository and branch (the forked demo app) to deploy from
7. On the summary screen just click on `Finish` and wait for the app to be deployed
8. Go back to Overview of the App Service where you can find the URL to open your newly published App
