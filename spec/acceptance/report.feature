Feature: Report testing

  @selenium
  Scenario: User views a report
    Given Meeting exists with last occurrence link code "1234567890"
    And Meeting organizer exists
    And "6" participants answered a survey
    And "3" participants refused a survey
    And "4" participants skipped a survey
    Then I navigate to "/report/1234567890"
    And I should see on the page "Welcome! So far 6 out of 13 meeting participants have responded."
    And I should see a list of absent participants
    And I should see a list of skipped participants
    And wait 5 seconds

#    When Report data exists with link code "1234567890"
#    And I navigate to "/report/1234567890"
#    Then I should see on the page "Was this meeting relevant to you?"