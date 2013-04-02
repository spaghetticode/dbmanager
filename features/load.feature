Feature: load database
As a dbmanager gem user
I want to load a sql file into any of my app databases
so that the database becomes fully populated

  After adding the gem, when running **rake db:load**
  you can choose the environment db to be loaded with data,
  and the sql file that you want to load. After the task
  has completed the selected database will be populated
  with the data from the sql file.

Scenario: Load database from tmp/load/john_doe.sql
  Given I go to the dummy rails app folder

  When  I run the task "db:load" with input "1 tmp/load/john_doe.sql"
  Then  the "development" database should include a friend named "John Doe"
