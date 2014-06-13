## Dbmanager

[![Build Status](https://secure.travis-ci.org/spaghetticode/dbmanager.png)](http://travis-ci.org/spaghetticode/dbmanager)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/spaghetticode/dbmanager)

This gem will add some convenience rake tasks that will help you manage database
dumps and imports. At the moment only the mysql adapter is available.

The gems works both on rails 2.x and 3.x applications, but due to rails 2.x
limitations you have to run a generator, see the usage section


### Usage

Add the gem to your gemfile:

```ruby
  gem 'dbmanager'
```

If you're on a rails 2.x application you also need to run:

```ruby
script/generate dbmanager
```
that will copy the gem rake tasks file into the lib/tasks directory.


#### Database Dumps

```ruby
rake db:dump
```
This rake task will dump the requested db to a file on the local machine.

You will be prompted to choose the target dir (defaults to *tmp* in the rails
root) and the sql file name (sql extension will be added automatically). If the
file already exists, it will be overwritten.


#### Database Imports

```ruby
rake db:import
```

You will be prompted to choose the source and the target environment db, and the
source db will be imported into the target db.

This task will import a source db to a destination db. Tipical use is to import
the production db into your development one. All environments containing the
string 'production' in their name are protected by default, which means you cannot
overwrite them unless you explicitly override this setting in the override file
(see next section for more info).


#### Database Loads

```ruby
rake db:load
```

This rake task will load the db data from a dump file.

You will be prompted to choose the source file (defaults to *tmp/{db_name}.sql* in the rails
root) and the target environment.

**Import and load processes are destructive** so be careful on which environment you
choose to overwite. I take no responsibility for misuse or bugs in the code ;-)


#### Override database.yml and custom configurations

Since some settings may be specific to the server environment (ie. host could
be a private ip not reachable from elsewhere) you can override the settings in
database.yml by adding a dbmanager_override.yml file in your rails config dir.

Tipical use is to set some environment as protected, or on the other hand allow
overwriting if it's protected by default (ie. production env).

If you want to override the following setting in the database.yml file making
the database protected from overwriting and changing the host address to a
public one:

```yaml
beta:
  host: 192.168.0.1
```
you should put this in config/dbmanager_override.yml:

```yaml
beta:
  protected: true
  host: 234.234.234.234
```

Instead, if you want to make the production env writable you should add this to
the config/dbmanager_override.yml file:

```yaml
production:
  protected: false
```

On mysql you can instruct the dumper to ignore certain tables using the
ignoretables directive:

```yaml
  beta:
    ignoretables:
      - users
      - prods_view
```


## Capistrano Integration

You can use DBmanager via Capistrano as well. At the moment the only available
task is import your remote database into your local machine. The use is currently
limited to Capistrano 2.x

You can do that by running

```bash
  bundle exec cap <environment> db:import
```

### Custom Capistrano configuration

If you need to change some configuration option (notably overwrite database configurations from
database.yml such as username, password and so on) you need to set those custom values in your
deployment recipe. For example, if you need to set the remote database password using the remote
ENV values you should add:

```ruby
  set :dbmanager_remote_env, lambda {
    Dbmanager::YmlParser.environments[rails_env.to_s].tap do |env|
      env.password = capture('echo $MYSQL_PASSWORD')
    end
  }
```


## Documentation

You can find some more documentation on the workings of the gem on relish:
https://www.relishapp.com/spaghetticode/dbmanager/docs


## Tests

run rspec tests: ```rake```

run cucumber tests: ```cucumber```

Cucumber tests require mysql server running. Update spec/dummy/config/database.yml
with your mysql configuration, if necessary.


## Upgrade Notice

If you're still on rails 2.x and you're upgrading dbmanager to the latest version please rerun the
dbmanager rake file generator with:

```ruby
script/generate dbmanager
```


### TODO

* Add more db adapters
