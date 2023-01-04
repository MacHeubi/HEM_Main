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

Push to GitHub to new Branch: 'git push -u origin new_barnch_name'

-- do the merge on GitHub --

Delete a Branch once merged and not used anymore: 'git branch -d Branch_name'

## Links

Youtupe video: 'https://www.youtube.com/watch?v=RGOj5yH7evk'