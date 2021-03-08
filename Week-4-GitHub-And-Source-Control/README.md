# Week 3 - GitHub and Source Control

## Git

### Software

| Name    | Installation Method | Install Command     |
| ------- | ------------------- | ------------------- |
| Git CLI | Chocolatey          | `choco install git` |

#### Helpful VSCode Plugins

| Name    | Identifier      | Short Description                                                       |
| ------- | --------------- | ----------------------------------------------------------------------- |
| GitLens | eamodio.gitlens | GitLens supercharges the Git capabilities built into Visual Studio Code |

### Helpful Additional Software

| Name         | Installation Method | Install Command             | Short Description                                                             |
| ------------ | ------------------- | --------------------------- | ----------------------------------------------------------------------------- |
| Tortoise Git | Chocolatey          | `choco install tortoisegit` | Integration of Git-Commands into Windows Context Menu                         |
| GitViz       | Chocolatey          | `choco install gitviz`      | visualize the git repository real time revealing the blobs, trees and commits |

### Git Commands

The following is a list of commonly used commands of the git cli.

#### - Add

This subcommane is for saving changed files to the staging area. Only Files added to the staging area are ready for being commited.

Examples:

Lets assume we have 3 new files we want to put into source control

```Powershell
git add file1 file2 file3
```

#### - Branch

This subcommand is used for managing branches.

Examples:

Create new branch:

```Powershell
git branch development
```

List all available branches:

```Powershell
git branch
```

#### - Checkout

Checkout is a very powerful subcommand which can be used from simply switching branches to merging or moving between various commits within a branch. For some of its flags there are other subcommands that would just do the same.

Examples:

Switching branch:

```Powershell
git checkout development
```

Creating branch and switching to it in a single command:

```Powershell
git checkout -b development_new
```

#### - Clone

Git clone will create a local copy/clone of an existing remote repository on your local machine.

Examples:

Clone repo into current working directory:

```Powershell
git clone https://github.com/danielkomaz/cloudskillsbootcamp.git
```

Clone repo into specific directory:

```Powershell
git clone https://github.com/danielkomaz/cloudskillsbootcamp.git C:\Temp\cloudskillsbootcamp
```

#### - Commit

The commit subcommand is used for saving changes made to files, which were already added to the staging area via `git add`, into the local repository.

Examples:

Commit the staged snapshot. This will launch a text editor prompting you for a commit message:

```Powershell
git commit
```

Commit a snapshot of all changes in the working directory. This only includes modifications to tracked files:

```Powershell
git commit -a
```

Commit a staged snapshot and add a commit messqage in a single step. This can be combined with `-a` by using the flag `-ma` instead of just `-m` :

```Powershell
git commit -m "Commit Message"
```

#### - Config

With the config subcommand you can modify the configuration of you git installation. Mostly this is used to add username and email address to your config. Most of the time you will add them to your global config which is used across all repos on your local machine. If you add something to the local config of your repo these settings will overwrite those used in the global configuration.

Examples:

Adding username and email to global config:

```Powershell
git config --global user.name "Your Name Comes Here"
git config --global user.email you@yourdomain.example.com
```

Show global git configuration:

```Powershell
git config --list --global
```

#### - Diff

#### - Fetch

#### - Grep

#### - Log

#### - Merge

#### - Pull

#### - Push

#### - Show

#### - Status

#### - Tag

### Helpful Links

https://git-scm.com/docs/gittutorial
