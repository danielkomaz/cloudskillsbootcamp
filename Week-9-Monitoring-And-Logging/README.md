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

## Project 3 - Azure Monitor and Alerting

In this lab we will set an alert on vm level which will email us and also set an automatic action if it is triggered. Also we will configure an alert on the forecated costs of our Azure Subscription including email notification.

### High CPU Alert

In the [Azure Portal](http://portal.azure.com/) we will create an alert which will monitor the CPU usage of our VM and will send us an email if it is triggered.  
This lab will depend on the [deployment of the VM in Project 1](#-Project-1---Monitoring-Azure-IaaS).

1. Search for `Monitor` and click on `Monitor` in the results
2. In the left pane click on `Virtual Machines`and see that the VM is managed by Azure Monitor

#### Create Automatic Action

1. In the left pane click on `Alerts`
2. Click on `Manage actions`
3. Click on `New action group`
4. Select or create a new resource group
5. Name your action group
6. The display name will be entered automatically but you might change it if you want
7. Click on `Next: Notifications`
8. Choose notification type `Email/SMS message/Push/Voice`
9. Check `Email` in the right pane and enter your email address
10. Click on `OK`
11. Set a name for your notification
12. Click on `Next: Actions`
13. Choose Action type `Automation Runbook`
14. Choose Runbook Action `Stop VM`
15. Select your Subscription
16. Click on `Automation Account` to crea a new automation account for your subscription
17. Name your automation account
18. Select a resource group or create a new one
19. Click on `OK`
20. Click `OK` again
21. Provide a name for your Runbook
22. Click on `Review + Create`
23. Review your settings and click on `Create`

#### Create Alert Rule

1. Go back to the Monitor resource screen
2. Click on `Alerts` in the left pane
3. Click on `New Alert Rule`
4. Click on `Select Resource`
5. Filter the list with `Virtual machines`
6. Select your deployed VM
7. Click on `Done`
8. Click on `Add condition`
9. Search for `CPU` and select `Percentage CPU`
10. Leave the chart period, scroll down and set the threshold value to `3`
11. Click `Done`
12. Click on `Add action group`
13. Select your previously created action group
14. Click on `Select`
15. Provide a name for your alert rule
16. Switch Severity to `2 - Warning`
17. Make sure `Enable alert rule upon creation` is checked
18. Click on `Create alert rule`

#### Trigger Alert Rule

1. In the Azure Portal search for `vm` and click on `Virtual machines` in the results
2. Open your monitored VM
3. In the left pane scroll down and select `Run command`
4. Click on `RunPowerShellScript`
5. Enter the following command and click `Run`:
   `Install-Module az -force`
6. After some time return to the `Overview` and you will see that the VM has been turned off.

### Cost Alert

With this we will set an alert which will warn us if our forecasted monthly bill would outgrow our set budget.

1. Open the [Azure Portal](http://portal.azure.com/), search for `cost` and select `Cost Management + Billing` from the results
2. In the left pane click on `Cost Management`
3. In the left pane click on `Cost alerts`
4. Click on `Add`
5. Make sure the Scope is correctly set to your Subscription
6. Provide a name for your Budget
7. Keep `Reset Period` on `Billing Month`
8. Set the limit of you buget that should not be outgrown
9. Scroll down and click on `Next`
10. Select Alert condition `Forecast`
11. Enter `100` into % of budget
12. Keep action group to `None`
13. Enter your email address into `Alert recipients (email)`
14. Click on `Create`

## Project 4 - Azure Logging and Metrics

For this lab we need the deployment of [Week 8 - Project 6](https://github.com/danielkomaz/cloudskillsbootcamp/tree/main/Week-8-Containerization-And-Kubernetes#project-6---using-azure-aci).  
Here we will go through some basic usages of the ACI metrics.

### View ACI Metrics

1. In the [Azure Portal](http://portal.azure.com/), search for `container` and select `Container instances` from the results
2. Open your Container Instance
3. Click on `Metrics` in the left pane
4. Select Metric `Memory Usage`
5. On the right side click on `Local Time` and select `30 Minutes`

### View ACI Logs

In the metrics view of the ACI click on `Drill into Logs` -> `Activity Logs`.  
Here you can see all logs connected to your Container Instance.

_Note:_ Take some time and look around the Metrics and logs until you get a good understanding on what it can do for you when you need it.

## Project 5 - AWS CloudWatch

In this lab we will take a look on what Cloudwatch can do for us in terms of displaying metrics and alerts for EC2 instances.

### Deploy EC2 Instance With Monitoring Enabled

1. Open the [AWS portal](https://aws.amazon.com/)
2. Search for `EC2` and select it from the results
3. Click on `Launch instance`
4. Use the `Amazon Linux 2 AMI (HVM), SSD Volume Type` or any other free tier eligable image and click `Select`
5. Keep `t2.micro` selected
6. Click on `Next: Configure Instance Details`
7. Select a network for your EC2 instance (you can also leave it to default)
8. Scroll down and check `Enable CloudWatch detailed monitoring`
9. Click on `Next: Add Storage`
10. Keep everything default an click on `Next: Add Tags`
11. (Optional) Add some tags
12. Click on `Next: Configure Security Group`
13. Create a security group or select an existing one to prevent the whole world to access your EC2 instance
14. Click on `Review and Launch`
15. After the instance has successfully been launched open it in the portal
16. In the Overview of your instance click on `Monitoring`

Here you can check the basic monitoring metrics provided by EC2 instances.

### Enable Detailed Monitoring

1. In the `Monitoring` tab of your EC2 instance click on `Manage detailed monitoring`
2. Make sure `Enable` is checked
3. Click on `Save`
4. Search for `CloudWatch` in the searchbar and click on it in the results
5. Scroll down in the Services table and click on `EC2`

In this view you are able to see detailed information abaout all your monitoring enabled EC2 instances.  
If you click on `Service dashboard` you are able to also check your Alarms.  
You should definitely get familar with these dashboards as they will be good tools for basic performance monitoring if you should start using AWS.
