Feature: Make sure user interface is pretty

  @selenium
  Scenario: Main page should include text 'Coming Soon!'
    Given I am on the main page
    Then I see 'Coming Soon!' text

  @selenium
  Scenario: I see 'Meeting not found' if I go to survey url with wrong link_code
    Given I visit survey wrong with wrong link_code
    Then I see 'Meeting not found' text