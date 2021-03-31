Feature: Counter
    Scenario: Initial counter value is 0
        Given the app is running
        Then I wait {'2'} seconds
        Then I see {'home_searchText'} text