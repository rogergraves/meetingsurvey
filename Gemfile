source 'https://rubygems.org'
ruby '2.1.3'

gem 'rails', '~> 4.1.6'
gem "unicorn", "~> 4.7.0"                             # Webserver recommended by heroku (for increased scaling)
gem "unicorn-rails", "~> 1.1.0"                       # Makes unicorn the default rails server
gem 'pg', '~> 0.17.1'                                 # Postgres ruby driver
gem 'sass-rails', '~> 4.0.4'
gem 'uglifier', '~> 2.5.3'                            # Ruby wrapper for UglifyJS JavaScript compressor.
gem 'coffee-rails', '~> 4.0.1'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'heroku', '~> 3.6.0'                              # Heroku deployments and tools
gem 'devise', '~> 3.4.1'                              # Flexible authentication solution
gem 'mailman', '~> 0.7.2', require: false             # Mailman makes it easy to process incoming emails with a simple routing DSL
gem 'ics', '~> 0.2.1', require: false                 # Gem for parsing ICS files
gem "therubyracer", '~> 0.12.1'                       # Needed for twitter bootstrap
gem "less-rails", '~> 2.6.0'                          # Needed for twitter bootstrap
gem "twitter-bootstrap-rails", '~> 3.2.0'             # Is twitter bootstrap
gem 'activeadmin', github: 'gregbell/active_admin'    # The administration framework for Ruby on Rails

group :production do
  gem "rails_12factor", "~> 0.0.2"                    # Helps speed up deploys on heroku
end

group :development do
  gem "git-smart", "~> 0.1.10"                        # Allows "git smart-pull" for less merge messes
end

group :development, :test do
  gem "awesome_print"                                 # Nicely formatted data structures in console, for example "ap User.first"
  gem 'faker', '~> 1.4.3'                             # Makes random text for tests and factories: https://github.com/stympy/faker
end

group :test do
  gem 'shoulda-matchers', '~> 2.7.0', require: false  # Collection of testing matchers extracted from Shoulda http://thoughtbot.com/community
  gem 'rspec-rails', '~> 3.0.2'                       # https://www.relishapp.com/rspec/rspec-rails/docs/gettingstarted
  gem 'rspec-activemodel-mocks', '~> 1.0.1'           # RSpec test doubles for ActiveModel and ActiveRecord
  gem 'capybara', '~> 2.4.4'                          # Acceptance test framework for web applications http://jnicklas.github.com/capybara/
  gem 'database_cleaner', '~> 1.3.0'                  # database_cleaner is not required, but highly recommended
  gem 'selenium-webdriver', '~> 2.43.0'               # https://code.google.com/p/selenium/
  gem 'capybara-firebug', '~> 2.0.0'                  # Provides a dead-simple way to run scenarios with Firebug enabled under the selenium driver https://github.com/jfirebaugh/capybara-firebug
  gem 'cucumber-rails', '~> 1.4.0', require: false    # Cucumber Generator and Runtime for Rails
  gem 'factory_girl_rails', '~> 4.5.0'                # https://github.com/thoughtbot/factory_girl_rails
end

