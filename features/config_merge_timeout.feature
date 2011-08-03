@test_unit @rspec @merging @config
Feature: 

  The maximum time between resultset merges can be customized
  using SimpleCov.merge_timeout SECONDS. This can be helpful for
  long-running test-suites that fail to merge because of the time
  between individual suite finishes is more then the default timeout
  of 10 minutes.
  
  Here, for the sake of testing the opposite case is shown, choosing
  a merge timeout so short that the first test suite's results actually
  are out of date when the second suite finishes and thus does not end up
  in the report.

  Scenario:
    Given I cd to "project"
    Given a file named "test/simplecov_config.rb" with:
      """
      require 'simplecov'
      SimpleCov.start do
        merge_timeout 1
      end
      """
    And a file named "spec/simplecov_config.rb" with:
      """
      require 'simplecov'
      SimpleCov.start do
        merge_timeout 1
      end
      """
      
    When I successfully run `bundle exec rake test`
    Then a coverage report should have been generated

    Given I open the coverage report
    Then the report should be based upon:
      | Unit Tests |
    
    When I successfully run `bundle exec rspec spec`
    Then a coverage report should have been generated
      
    Given I open the coverage report
    Then the report should be based upon:
      | RSpec |
