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

| Name      | Installation Method | Install Command           |
| --------- | ------------------- | ------------------------- |
| Terraform | Chocolatey          | `choco install terraform` |

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

## Project 3 - Deploy an Azure Web App via CICD in GitHub Actions

### Software (Azure Web App)

| Name                     | Installation Method           | Install Command                                         |
| ------------------------ | ----------------------------- | ------------------------------------------------------- |
| Powershell-core (PS 7.1) | Chocolatey                    | `choco install powershell-core`                         |
| PS-Module Az             | PowerShell (Module Installer) | `Install-Module -Name Az -AllowClobber -Scope AllUsers` |

### Create Azure Cedentials

1. Define variables

   ```PowerShell
   $servicePrincipalName = "<YOUR_SERVICE_PRINCIPAL_NAME>"
   $subscriptionId = "<YOUR_SUBSCRIPTION_ID>"
   $resourceGroup = "<YOUR_RESOURCE_GROUP_NAME>"
   $rgLocation = "<LOCATION_OF_YOUR_RG>"
   ```

2. (Optional) Create Resource Group

   ```PowerShell
   az group create -l $rgLocation -n $resourceGroup
   ```

3. Create Service Principal

   ```PowerShell
   az ad sp create-for-rbac --name $servicePrincipalName --role contributor --scopes /subscriptions/$subscriptionId/resourceGroups/$resourceGroup --sdk-auth
   ```

4. Copy the json output of the above command for later

### Create Github Action

1. Open [GitHub](https://github.com/)
2. Fork repo `https://github.com/AdminTurnedDevOps/javascript-sdk-demo-app` into your account
3. Open your newly forked repository
4. Edit `javascript-sdk-demo-app/.github/workflows/main.yml` and change variables `RESOURCE_GROUP_NAME`, `APP_SERVICE_PLAN` and `APP_SERVICE`
5. Commit your changes
6. Click on `Actions`
7. As we cloned the repo where the workflows already exist,
   we only need to click on `I understand my workflows, go ahead and enable them`

8. Now go to `Settings` -> `Secrets`
9. Click on `New repository secret`
10. Enter `AZURE_CREDENTIALS` into the `Name` field
11. Enter the saved json output of your Service Principal into the `Value` field and save the secret
12. Go back to `Actions`
13. Select workflow `.github/workflows/main.yml` and click on `Run workflow`
14. Open your newly deployed App Service in the Azure portal where you can find the URL to open your newly published App

## Project 4 - Create a Lambda Funcion

### Software (Lambda Funcion)

| Name                     | Installation Method | Install Command                 |
| ------------------------ | ------------------- | ------------------------------- |
| Powershell-core (PS 7.1) | Chocolatey          | `choco install powershell-core` |
| AWS-CLI                  | Chocolatey          | `choco install awscli`          |
| NVM                      | Chocolatey          | `choco install nvm`             |
| NPM                      | NVM                 | `nvm install latest`            |

**Note:** Do not forget to enable nvm by running `nvm on`, else npm will not work.

#### Helpful VSCode Plugins (Terraform)

| Name | Identifier         | Short Description                                                                                                                          |
| ---- | ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------ |
| YAML | redhat.vscode-yaml | Provides comprehensive YAML Language support to Visual Studio Code, via the yaml-language-server, with built-in Kubernetes syntax support. |

### Installing Serverless

1. Ensure that you have NPM install (package manager for JavaScript)
2. Run `npm install -g serverless`
3. Create a serverless template - `serverless create --template aws-python3`
4. Update the `serverless.yml` to include the following line under `handler:` (Line 62)

   ```YAML
       events:
         - http:
             path: /
             method: get
   ```

   This will allow you to reach the AWS Lambda function from a URL

5. Run `serverless deploy`

**Note:** Installation workflow copied from [Cloudsills Repository](https://github.com/CloudSkills/Cloud-Native-DevOps-Bootcamp/blob/main/Week%206%20-%20Serverless%20in%20Azure%20and%20AWS/Python-Lambda-Function/readme.md)  
**Note 2:** Be aware that the created function will be deployed to `us-east-1` by default. If you want to change this, you need to uncomment and edit line 30 in `serverless.yml`

## Project 5 - Security for Serverless Apps

Every cloud provider has several tools in place to ensure deployed Apps are kept secure.
This is a brief overview of said tools.

### Azure

#### Security Center

The Security Center shows the health of your apps and also some recommendations based on best practices.
For detailed information about the Security Center check the [official website](https://azure.microsoft.com/en-gb/services/security-center/#features).

#### Authentication / Authorization

Here you are able to configure several authentication mechanisms for your app if they receive unauthenticated requests.
Authentication methods range from Azure Active Directory over Google to Twitter.

For more detailed information consult the [official documentation](https://docs.microsoft.com/en-us/azure/app-service/overview-authentication-authorization).

#### Identity

There are 2 ways of handling identity in Azure:

1. System assigned
   A system assigned managed identity is restricted to one per resource and is tied to the lifecycle of this resource.  
   With this you are able to restict the service account to identify a single resource.
2. User assigned
   User assigned managed identities enable Azure resources to authenticate to cloud services (e.g. Azure Key Vault) without storing credentials in code.

For more detailed information consult the [official documentation](https://docs.microsoft.com/en-us/azure/app-service/overview-managed-identity?tabs=dotnet).

### AWS

#### Lamdba Function Permissions

Security of Lambda functions are managed in the `Permissions` tab of the function itself.  
Permission are based on execution roles.

When editing permission you can add existing roles or create a new one based on a role template.  
The function will then be executed in the context of this `execution role` instead of being run manually by your user.

#### IAM

You also have the option to create roles via IAM, where you have a more complete list of Lambda roles which you can base your new role on.

For this follow these steps:

1. Search for `IAM`
2. Click on `Create role`
3. Click on `Lambda`
4. Click on `Next: Permissions`
5. Filter the list for `Lamdba` and select your policies of choice
6. Click on `Next: Tags`
7. Click on `Next: Review`
8. Give your role a name and click `Create role`

## Project 6 - Monitoring Serverless Apps in Azure AWS

### Azure Monitor

#### Application Insight

Insights provide a customized monitoring experience for particular Azure services. They use the same metrics and logs as other features in Azure Monitor but may collect additional data and provide a unique experience in the Azure portal.

[Official Documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)

#### Logs

Azure Monitor Logs is built on top of Azure Data Explorer and all data is retrieved from a Log Analytics workspace using a log query written using Kusto Query Language (KQL). You can write your own queries or use solutions and insights that include log queries for a particular application or service.

[Official Documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/faq#logs)

#### Diagnose and Solve Problems

App Service diagnostics is an intelligent and interactive experience to help you troubleshoot your app with no configuration required. When you do run into issues withyour app, App Service diagnostics points out what’s wrong to guide you to the right information to more easily and quickly troubleshoot and resolve the issue.

[Official Documentation](https://docs.microsoft.com/en-us/azure/app-service/overview-diagnostics)

### AWS Cloudwatch

Amazon CloudWatch provides a scalable and flexible monitoring solution.

[Official Documentation](https://docs.aws.amazon.com/cloudwatch/)
