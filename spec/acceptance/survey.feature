Feature: Survey testing

#  @selenium
#  Scenario:
#    Given Setup data
#    Then Visit survey
#    Then Fill up and submit survey form
#    Then Verify that data was saved successfully in the database

  Scenario: Receive meeting invite by email
    Given Receive email
    Then Open email and click 'I Attended'