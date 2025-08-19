# Helpful commands to manage the repository
I wrote this document to help me manage my fork of the `typst/packages` repository.
It's not perfect, but it should help you get started with managing your forked repository.

## Setup your forked repository
Clone your forked repository to your local machine and set it up for a sparse checkout.
```sh
git clone --depth 1 --no-checkout --filter="tree:0" git@github.com:typst/packages
cd packages # Change to your forked repository
git sparse-checkout init
git sparse-checkout set packages/preview/{your-package-name}
```
> Based on [typst/packages documentation](https://github.com/typst/packages/blob/main/docs/tips.md).

Move to the branch `main` of your forked repository.
```sh
git checkout main
git pull upstream main # Pull changes from the upstream repository (the official Typst packages repo) to your forked repository.
```
Be sure to have set up a **sparse checkout**, so that you only download the files you need.

Then, create a new branch for your development work.
```sh
git checkout -b dev-{package-name} # Create a new branch for development.
git push -u origin dev-deckz # Publish the current branch to your forked repository on GitHub.
```

This should have created a new branch in your forked repository, which you can use to develop your package. 

```sh
git sparse-checkout set packages/preview/{your-package-name} # Set the sparse checkout to the folder where you will develop your package.
```

Now you can start working on your package in the `packages/preview/{your-package-name}` folder.

### Create a new package in the forked repository

Usually, you won't work in the forked repo. Instead, you will work in the official package repository (in case of `deckz`, it is `MicheleDusi/Deckz`). 

```sh
cd ../Deckz # Change directory to the official package repository.
```

Then, you will "move" the changes of this directory to your forked repository.

Assuming you are in the `MicheleDusi/Deckz` repository, you now want to create a *new package* in your forked repository.

```sh
./tools/sync-to-packages.bat # Copy the contents of the working folder to the `typst-packages` repository.
```
This command will copy the contents of the current working folder to the `typst-packages` repository, which is your forked repository.

After running the command, you will have the package in your forked repository. Now, you can move to your forked repository:

```sh
cd ../typst-packages # Change directory to your forked repository.

# If you still have to create the branch, do it now:
git checkout main # Move to the main branch of your forked repository.
git checkout -b dev-deckz # Create a new branch for development.
git push -u origin dev-deckz # Publish the current branch to your forked repository on GitHub.

# Now, you can add the new package to your forked repository.
git add packages/preview/deckz # Add the new package to the staging area.
git commit -m "{your-package-name}:0.Y.Z"
git push origin dev-deckz # Push changes from your local repository to your forked repository on GitHub.
```
Now you can move to GitHub and create a **pull request** to the official Typst packages repository.

### Publish a new version of a package

Assuming that you have made changes to the folder in which you are developing the package:
- `./tools/sync-to-packages.bat` Copy the contents of the working folder to the `typst-packages` repository.
- `cd ../typst-packages` Change directory to your forked repository.
- `git add .` Add all changes to the staging area.
- `git commit -m "{package-name}:X.Y.Z"`
- `git push origin main`
Push changes from your local repository to your forked repository on GitHub. This is needed to create a **pull request** on the official Typst packages repo.