Feature: Water Plants
    The system waters the plants automatically

    Scenario: everything fine
        When plant needs water
        And watertank has enough water
        And pump is online 
        Then pump starts
        Then make a database entry
        Then set indicator light: green

    Scenario: pump offline
        When plant needs water
        And Water tank full
        Then show button water plants
        When user taps on button water plants
        And pump is offline 
        Then show warning: Pump is offline
        Then set indicator light: red

    Scenario: water tank empty
        When plant needs water
        And watertank has not enough water
        Then show warning: refill your watertank  
        Then go back to when plant needs water
        
