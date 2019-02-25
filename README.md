# DECIDIM.CLEAN.APP

This is a Decidim app to use as a starting point for other projects that use Decidim.

## Fork the repository

A fork is a copy of a repository. Forking a repository allows you to make changes without affecting the original project.

In the top-right corner of the page, click **Fork**.

## Keep your fork synced

To keep your fork up-to-date with the upstream repository, you must configure a remote that points to the upstream repository in Git.

```bash
# List the current configured remote repository for your fork.
$ git remote -v
# Specify a new remote upstream repository that will be synced with the fork.
$ git remote add decidim-clean https://github.com/CodiTramuntana/decidim_clean_app
# Verify the new decidim-clean repository you've specified for your fork.
$ git remote -v
```
Syncing a fork
```bash
# Check out your fork's local master branch.
$ git checkout master
# Incorporate changes from the upstream repository into the current branch.
$ git pull decidim-clean
```

## Customize your fork

The following files should be modified:

- package.json
- config/application.rb
- config/initializers/decidim.rb
