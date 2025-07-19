# Helpful commands to manage the repository

## Manage forked repository `typst-packages`

### Update your forked repository

- `git checkout -b dev-deckz` Create a new branch for development.
- `git push -u origin dev-deckz` Publish the current branch to your forked repository on GitHub.
- `git pull upstream main`
Pull changes from the upstream repository (the official Typst packages repo) to your forked repository.

### Publish a new version of a package
Assuming that you have made changes to the folder in which you are developing the package:
- `./tools/sync-to-packages.bat` Copy the contents of the working folder to the `typst-packages` repository.
- `cd ../typst-packages` Change directory to your forked repository.
- `git add .` Add all changes to the staging area.
- `git commit -m "Update <Name> package to version X.Y.Z"`
- `git push origin main`
Push changes from your local repository to your forked repository on GitHub. This is needed to create a **pull request** on the official Typst packages repo.