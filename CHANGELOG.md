## v0.4.2

* capistrano related code fix

## v0.4.1

* capistrano recipe bug fixes

## v0.4.0

* add capistrano integration via db:import task
* minor changes to support capistrano integration

## v0.3.0

* add support for --set-gtid-purged=OFF flag when using mysqldump with version number >= 5.6
* refactoring and general code cleanup

## v0.2.0

* merge pull request from Elia (add loader task)
* refactoring of the main structure and specs

## v0.1.7

* merge pull request from Racko (add quotes to file names)

## v0.1.6

* close issue #5 (should not require 'dbmanager.rb' in the rake file)

## v0.1.5

* import task creates the target db if necessary

## v0.1.4

* environments are now listed sorted
* raise meaningful error when database.yml contains invalid data

## v0.1.2

* move checks for protected environment from adapters to dumpable and importable modules

## v0.1.0

* major code refactoring
* allow mixed adapters in database.yml
* import process dumps to rails app tmp directory

## v0.0.6

* handle mysql2 adapter

## v0.0.5

* remove exception when dbmanager.yml is empty

## v0.0.4

* bugfixes

## v0.0.3

* allow skipping tables

## v0.0.1

* initial release
