Feature: Water Plants
    User should be able to water plants manually if they need water.

    Scenario: everything fine
        When Plant needs water
        And Water tank full
        Then show button water plants
        When user taps on button water plants
        And pump is online 
        Then start pump via API
        Then disable water plants button
        Then set indicator light: green

    Scenario: pump offline
        When Plant needs water
        And Water tank full
        Then show button water plants
        When user taps on button water plants
        And pump is offline 
        Then show warning: Pump is offline
        Then set indicator light: red

    Scenario: water tank empty
        When Plant needs water
        And Water tank empty
        Then show warning: refill your watertank       
        
