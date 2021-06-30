## From 0.18 to 0.23

### Synchronize schema_migrations table

The migrations versions used by clean app are in `db/schema_migrations.sql`. From Decidim version 0.18 until v0.23.
Make sure your app uses also this ones before deploying upgrades to version 0.23.


Delete querys with wrong versions.
```
delete from schema_migrations where version = '20191115095823';
delete from schema_migrations where version >= '20200728070144' and version < '20200728070149';
delete from schema_migrations where version >= '20200728070150';
delete from schema_migrations where version = '20190826090449';
delete from schema_migrations where version = '20190826090450';
```

## From 0.19 to 0.20

In order for the newly searchable entities to be indexed, you'll have to manually trigger a reindex. You can do that by running in the rails console:

```ruby
Decidim::Assembly.find_each(&:add_to_index_as_search_resource)
Decidim::ParticipatoryProcess.find_each(&:add_to_index_as_search_resource)
Decidim::Conference.find_each(&:add_to_index_as_search_resource)
Decidim::Consultation.find_each(&:add_to_index_as_search_resource)
Decidim::Initiative.find_each(&:add_to_index_as_search_resource)
Decidim::Debates::Debate.find_each(&:add_to_index_as_search_resource)
# results are ready to be searchable but don't have a card-m so can't be rendered
# Decidim::Accountability::Result.find_each(&:add_to_index_as_search_resource)
Decidim::Budgets::Project.find_each(&:add_to_index_as_search_resource)
Decidim::Blogs::Post.find_each(&:add_to_index_as_search_resource)
```

## From 0.20 to 0.21

### Organization Time Zone

Now is its possible to configure every organization (tenant) with a different time zone by any admin in the global configuration. 

Configure the proper time zone in the admin for the organization.

## From 0.22 to 0.23

### Debates and Comments are now in global search

Debates and Comments have been added to the global search and need to be indexed, otherwise all previous content won't be available as search results. You should run this in a Rails console at your server or create a migration to do it.

Please be aware that it could take a while if your database has a lot of content.

```ruby
Decidim::Comments::Comment.find_each(&:try_update_index_for_search_resource)
Decidim::Debates::Debate.find_each(&:try_update_index_for_search_resource)
```
