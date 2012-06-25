Feature: dump database
As a dbmanager gem user
I want to dump any of my app databases to a sql file
so that I can use the file for my purposes

Scenario: Dump database to the default file
  When  I interactively execute "rake db:dump"
  # And   I choose the development database
  # And   I choose to use the default file
  # Then  an sql dump should be created in the expected path
  # And the dump file should include expected schema

Scenario: Dump database to a specific file
