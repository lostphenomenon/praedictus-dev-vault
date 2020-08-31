# 1. Create local branches from all available on the remote:
    #  Create a .sh script somewhere outside the repository with the following script: (i named it gitcopy.sh)
        for i in `git branch -a | grep remote | grep -v HEAD | grep -v master`; do git branch --track ${i#remotes/origin/} $i; done

# 2. Removing the remote and adding a new one:

git remote rm origin
git remote -v
git remote add origin https://xyz@dev.azure.com/xyz/{Project_Name_URL_Escaped}/_git/{RepoName}
git push -u origin --all