# Week 3 - Infrastructure As Code

The code in this repository is to learn, understand and use Infrastructure as Code.

## Prepare Your DEV Environment

Things I needed to install for these labs:

### ARM

#### Software (ARM)

| Name                     | Installation Method           | Install Command                                         |
| ------------------------ | ----------------------------- | ------------------------------------------------------- |
| Powershell-core (PS 7.1) | Chocolatey                    | `choco install powershell-core`                         |
| PS-Module Az             | PowerShell (Module Installer) | `Install-Module -Name Az -AllowClobber -Scope AllUsers` |
| VSCode                   | Chocolatey                    | `choco install vscode.install`                          |

#### Helpful VSCode Plugins (ARM)

| Name                               | Identifier                          | Short Description                                                                            |
| ---------------------------------- | ----------------------------------- | -------------------------------------------------------------------------------------------- |
| Azure Resource Manager (ARM) Tools | msazurermtools.azurerm-vscode-tools | Provides language support, resource snippets, and resource auto-completion for ARM templates |
| ARM Template Viewer                | bencoleman.armview                  | Displays a graphical preview of Azure Resource Manager (ARM) templates                       |

#### Deployment (ARM)

To deploy the ARM template and create all resources defined in it we need to run the following commands:

1. Login with Azure CLI

   ```Powershell
   az login
   ```

2. Deploy the template (This requires an already existing Resource Group)

   ```Powershell
   az deployment group create --resource-group cloudskillsbootcamp --template-file .\template.json
   ```

### Terraform

#### Software (Terraform)

| Name       | Installation Method | Install Command                               |
| ---------- | ------------------- | --------------------------------------------- |
| Terraform  | Chocolatey          | `choco install terraform`                     |
| AWS-CLI    | Download & Install  | [Download here](https://aws.amazon.com/cli/)  |
| Go         | Chocolatey          | `choco install golang`                        |
| Go-Outline | Go                  | `go get -v github.com/ramya-rao-a/go-outline` |
| Go-Delve   | Go                  | `go get -v github.com/go-delve/delve/cmd/dlv` |

#### Helpful VSCode Plugins (Terraform)

| Name                | Identifier                          | Short Description                                                                                           |
| ------------------- | ----------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| Terraform           | 4ops.terraform                      | Adds syntax support for the Terraform and Terragrunt configuration language                                 |
| HashiCorp Terraform | hashicorp.terraform                 | Adds syntax highlighting and other editing features for Terraform files using the Terraform Language Server |
| Azure Terraform     | ms-azuretools.vscode-azureterraform | Provides terraform command support, resource graph visualization and CloudShell integration inside VSCode   |
| Go                  | golang.go                           | Provides rich language support for the Go programming language                                              |

#### Notes on the Exercise

In the ec2 module we have configured an Output, which should report to us the public ip address of the ec2 instance terraform created.
But I have noticed that terraform only reports the output which is within the calling module, which in this case is in the terraform root-folder.
This is the reason I added the following output to the calling `main.tf`:

```hcl
output "publicIP" {
  value = module.webserver.publicIP
}
```

#### Testing (Terraform)

For being able to test the module terraform-aws-webserver the following step had to be done beforehand:
(Commands need to be run in the terraform-aws-webser root-folder)

1. Initialize go modules

   `go mod init terraform-aws-webserver`

2. Download module dependencies

   `go mod tidy`

3. Switch to test directory

   `cd test`

4. Run test of the terraform module

   `go test -v .\webserver_test.go`

### Bicep

#### Software (Bicep)

| Name      | Installation Method | Install Command       |
| --------- | ------------------- | --------------------- |
| Bicep CLI | Chocolatey          | `choco install bicep` |

#### Helpful VSCode Plugins (Bicep)

| Name  | Identifier                 | Short Description                                                                                   |
| ----- | -------------------------- | --------------------------------------------------------------------------------------------------- |
| Bicep | ms-azuretools.vscode-bicep | Adds syntax support for Bicep. Including: Validation, Intellisense, Code navigation and Refactoring |

#### Deployment (Bicep)

To deploy the Bicep template and create all resources defined in it we need to follow similar steps as with the [ARM template](<#deployment-(ARM)>):

1. Login with Azure CLI

   ```Powershell
   az login
   ```

2. Create ARM template based on the Biceps template

   ```Powershell
   bicep build .\main.bicep
   ```

3. Deploy the template (This requires an already existing Resource Group)

   ```Powershell
   az deployment group create --recourse-group cloudskillsbootcamp --template-file .\main.json -p name=dkocslab12345
   ```
