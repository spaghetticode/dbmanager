Feature: dump database
As a dbmanager gem user
I want to dump any of my app databases to a sql file
so that I can use the file for my purposes

Scenario: Dump database to user specified file
  Given I go to the dummy rails app folder
  When  I interactively execute "rake db:dump < dump_stubbed_STDIN"
  Then  an sql dump should be created in "tmp/dbmanager_dummy_dev.sql"
  And the dump file should include expected schema

Scenario: Dump database to a specific file
