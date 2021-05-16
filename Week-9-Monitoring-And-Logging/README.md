# Week 9 - Monitoring and Logging

## Project 1 - Monitoring Azure IaaS

### Create VM

To create a virtual machine visit the [Azure Portal](http://portal.azure.com/) follow these steps:

1. Search for `vm` and select `Virtual machines`
2. Click on `Add` and ``Virtual machine`
3. Specify a resource group or create a new one
4. Set a name for the VM
5. Use the image `Windows Server Datacenter 2019 - Gen 1`
6. Set Username and password
7. Click on `Review + create`
8. Wait for validation to pass and click `Create`

### Connect Vm to Log Analytics Workspaces

Log Analaytics Workspace is a dumping ground for all our logfiles.
In production you would create it in its own Resource Group or even in a separate subscription.

1. Search for `log analytics` and select `Log Analytics workspaces`
2. Click on `Create`
3. Specify a resource group or create a new one
4. Set a name for the workspace
5. Select a region
6. Click on `Review + create`
7. Click on `Create`
8. After the deployment is complete click on `Go to resource`
9. On the left side open the `virtual machines` panel
10. Click on your new VM
11. Click on `Connect`

### Activate VM Insights

1. Go back to the vm resource
2. On the left side open the `Insights` panel
3. Click on `Enable`
4. Once enabled click on the notification about the new version of Azure Monitor
5. Click on `Upgrade`

This will deploy some additional agents onto the vm which you can see in the `Extensions` panel.
Also it give you additional insights into the vm like logical IOPS and many more.

### Activate Diagnostic Setting (Not for Production)

This setting is mostly meant for troubleshooting purposes and requires a storage account which will cost you money for each GB stored.

1. Open the vm resource
2. On the left side open the `Diagnostic settings` panel
3. Click on `Enable guest-level monitoring`

It will install the DependencyAgentWindows which you can seen in the panel `Extensions` of the vm.
The diagnostic settings, once enabled, will give you the ability to setup crash dumps for sepcific processes, Performance counters and also capture logs.

## Project 2 - Monitoring Serverless Platforms
