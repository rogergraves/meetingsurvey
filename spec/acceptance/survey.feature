Feature: Survey testing

  Background:
    Given A survey invite exists with link code "1234567890"

  @selenium
  Scenario: User indicates that they didn't attend a meeting
    When I navigate to "/survey/1234567890/refuse_attendance"
    Then I should see on the page "Thank you!"
    And Field "confirmed_attendance" for survey invite with link code "1234567890" should be "false"

  @selenium
  Scenario: User indicates that they attended a meeting
    When I navigate to "/survey/1234567890/confirm_attendance"
    Then I should see on the page "Was this meeting relevant to you?"
    And Field "confirmed_attendance" for survey invite with link code "1234567890" should be "true"

  @selenium
  Scenario: User answers a survey
    When I navigate to "/survey/1234567890"
    Then I should see on the page "Was this meeting relevant to you?"
    When I click on radio button "answer_1_yes"
    And I enter into "answer_1_why" text "Because"
    And I click the link "answer_1_next"
    And I click on radio button "answer_2_no"
    And I click the link "answer_2_next"
    And I click on radio button "answer_3_yes"
    And I click the link "answer_3_next"
    And I click on radio button "answer_4_yes"
    And I click the link "answer_4_next"
    And I click on radio button "answer_5_yes"
    And I click the link "answer_5_next"
    And I enter into "answer_6" text "Cool meeting!"
    And I click the link "submit"
    And I wait for 1 seconds
    Then The user for the invite with link code "1234567890" should have a survey answer with question "Was this meeting relevant to you?" answer "yes" and why "Because"
    And The user for the invite with link code "1234567890" should have a survey answer with question "Was the purpose of this meeting clear?" answer "no" and no why
    And The user for the invite with link code "1234567890" should have a survey answer with question "Any other feedback?" with why "Cool meeting!"

  @selenium
  Scenario: User answers a survey two times
    When I navigate to "/survey/1234567890"
    Then I should see on the page "Was this meeting relevant to you?"
    When I click on radio button "answer_1_yes"
    And I enter into "answer_1_why" text "Because"
    And I click the link "answer_1_next"
    And I click on radio button "answer_2_no"
    And I click the link "answer_2_next"
    And I click on radio button "answer_3_yes"
    And I click the link "answer_3_next"
    And I click on radio button "answer_4_yes"
    And I click the link "answer_4_next"
    And I click on radio button "answer_5_yes"
    And I click the link "answer_5_next"
    And I enter into "answer_6" text "Cool meeting!"
    And I click the link "submit"
    And I wait for 1 seconds
    Then The user for the invite with link code "1234567890" should have a survey answer with question "Was this meeting relevant to you?" answer "yes" and why "Because"
    And The user for the invite with link code "1234567890" should have a survey answer with question "Was the purpose of this meeting clear?" answer "no" and no why
    And The user for the invite with link code "1234567890" should have a survey answer with question "Any other feedback?" with why "Cool meeting!"
    
    When I navigate to "/survey/1234567890"
    Then I should see on the page "Was this meeting relevant to you?"
    When I click on radio button "answer_1_no"
    And I click the link "answer_1_next"
    And I click on radio button "answer_2_yes"
    And I click the link "answer_2_next"
    And I click on radio button "answer_3_no"
    And I click the link "answer_3_next"
    And I click on radio button "answer_4_no"
    And I enter into "answer_4_why" text "Hello"
    And I click the link "answer_4_next"
    And I click on radio button "answer_5_no"
    And I click the link "answer_5_next"
    And I enter into "answer_6" text "Super meeting!"
    And I click the link "submit"
    And I wait for 1 seconds
    Then The user for the invite with link code "1234567890" should have a survey answer with question "Was this meeting relevant to you?" answer "no" and no why
    And The user for the invite with link code "1234567890" should have a survey answer with question "Did this meeting have good communication?" answer "yes" and why "Hello"
    And The user for the invite with link code "1234567890" should have a survey answer with question "Any other feedback?" with why "Super meeting!"