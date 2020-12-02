Feature: Water Plants
    The system waters the plants automatically

    Scenario: everything fine
        When soilMoisture < x
        And watertank has enough water
        And pump is online 
        Then pump starts
        Then make a database entry
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
        When soilMoisture < x
        And watertank has not enough water
        Then show warning: refill your watertank  
        Then go back to soilMoisture < x
        
