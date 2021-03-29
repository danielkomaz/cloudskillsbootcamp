# Week 5 - Continous Interation, Continous Deployment And Continuous Delivery

## Project 1 - Build An Azure Function App

1. Open [Azure Portal](https://portal.azure.com/)
2. Go to Marketplace
3. Search for and select `Devops Starter`
4. Click on `Create`
5. Select `.Net` and click `Next`
6. Select `ASP.Net Core` and click `Next`
7. Select `Windows Web App` and click `Create`
8. Click on `Authorize`
9. Enter your GitHub informations and a globally unique name for the web app
10. Click on `Review + Create`
11. After finishing click no `Go To Resource`
12. Click on `Authorize`

With this we have created a fully functional web application including a GitHub repository and workflow automatically publishing to Azure.  
The workflow includes building, testing (using Selenium) and deploying thw web app.

**Notes:**

- Deleting the Azure resource does not delete the GitHub repository.

## Project 2 - Building without deploying in GitHub Actions

### Create custom workflow based on template

1. Fork [Cloudskills repo](https://github.com/CloudSkills/ci-pythonapp)
2. Click on `Actions`
3. Click on `New workflow`
4. Scroll down and extend `Continuous integration workflows` and select `Python application`
5. In Edit-Mode of the workflow-file do the following changes:
   - Line 4: Change the `Name` of the workflow
   - Line 8 & 10: Remove `[ main ]` and add new line with `- "**"`
   - Line 29: 2x Add subfolder `Application/` to the `requirements.txt`
   - Line 36: Add new line before pytest to create a new directory for testresults: `mkdir testresults`
   - Line 37: Extend pytest command to run specified tests: `pytest Tests/unit_tests --junitxml=./testresults/test-results.xml`
   - Line 38: In the marketplace search for `publish unit` and select `Publish Unit Test Results`, copy the first lines until `files:`, insert them and fix indents
   - Line 45: Remove all lines including 45-52, because only `files` is needed beneath `with`
   - Line 46: Add full path to test-result-xml file from line 37
6. Commit the new file
7. Check Actions for the newly triggered workflow and check results

**Notes:**

- The double asterisks are needed to trigger the workflow on branches with `/` in their name.

### Create new branch to trigger workflow

1. Clone repo to workstation
2. Change into repo-directory `cd .\ci-pythonapp`
3. Create new branch with `git checkout -b feature/updatewebpage`
4. Check that you are in the correct branch `git status`
5. Open `Application\python_webapp_flask\template\index.html`
6. On line 16 replace `You've` with your own name
7. Save the changes
8. Stage changes with `git add .`
9. Check changed files with `git status`
10. Commit changes with `git commit -m "Updated web page"`
11. Push to GitHub with `git push --set-upstream origin feature/updatewebpage`

**Notes:**

- If you only use `git push` on Step 11, you will get an error that the branch does not exist on the remote, but will give you the same command mentioned above.

## Project 3 - Deploying Terraform via GitHub Actions

1. Login do Azure-CLI `az login`
2. Note your subcription id for later use
3. Create service principal account: `az ad sp create-for-rbac -n "TestTerraformSP" --role contributor --scopes /subscriptions/95ae7b8f-565e-4b1c-8328-a165ca3e10b8`
4. Note all infos returned by the above command for later use
5. Fork [Cloudskills repo](https://github.com/CloudSkills/terraform-ghactions)
6. Go to Settings > Secrets
7. Create `New repository secret` with Name `AZURE_CREDETIALS` and Value like this:

   ```json
   {
     "clientId": "<YOUR_PRINCIPAL_APP_ID>",
     "clientSecret": "<YOUR_PRINCIPAL_PASSWORD>",
     "subscriptionId": "<YOUR_SUBSCRIPTION_ID>",
     "tenantId": "<YOUR_TENANT_ID>"
   }
   ```

8. Click on `Add secret`
9. Create `New repository secret` with Name `ARM_CLIENT_SECRET` and Value should be the password of our service principal account.
10. Click on `Add secret`
11. Go to `Actions`
12. Click on `set up a workflow yourself`
13. In Edit-Mode of the workflow-file do the following changes:

    - Line 3: Change the `Name` of the workflow
    - Line 23: add new block:

      ```yaml
      env:
        ARM_SUBSCRIPTION_ID: "<YOUR_SUBSCRIPTION_ID>"
        ARM_TENANT_ID: "<YOUR_TENANT_ID>"
        ARM_CLIENT_ID: "<YOUR_PRINCIPAL_APP_ID>"
        ARM_CLIENT_SECRET: ${{ secrets.ARM_CLIENT_SECRET }}
        AZURE_STORAGE: "<GLOBAL_UNIQUE_NAME>"
      ```

    - Line 35: In the marketplace search for `azure login` and select `Azure Login`, copy the first lines until `creds:`, insert them and fix indents
    - Line 39: Change line to `creds: ${{ secrets.AZURE_CREDENTIALS }}`
    - Line 42: Change `name` to `Build Terraform State`
    - Line 43: Change `run` command to `chmod +x ./tfstate.sh && ./tfstate.sh ${{ env.AZURE_STORAGE }}`
    - Line 45: Remove everything from this line until EOF
    - Line 45: In the marketplace search for `terraform` and select `HashiCorp - Setup Terraform`, copy the first lines until `uses:`, insert them and fix indents
    - Line 50: add the following block to perform Terraform steps:

      ```yaml
      - name: Terraform Init
        run: terraform init -backend-config="storage_account_name=${{ env.AZURE_STORAGE }}"

      - name: Terraform Plan
        run: terraform plan -out=tfplan

      - name: Terraform Apply
        run: terraform apply tfplan
      ```

14. Commit the new file
15. Check Actions for the newly triggered workflow and check results

**Notes:**

- Make sure your storage account name is shorter than 24 characters because this seems to be the max Azure supports
- In my repository I also created a manually triggered workflow for destroying the demo environment

## Project 4 - Setting up Continuous Monitoring

For this project instead of following the guide directly I will show a way to create everything with the `Azure CLI`

### Software (Azure)

| Name                     | Installation Method           | Install Command                                         |
| ------------------------ | ----------------------------- | ------------------------------------------------------- |
| Powershell-core (PS 7.1) | Chocolatey                    | `choco install powershell-core`                         |
| PS-Module Az             | PowerShell (Module Installer) | `Install-Module -Name Az -AllowClobber -Scope AllUsers` |
| AZ-CLI Extention: DevOps | Azure-CLI                     | `az extension add --name azure-devops`                  |
| VSCode                   | Chocolatey                    | `choco install vscode.install`                          |

## Set Default Organisation

If you are new to Azure DevOps (like me) you will not have an organisation configured to your Azure-DevOps-Account.  
To do this you need to go to the website of [Azure DevOps](https://dev.azure.com/) and go through the assistant.  
Write down or copy the URL to your newly created organisation which should look like this: `https://dev.azure.com/YourOrganizationName/`  
After that is done we do not need the Browser anymore, except for checking if everything we did has been set up correctly.

To set our new organisation as our default for the CLI we can use the following command:

```PowerShell
az devops configure -d organization=https://dev.azure.com/YourOrganizationName
```

### Create Project

First we should create a separate DevOps Project for this training by using the following command:

```PowerShell
az devops project create --name <YOUR_PROJECT_NAME>
```

This will create a project with all values set to default, the most important are these:

| Parameter      | Trigger              | Default Value     |
| -------------- | -------------------- | ----------------- |
| Description    | --description -d     |                   |
| Organsisation  | --organization --org | Youre default Org |
| Process        | --process -p         | Basic             |
| Source control | --source-control -s  | git               |
| Visibility     | --visibility         | Private           |

At the time of writing you have the choice between the following processes for your Project: `Basic, Agile, Scrum, and CMMI`  
More information about those resources you can find in the official documentation of [processes](https://docs.microsoft.com/en-us/azure/devops/boards/work-items/guidance/choose-process?view=azure-devops) and [projects](https://docs.microsoft.com/en-us/cli/azure/ext/azure-devops/devops/project?view=azure-cli-latest).

### Create Service Principal

Before we create the pipeline we need to set up the service endpoint which will authenticate the pipeline against our Azure subscription.  
This step will create the service principal and the service endpoint.  
Unfortunately we need to manually provide an authentication key for the princpal. We will do this in form of an environment variable.

```PowerShell
$env:AZURE_DEVOPS_EXT_AZURE_RM_SERVICE_PRINCIPAL_KEY=<YOUR_SECRET_KEY>
$endpointName = "<NAME_OF_THE_NEW_SERVICE_ENDPOINT>"
$principalName = "<NAME_OF_NEW_PRINCIPAL>"
$subscriptionName = "<YOUR_SUBSCRIPTION_NAME>"
$subscriptionId = "<YOUR_SUBSCRIPTION_ID>"
$tenantId = "<YOUR_TENANT_ID>"
$projectName = "<YOUR_PROJECT_NAME>"

az devops service-endpoint azurerm create --azure-rm-service-principal-id $principalName --azure-rm-subscription-name $subscriptionName --azure-rm-subscription-id $subscriptionId --azure-rm-tenant-id $tenantId --name $endpointName --project $projectName
```

**Notes:**

- Instead of providing the project name as a variable we could also configure it as default with the following command.

  ```Powershell
  az devops configure -d project=<ProjectName>
  ```

  This will also set the project as a default for all of the other commands too.

### Create an Azure Git Repository

We can also create a new repository which we can then use in other pipelines.  
This can be done with the following command:

```PowerShell
$repoName = "<YOUR_REPOSITORY_NAME>"
$projectName = "<YOUR_PROJECT_NAME>"

az repos create --name $repoName -p $projectName --open
```

This will open your default browser with the newly created repository.
All you need to do now is click on the button `Initialize` to finish the setup.

### Clone Git Repository

To clone your repository to your local machine just paste the following line into your powershell:

```PowerShell
git clone (az repos show -r $repoName | ConvertFrom-Json).webUrl
```

### Create a Pipeline

**Under construction. Unfortunately I was not yet able to create a working pipeline per CLI like shown in the lab tutorial.**

First we need to create the description of the job that should be run by the pipeline.
This file needs to be added to the repo to be used in the pipeline creation command.
This description will be done in a single yaml (lets call it pipeline.yaml) file with the following content:

```YAML
jobs:
- job: Job_1
  displayName: Agent job 1
  pool:
    vmImage: vs2017-win2016
  steps:
  - checkout: self
  - task: AzureCLI@2
    displayName: 'Azure CLI '
    inputs:
      connectedServiceNameARM: 0fbb9c9c-5885-4443-a90c-7ab733245e2c
      scriptType: pscore
      scriptLocation: inlineScript
      inlineScript: az group create -l westeurope -n pipelinetest

```

Next we will create a pipeline based on an Azure hosted git repo.

```PowerShell
$repoName = "<YOUR_REPOSITORY_NAME>"
$pipelineName = "<YOUR_PIPELINE_NAME>"
$projectName = "<YOUR_PROJECT_NAME>"
$repoUrl = (az repos show -r $repoName | ConvertFrom-Json).remoteUrl
$serviceConnectionId = (az devops service-endpoint list -p $projectName | ConvertFrom-Json).id

az pipelines create --name $pipelineName --description 'Pipeline for cloudskills bootcamp project' --project $projectName --repository $repoUrl --branch main --yaml-path pipeline.yaml --service-connection $serviceConnectionId
```

## Project 5 - Artifacts and packages in CICD

To interact with artifacts in the azure cli we also have a nice tool called `az pipelines runs`

At the time of writing the following subcommands are available:

```PowerShell
az pipelines runs artifact download
az pipelines runs artifact list
az pipelines runs artifact upload
```

For more Information about their usage see the [official documentation](https://docs.microsoft.com/en-us/cli/azure/ext/azure-devops/pipelines/runs/artifact?view=azure-cli-latest).

## Project 6 - Creating AWS CodeDeploy

### Software (AWS)

| Name                     | Installation Method | Install Command                 |
| ------------------------ | ------------------- | ------------------------------- |
| Powershell-core (PS 7.1) | Chocolatey          | `choco install powershell-core` |
| AWS CLI                  | AWS-CLI             | `choco install awscli`          |

**Note:** In this project we assume that you already have configured the AWS-CLI with `aws configure`

### Create a CodeCommit repository

To create a CodeCommit repository in AWS you only need to fill 2 variables and run the following command:

```PowerShell
$repoName = "<YOUR_REPOSITORY_NAME>"
$repoDescription = "<YOUR_REPOSITORY_DESCRIPTION>"

aws codecommit create-repository --repository-name $repoName --repository-description $repoDescription --tags Team=Cloudskills
```

### List CodeCommit repository details

if you wish to get a list of all repos in your account just use this command:

```PowerShell
aws codecommit list-repositories
```

Take note of the repositories name which you want to know more about and run the following code:

```PowerShell
$repoName = "<YOUR_REPOSITORY_NAME>"

aws codecommit get-repository --repository-name $repoName
```

The following oneliner will give you the http URL to clone your newly created repo:

```PowerShell
(aws codecommit get-repository --repository-name $repoName | ConvertFrom-Json).repositoryMetadata.cloneUrlHttp
```

Cowritten by Kendra Rohrhofer
