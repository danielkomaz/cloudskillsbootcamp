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

For this Project we need to prepare the following Azure infrastructure:

- VM with Windows Server 2019 Datacenter and public IP
- Managed Service Identity bound to the VM
- Azure Key Vault

The directory `Project-3\Terraform` provides you with a terraform module to povide all these with a single `terraform apply`.
