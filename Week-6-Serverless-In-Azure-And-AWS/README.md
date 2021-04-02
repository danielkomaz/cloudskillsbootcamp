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

### Helpful VSCode Plugins

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
