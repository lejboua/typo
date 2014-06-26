Feature: Create Categories
  As a blog administrator
  In order to organize my thoughts
  I want to be able to create categories to use in my blog

  Background:
    Given the blog is set up
    And I am logged into the admin panel

  Scenario: Successfully create categories
    Given I am on the admin page
    When I go to the categories page
    And I fill in "category_name" with "category1"
    And I fill in "category_permalink" with "permalink1"
    And I fill in "category_description" with "description1"
    And I press "Save"
    Then I should be on the categories page
    And I should see "category1"
    And I should see "permalink1"
    And I should see "description1"
