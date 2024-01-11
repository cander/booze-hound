ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

def open_html_fixture(file_name)
  # Assume our HTML fixtures are under the first path in fixture_paths
  IO.read("#{ActiveSupport::TestCase.fixture_paths.first}/html/#{file_name}")
end
