# Main Repoository für mein Code

## Git & GitHub Commands

Local Git-Repository erstellen: 'git init'

Status im aktuellen Ordner: 'git status'

Alle neue Files dem Repository (local) zufügen: 'git add .' (oder hier ein file-name angeben)

Zugefügte Änderungen Commiten (local): 'git commit -m "Main Message" -m "Detail Message"'


Ein leeres Repository auf GitHub verlinken (link aus GitHub.com holen)

1st time link zum GitHub Repository erstellen: 'git remote origin [Link aus GitHub.com]'

2nd check if remote Repo is there: 'git remote v-'

Once gelinkt: 'git push origin [branch aus GitHub.com / bei mir "main"]'

If there are changes on GitHub ready for me, i need to pull them: 'git pull origin [main / Branch name]'

### Branching in Git

What Branches are awailabel: 'git branch'

Create new Branch: 'git checkout -b branche-name'

Compare two branches: 'git diff branch_name' (against master / main)

Push to GitHub to new Branch: 'git push -u origin new_branch_name'

-- do the merge on GitHub --
'git merge Branch_name'

Delete a Branch once merged and not used anymore: 'git branch -d Branch_name'

### Undo stuff

Undo git add: 'git reset [file_name]'

Undo git commit: 'git reset HEAD~1'
HEAD = pointer to the last commit for Git
~1 = to un-commit and un-stage (add)

To see what was commited in a reversed chronological way: 'git log'
Option to go back to a specific stage: git reset [hash of a certain commit out of the log]

To undo the changes in the file: git reset --hard [hash fo a certain commit our of the log]

-> leading to HEAD pointing to a new commit!!

## Links

Youtupe video: 'https://www.youtube.com/watch?v=RGOj5yH7evk'