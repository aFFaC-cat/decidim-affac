# DECIDIM.CLEAN.APP

This is a clean Decidim app to use as a starting point for other Decidim app projects.

## Fork the repository

A fork is a copy of a repository. Forking a repository allows you to make changes without affecting the original project.

In the top-right corner of the page, click **Fork**.

## Keep your fork synced

To keep your fork up-to-date with the upstream repository, i.e., to upgrade decidim, you must configure a remote that points to the upstream repository in Git.

```console
# List the current configured remote repository for your fork.
$ git remote -v
# Specify the new remote upstream repository that will be synced with the fork.
$ git remote add decidim-clean https://github.com/CodiTramuntana/decidim-clean-app
# Verify the new decidim-clean repository you've specified for your fork.
$ git remote -v
```
Syncing a fork
```console
# Check out your fork's local master branch.
$ git checkout master
# Incorporate changes from the decidim-clean repository into the current branch.
$ git pull decidim-clean
```

## Customize your fork

The following files should be modified:

- package.json
- config/application.rb
- config/initializers/decidim.rb
