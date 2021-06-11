Feature: Water Plants
    The system waters the plants automatically

    Scenario: everything fine
        When plant needs water
        And watertank has enough water
        Then pump starts
        Then make a database entry

    Scenario: water tank empty
        When plant needs water
        And watertank has not enough water
        Then show warning: refill your watertank  
        Then go back to when plant needs water
        
