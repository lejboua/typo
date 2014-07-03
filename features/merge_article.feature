Feature: Merge Articles
  As a blog administrator
  In order to avoid multiple similar articles
  I want to be able to merge two articles

  Background:
    Given the blog is set up
    And the following users exist
        | id | name     |
        | 4  | Legolas  |
        | 5  | Frodo    |
#   And the following naive articles exist
#       | id | title    | body          |
#       | 3  | Foobar   | Lorem Ipsum   |
#       | 4  | Foobar 2 | Lorem Ipsum 2 |
    And the following articles exist
        | id | title    | body          | user     |
        | 3  | Foobar   | Lorem Ipsum   | Legolas  |
        | 4  | Foobar 2 | Lorem Ipsum 2 | Frodo    |

# Scenario: Successfully merge articles (merged article contains the text of both previous articles)
  Scenario: When articles are merged, the merged article should contain the text of both previous articles
    Given I am logged into the admin panel
    And I am on the article page for "Foobar"
    And I fill in "merge_with" with the id of the article with title "Foobar 2"
    And I press "Merge"
    # 2. When articles are merged, the merged article should contain the
    # text of both previous articles.
    Then the article "Foobar" should have body "Lorem Ipsum Lorem Ipsum 2"
    # 3. When articles are merged, the merged article should have one author
    # (either one of the authors of the original article).
    And I should be on the admin index page

  Scenario: Successfully merge articles (merged article has one author - author from one of the original articles)
    Given I am logged into the admin panel
    And I am on the article page for "Foobar"
    And I fill in "merge_with" with the id of the article with title "Foobar 2"
    And I press "Merge"
    # 3. When articles are merged, the merged article should have one author
    # (either one of the authors of the original article).
    Then the article "Foobar" should have author "Legolas"
    And I should be on the admin index page

  Scenario: Successfully merge articles (comments on each of the two original articles need to carry over and point to the new, merged article.)
    Given I am logged into the admin panel
    And I am on the article page for "Foobar"
    And I fill in "merge_with" with the id of the article with title "Foobar 2"
    And I press "Merge"
    # 4. Comments on each of the two original articles need
    # to all carry over and point to the new, merged article.
    Then the article "Foobar" should have author "Legolas"
    And I should be on the admin index page

  Scenario: A non-admin cannot merge two articles
    Given I am logged in as "Frodo" into the admin panel
    # And show me the page
    And I am on the article page for "Foobar"
    Then the "merge_with" field should not exist
    Then I should not see a field "merge_with"
