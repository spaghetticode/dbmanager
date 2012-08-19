Feature: dump database
As a dbmanager gem user
I want to dump any of my app databases to a sql file
so that I can use the file later

  After adding the gem, when running **rake db:dump**
  you can choose the environment db to dump, and the
  path/filename you want for the dump file. After the
  task has completed you will find the dump in the
  expected location.

Scenario: Dump database to user specified file
  Given I go to the dummy rails app folder

  When  I run the task "db:dump" with input "1 tmp/dbmanager_dummy_dev.sql"
  Then  a sql dump should be created in "tmp/dbmanager_dummy_dev.sql"
  And   the dump file should include expected schema
