Feature: Running server
  In order to have a server to collect data
  As a admin
  I want to be able to run the tahini server

  Scenario: Running the Tahini Server
    When I start Tahini
    Then Tahini should be running on "127.0.0.1" port "3040"

  
