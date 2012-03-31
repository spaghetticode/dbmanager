## Dbmanager

[![Build Status](https://secure.travis-ci.org/[YOUR_GITHUB_USERNAME]/[YOUR_PROJECT_NAME].png)](http://travis-ci.org/[YOUR_GITHUB_USERNAME]/[YOUR_PROJECT_NAME])

This gem will add some convenience rake tasks that will help you manage database
dumps and imports. At the moment only the mysql adapter is available.

The gems works both on rails 2.x and 3.x applications, but due to rails 2.x
limitations you have to run a generator, see the usage section


### Usage

Add the gem to your gemfile:

```ruby
  gem 'dbmanager', :git => 'git://github.com/spaghetticode/dbmanager.git'
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

You will be prompted to choose the target dir (defaults to tmp) and the sql file
name (sql extension will be added automatically). If the file already exists, it
will be overwritten.


#### Database Imports

```ruby
rake db:import
```

You will be prompted to choose the source and the target environment db, and the
source db will be imported into the target db. All environments containing the
string 'production' in their name are protected by default, which means you cannot
overwrite them unless you explicitly override this setting in the override file
(see next section for more info).

#### BEWARE

import process is destructive, be careful on what environment you choose to
overwite. I take no responsibility for misuse or bugs in the code ;-)


#### Override database.yml

Since some settings may be specific to the server environment (ie. host could
be a private ip not reachable from anywhere) you can overwrite the settings in
database.yml by adding a dbmanager_override.yml file in your rails config dir.
Another use is to set some environments as protected, or vice versa allow to
overwrite production env.
For example if we want to override the following setting, and make the database
protected from overwriting:

```yaml
beta:
  host: 192.168.0.1
```
we should put in dbmanager_override.yml this:

```yaml
beta:
  host: 234.234.234.234
  protected: true
```

Instead, if we want to make the production env writable we should add this:

```yaml
production:
  protected: false
```


### TODO

* Add more db adapters
* remove views from mysql dumps so they don't interfere in the import process
