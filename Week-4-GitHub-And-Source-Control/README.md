# Week 3 - GitHub and Source Control

A brief documentation about frequently used git commands.

## Software

| Name    | Installation Method | Install Command     |
| ------- | ------------------- | ------------------- |
| Git CLI | Chocolatey          | `choco install git` |

### Helpful VSCode Plugins

| Name    | Identifier      | Short Description                                                       |
| ------- | --------------- | ----------------------------------------------------------------------- |
| GitLens | eamodio.gitlens | GitLens supercharges the Git capabilities built into Visual Studio Code |

## Helpful Additional Software

| Name         | Installation Method | Install Command             | Short Description                                                             |
| ------------ | ------------------- | --------------------------- | ----------------------------------------------------------------------------- |
| Tortoise Git | Chocolatey          | `choco install tortoisegit` | Integration of Git-Commands into Windows Context Menu                         |
| GitViz       | Chocolatey          | `choco install gitviz`      | visualize the git repository real time revealing the blobs, trees and commits |

## Git Commands

The following is a list of commonly used commands of the git cli.

### - Add

This subcommane is for saving changed files to the staging area. Only Files added to the staging area are ready for being commited.

Examples:

Lets assume we have 3 new files we want to put into source control

```Powershell
git add file1 file2 file3
```

### - Branch

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

### - Checkout

`Checkout` is a very powerful subcommand which can be used from simply switching branches to merging or moving between various commits within a branch. For some of its flags there are other subcommands that would just do the same.

Examples:

Switching branch:

```Powershell
git checkout development
```

Creating branch and switching to it in a single command:

```Powershell
git checkout -b development_new
```

### - Clone

Git `clone` will create a local copy/clone of an existing remote repository on your local machine.

Examples:

Clone repo into current working directory:

```Powershell
git clone https://github.com/danielkomaz/cloudskillsbootcamp.git
```

Clone repo into specific directory:

```Powershell
git clone https://github.com/danielkomaz/cloudskillsbootcamp.git C:\Temp\cloudskillsbootcamp
```

### - Commit

The `commit` subcommand is used for saving changes made to files, which were already added to the staging area via `git add`, into the local repository.

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

### - Config

With the `config` subcommand you can modify the configuration of you git installation. Mostly this is used to add username and email address to your config. Most of the time you will add them to your global config which is used across all repos on your local machine. If you add something to the local config of your repo these settings will overwrite those used in the global configuration.

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

### - Diff

The subcommand `diff` can show you the differences between a file and a specific version of this file.

Examples:

Check differences between a local file and its counterpart in the HEAD-revision:

```Powershell
git diff HEAD .\Week-4-GitHub-And-Source-Control\README.md
```

### - Fetch

By using the `fetch`subcommand you can safely update your local repository with all changes from the remote server without updating your local working state. This means that your repo will be updated but all local changes you made will stay intact.

Examples:

Fetch all branches from remote repository:

```Powershell
git fetch https://github.com/danielkomaz/cloudskillsbootcamp.git
```

Fetch a secific branch from remote repository:

```Powershell
git fetch https://github.com/danielkomaz/cloudskillsbootcamp.git development
```

Fetch all registered/available remote branches:

```Powershell
git fetch --all
```

A `dry-run` will show you the changes that would be made by the fetching command:

```Powershell
git fetch --dry-run
```

### - Log

The `log` subcommand will list you all commits. You can either list all or just a list of selected ones, where you could even exclude some if you want.

Examples:

List log of all commits:

```Powershell
git log
```

List log of a selection of commits. For this you need to know the "names" of the first and last commit you want to list:

```Powershell
git log <commit1>..<commit5>
```

Draw a text-based graphical representation of the commit history on the left hand side of the output:

```Powershell
git log --graph
```

### - Merge

The `merge` subcommand will take two branches and integrate them into a single branch. Note that `merge` will by default merge into the current branch, so be sure to switch to the branch you want to merge into.

Examples:

If executed in the master brach this will merge the `development_new` into the `master` branch:

```Powershell
git merge development_new
```

### - Pull

Basically the `pull` subcommand is a combination of two other commands. It will first `fetch` the current branch, then `merge` the remote HEAD into the local version with a separate commit and then let the local HEAD point to the new commit.

Examples:

Same as doing `git fetch` followed by `git merge origin/＜current-branch＞`:

```Powershell
git pull <remote>
```

Same as the above but without doing a `merge` commit:

```Powershell
git pull --no-commit
```

### - Push

The `push` subcommand will upload your local commits to the remote repository. `Push` has the potential to overwrite your remote changes with the `--force` flag, so be carful. This is also the way to push local branches to the remote repository.

Examples:

Push branch to the remote repositoy. `<remote>` and `<branch>` are optional if you just want to push your current branch:

```Powershell
git push <remote> <branch>
```

Push all tags of your current repository to the remote repo:

```Powershell
git push <remote> --tags
```

### - Show

With the `show` subcommand you can inspect changes made to a specific object (blobs, trees, tags and commits).
For `commits` it shows the log message and textual diff. It also presents the merge commit in a special format as produced by git diff-tree --cc.
For `tags`, it shows the tag message and the referenced objects.
For `trees`, it shows the names.
For `blobs`, it shows the plain contents.

Examples:

Shows the changes made in the provided commit:

```Powershell
git show 352da4c8520922a7d8f38ba50253c45c8aa373ee
```

### - Status

The `status` subcommand displays paths that have differences between you local worktree and the current HEAD commit.

Examples:

Shows a summary of all changes in the current branch:

```Powershell
git status
```

Give a very short output about what changed:

```Powershell
git status -s
```

The `-v` flag will give you a detailed report of changes even within files:

```Powershell
git status -v
```

## Helpful Links

https://git-scm.com/docs/gittutorial

https://www.atlassian.com/git/tutorials/learn-git-with-bitbucket-cloud
