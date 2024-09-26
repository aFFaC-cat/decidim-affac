# DECIDIM-FAPAC-APP

## Deploying the app

Deploy is located in an external project

## Setting up the application

You will need to do some steps before having the app working properly once you've deployed it:

1. Open a Rails console in the server: `bundle exec rails console`
2. Create a System Admin user:

```ruby
user = Decidim::System::Admin.new(email: <email>, password: <password>, password_confirmation: <password>)
user.save!
```

3. Visit `<your app url>/system` and login with your system admin credentials
4. Create a new organization. Check the locales you want to use for that organization, and select a default locale.
5. Set the correct default host for the organization, otherwise the app will not work properly. Note that you need to include any subdomain you might be using.
6. Fill the rest of the form and submit it.

You're good to go!

### How to deploy

Deployment is prepared for docker.

## Embeded Plausible analytics

Plausible analytics are embeded in the admin panel. To enable them you need to set the following environment variables:

```bash
PLAUSIBLE_URL=https://analytics.plausible.io
PLAUSIBLE_YOURDOMAIN_COM=auth-code
```

Where `auth-code` is the "`auth`" parameter shown in a created shared link in the Plausible dashboard. Note that you must make the share link public (without a password).


