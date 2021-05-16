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

## Project 2 - Monitoring Serverless Platforms (AWS)

### Create Lambda Function

To create a Lambda function follow these steps:

1. Search for `Lambda` in the searchbar
2. Click on `Create function`
3. Select `Browse serverless app repository`
4. Search for and click on `alexa-skills-kit-color-expert-python`
5. Provide a TopicName like e.g.: `color`
6. Click on `Deploy`

### Create Lambda Monitoring Test

1. Go back to the Lambda Service screen
2. On the left sidebar click on `Functions`
3. Click on your new function
4. Scroll down and click on the down-arrow next to `Test`
5. Click on `Configure test event`
6. Select the Event template `Amazon Alexa Intent MyColorIs`
7. Provide a name for the test
8. Click on `Save`
9. Click a few times on `Test` to produce some log entries
10. Open the tab `Monitor` and take a look at the metrics and logs

### Setup Dashboard for Lambda functions

1. In the `Monitor - Metrics` view click on `Add to dashboard`
2. Click on `Create new`
3. Provide a name for your dashboard
4. Click on the small checkmark next to the textbox
5. Click on `Add to dashboard`

### Setup Alerts (AWS)

1. In the `Dashboard` view on the left sidebar select `Alarms`
2. Click on `Create alarm`
3. Click on `Select metric`
4. Scroll down and select the following metric: `Lambda` -> `By Function Name` -> your new function with metric name `Errors`
5. Click on `Select metric`
6. Change statistic to `Sum`
7. Change period to `1 minute`
8. Define threshold with `3`
9. Click on `Next`
10. On `Notification` select `Create new topic`
11. Enter your email-address to `Email endpoints`
12. Click on `Create topic`
13. Scroll down and click on `Next`
14. Set a name for your alarm
15. Click on `Next`
16. Scroll down and click on `Create alarm`
17. Check your emailaccount and confirm the subscription to your alarm
18. Go back to the alerts view and refresh, your alarm should now no longer be pending

### Test Lambda Alert

1. Go back to your Lambda function screen
2. Scroll down and click on the down-arrow next to `Test`
3. Click on `Configure test event`
4. Select `Create new test event`
5. Select the Event template `Amazon Alexa Intent MyColorIs` or your previously made test
6. Provide a name for the test
7. On line 38 change `MyColorIsIntent` to `MyBadTest`
8. Click on `Save`
9. Click a few times (at least 3) on `Test` to produce an alert
10. Check your emailaccount where you should find an alert email
