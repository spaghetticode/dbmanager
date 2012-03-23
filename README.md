## Dbmanager

This gem will add some convenience rake tasks that will help you manage db dumps
and imports.

### Database Imports

rake db:import

You will be prompted to choose the source and the target environment db, and the
source db will be imported into the target db. Production db is protected, which
means you cannot overwrite it.

### Database Dumps

rake db:dump

You will be prompted to choose the target dir (defaults to tmp) and the sql file
name (sql extension will be added automatically). If the file already exists, it
will be overwritten.

### Override database.yml

Since some settings may be specific to the server environment (ie. host could
be a private ip not reachable from anywhere) you can overwrite the settings in
database.yml by simpy...
