# Week 7 - Security in Azure and AWS

## Project 1 - Securing Code

### Setup Security Scanning - GitHub

1. Fork repository `https://github.com/CloudSkills/ci-pythonapp`
2. Open forked repository
3. Select `Security` tab
4. Click on `Code scanning alerts`
5. Select `Setup this workflow` of the `CodeQL Analysis`
6. Click on `Start Commit` and commit this new file directly to the `main` branch

#### Recommended workflow

It is recommended to not use the autobuild (Line 52) but to comment it out and uncomment the run step on Line 62, which will use a makefile (you will need to provide this yourself) to bootstrap your application and build your application as defined by your definition.

### Check Code Analysis

After the workflow finished its run, the number of vulnerbilities can seen under `Security`-> `Code scanning alerts`.  
If you click on one such vulnerbility you can see a discription about the issue and also a reccomendation about how to fix it.

### Code Analysis on Branches

1. Clone forked repository onto your local machine
2. Open `.\ci-pythonapp\Application\python_webapp_flask\templates\index.html`
3. On Line 16 change `You've` to your name.
4. Change directory
   `cd .\ci-pythonapp\`
5. Create new branch
   `git checkout -b "feature/newwebpage"`
6. Check if you are on new branch
   `git status`
7. Add change to repo
   `git add Application/python_webapp_flask/templates/index.html`
8. Check if change has been added to repo
   `git status`
9. Commit changes including changes
   `git commit -m "new web page"`
10. Check if there are now no remaining changes on the branch
    `git status`
11. Trying to plain `git push` will result in the info that the new branch does not exist on the remote server.
12. Push whole branch to remote
    `git push --set-upstream origin feature/newwebpage`
13. Open the GitHub repository in browser
14. Change to the new `feature/newwebpage` branch
15. Open tab `Pull requests`
16. Click on `New pull request`
17. Change `base repository` to `main` of your forked repository
18. Change compare branch to `feature/newwebpage`
19. Compare changes and click `Create pull request`
20. Leave everything to default and click `Create pull request`
21. Wait for the workflows to finish. Those are now seen as checks and only if they are passed you will be able to merge the pull request.
22. Click on `Merge pull request`

### Check Merge and Delete Branch

1. Open the GitHub repository in browser
2. Click on `branches`
3. Clicking on the `Merged` button of our branch we can verify our test results and other information
4. If no longer needed we can now click on `Delete branch`

## Project 2 - Implementing Continuous Security

### Creating CI Security Check

1. Fork repository `https://github.com/CloudSkills/tf-sec-ops`
2. Open the forked repo
3. Click on `Actions`
4. Create a new workflow by using `Simple Workflow`
5. Rename the workflow to `ci.yml`
6. Remove Line 9-11 and replace the with the following to trigger a run for every push on all branches starting with `feature/`:

   ```YAML
       branches:
         - ' feature/*'
   ```

7. Delete everything below Line 26 after `- uses: actions/checkout@v2`
8. Search the marketplace for the checkov snippet
9. Click on `Checkov Github Action`
10. Select version `v12` as there is an issue with `v12.0.1`
11. Copy the first 4 Lines of the snipped, ending above the `with` part
12. Past the snippet at the end of the workflow file and correct the indents like so:

    ```YAML
          - name: Checkov Github Action
            # You may pin to the exact commit or the version.
            # uses: bridgecrewio/checkov-action@b320ff7a5ec447855b8bf90dd7891b4b222339cc
            uses: bridgecrewio/checkov-action@v12
    ```

13. Click `Start Commit` and then `Commit new file`

### Run CI Security Check

1. Open the forked repo
2. Click on `Actions`
3. Select the new workflow named `CI`
4. Click on `Run workflow`
5. As we have only the main branch just click on the green `Run workflow` to start it

### Create New Branch To Trigger CI

1. Clone forked repository onto your local machine
2. Change directory
   `cd .\tf-sec-ops\`
3. Create new branch
   `git checkout -b "feature/newtffeature"`
4. Check if you are on new branch
   `git status`
5. Open `main.tf` and change the following configurations:
   - Line 52: source_address_prefix from `10.0.0.0/16` to `*`
   - Line 71: vm_size from `Standard_B2s` to `Standard_B1s`
6. Add change to repo
   `git add .`
7. Check if change has been added to repo
   `git status`
8. Commit changes including changes
   `git commit -m "new changes to tf config"`
9. Check if there are now no remaining changes on the branch
   `git status`
10. Trying to plain `git push` will result in the info that the new branch does not exist on the remote server.
11. Push whole branch to remote
    `git push --set-upstream origin feature/newtffeature`
12. Open the GitHub repository in browser
13. Click on `Actions`
14. Open latest CI run where you can see that checkov reported a security-issue
15. Change Line 52 back to `source_address_prefix = "10.0.0.0/16"`
16. Repeat steps 5-10 and use commit message "security fix"
17. Open the GitHub repository in browser
18. Click on `Actions`
19. Open latest CI run where you can see that the issue has been solved and all checks passed

## Project 3 - Security Authentication in Code

### Software (Azure Vault)

| Name      | Installation Method | Install Command           |
| --------- | ------------------- | ------------------------- |
| Terraform | Chocolatey          | `choco install terraform` |

### Create Infrastructure with Terraform

For this Project we need to prepare the following Azure infrastructure:

- VM with Windows Server 2019 Datacenter and public IP
- Managed Service Identity bound to the VM
- Azure Key Vault

The directory `Project-3\Terraform` provides you with a terraform module to povide all these with a single `terraform apply`.

Use the following template for your terraform.tfvars:

```hcl
resource_group_name = "keyvault-rg"
azure_region = "westeurope"
vault_name = "keyvault"
vm = {
    name = "kvtest1",
    size = "Standard_B1s",
    admin_username = "adminuser",
    admin_password = "WeAretesting!2021",
    public_dns_name = "<GLOBAL_UNIQUE_VAULT_NAME>"
}
```

### Generate and use Secret in VM

After deploying the infrastructure follow these steps:

1. Open the [azure portal](https://portal.azure.com/)
2. Go the the key vault resource
3. Open the `Secrets` tab
4. Click on `Generate/Import`
5. Enter a `name` and some random `password`
6. Click `Create`
7. Open the `Access policies` tab
8. Click on `+ Add Access Policy`
9. Fill the form selecting the following:
   - Secret permissions: Get, List
   - Select principal: Search your vms name and click `Select`
10. Click on `Add`
11. Go Back to your resource group and click on your vm
12. In the Overview of your VM click on `Identity`
13. In tab `System assigned` the Status should already be set to `On` by our terraform deployment
14. Click on `Azure role assignments`
15. No click on `Add role assignment`
16. In the new form select the following:

    - Scope: `Key vault`
    - Subscription: your Azure Subscription
    - Resource: The secret created in steps 4-6
    - Role: Reader

17. Click `Save`
18. Now go to `Connect` on your VM
19. Check that `Public IP address` is selected and click on `Download RDP File`
20. Save the file somwehere and open it after the download finished
21. Enter `admin_username` and `admin_password` which you have specified in your `terraform.tfvars`
22. Open Powershell ISE by clicking on `Start` -> click `Windows Powershell ISE`
23. Run command: `Install-Module AZ`
24. Click `Yes` on the NuGet popup and the untrusted repository popup
25. Use the hotkey `Ctrl+R`to open the `Script Pane`
26. Run the following script:

    ```Powershell
    Add-AzAccount -identity
    $password = Get-AzKeyVaultSecret -VaultName <YOUR_VAULT_NAME> -Name <YOUR_SECRET_NAME>
    $password
    $password.SecretValue
    ```

    _Note:_ The last two commands of the script will first output all methods and properties of the secret object and second the actual password property of the secret, which is usually be used ins scripts.

## Project 4 - Creating IAM roles users and groups

### Software (AWS IAM)

| Name    | Installation Method | Install Command                              |
| ------- | ------------------- | -------------------------------------------- |
| AWS-CLI | Download & Install  | [Download here](https://aws.amazon.com/cli/) |

### Manage IAM with AWS CLI

This one is rather easy so I will try to split up the used commands and give a bit of an explanation.

This command will create a user within the AWS IAM (Identity and Access Management)

```Powershell
aws iam create-user --user-name Daniel
```

With the following command you can create a group in AWS IAM

```Powershell
aws iam create-group --group-name Daniels-Group
```

With this command you can join the user to the group

```Powershell
aws iam add-user-to-group --user-name Daniel --group-name Daniels-Group
```

The following commands will help you to find your way around permissions in AWS:

```Powershell
# list infos about all user's
aws iam list-users

# get current user's infos
aws iam get-user

# get specific user's infos
aws iam get-user --user-name Daniel

# delete one user
aws iam delete-user --user-name Daniel

# list current user's access keys
aws iam list-access-keys

# list infos about all policies
aws iam list-roles

# list the names of all roles
aws iam list-roles --query 'Roles[*].RoleName'

# list infos about all policies
aws iam list-policies

# list names of all policies (unsorted)
aws iam list-policies --query 'Policies[*].PolicyName'

# get infos about a specific policy
aws iam get-policy --policy-arn <value>

# add a policy to a group
aws iam attach-group-policy --group-name Daniels-Group --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
```

## Project 5 - Creating RBAC rules and Azure Policies

### Software (Azure RBAC)

| Name                     | Installation Method           | Install Command                                         |
| ------------------------ | ----------------------------- | ------------------------------------------------------- |
| Powershell-core (PS 7.1) | Chocolatey                    | `choco install powershell-core`                         |
| PS-Module Az             | PowerShell (Module Installer) | `Install-Module -Name Az -AllowClobber -Scope AllUsers` |

### Azure RBAC

Create an RBAC which is scoped to your Subscription

```Powershell
$subscription = "subscriptions/<YOUR_SUBSCRIPTION_ID>"
az ad sp create-for-rbac -n "AzureDevOps" --role Contributor --scope $subscription
```

The following command will create the same RBAC as above but with more option to be used in programming

```Powershell
$subscription = "/subscriptions/<YOUR_SUBSCRIPTION_ID>"
az ad sp create-for-rbac -n "AzureDevOps" --role Contributor --scope $subscription --sdk-auth
```

Create a group in Azure Active Directory

```Powershell
$GroupName = "TestGroup"
az ad group create --display-name $GroupName --mail-nickname $GroupName
```

## Azure Policy

Get a list of description names and names of all policies available in Azure

```Powershell
az policy definition list --query '[].{DN:displayName, name:name}'
```

Create a resource policy assignment with a system assigned identity

```Powershell
$resourceGroup = "/subscriptions/<YOUR_SUBSCRIPTION_ID>/resourceGroups/<YOUR_RG_NAME>"
$policyName = "<DISPLAYNAME_OF_THE_ASSIGNED_POLICY>"
$assignmentName = "<NAME_OF_YOUR_ASSIGNMENT>"
az policy assignment create --name $assignmentName --displayName $assignmentName --policy $policyName --scope $resourceGroup
```
