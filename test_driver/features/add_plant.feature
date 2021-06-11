Feature: Add Plant
    User should be able to add a plant to manage it with the LazyPlants-App.

    Scenario: everything fine
        When User clicks on button: Add
        Then show screen: Configuration 1
        When User clicks on button: Next
        Then show screen: Configuration 2
        When User fills in entries
        And User clicks on button: Next
        And input is correct
        Then show screen: Configuration 3
        When User fills in entries
        And User clicks on button: Next
        Then Store user data locally and via API
        Then show screen: Home screen

    Scenario: go back to configuration 2
        When User clicks on button: Add
        Then show screen: Configuration 1
        When User clicks on button: Next
        Then show screen: Configuration 2
        When User fills in entries
        And User clicks on button: Next
        And input is correct
        Then show screen: Configuration 3
        When User fills in entries
        And User clicks on button: Back
        Then show screen: Configuration 2

    Scenario: input in configuration 1 incorrect
        When User clicks on button: Add
        Then show screen: Configuration 1
        When User clicks on button: Next
        Then show screen: Configuration 2
        When User fills in entries
        And User clicks on button: Next
        And input is incorrect 
        Then show screen: Configuration 2

    Scenario: go back to configuration 1
        When User clicks on button: Add
        Then show screen: Configuration 1
        When User clicks on button: Next
        Then show screen: Configuration 2
        When User clicks on button: Back
    
    Scenario: go back to home screen
        When User clicks on button: Add
        Then show screen: Configuration 1
        When User clicks on button: Back
        Then show screen: Home screen