Feature: Dbmanager rake task listed in rake -T
 As a dbmanager gem user
  I want the dbmanager rake tasks to be added to my application
  so that I can to execute them

    The dbmanager gem adds 2 rake tasks to your application:

      db:dump that interactively dumps the content of a db
      db:import that interactively import a db into another


Scenario: db:dump task
  Given I go to the dummy rails app folder
  When  I execute "rake -T"
  Then  I should see "db:dump" among the listed tasks

Scenario: db:import task
  Given I go to the dummy rails app folder
  When  I execute "rake -T"
  Then  I should see "db:import" among the listed tasks
