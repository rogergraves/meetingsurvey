source 'https://rubygems.org'
ruby '2.1.3'

gem 'rails', '4.1.6'
gem "unicorn", "~> 4.7.0"                             # Webserver recommended by heroku (for increased scaling)
gem "unicorn-rails", "~> 1.1.0"                       # Makes unicorn the default rails server
gem 'pg', '~> 0.17.1'                                 # Postgres ruby driver
gem 'sass-rails', '~> 4.0.1'
gem "uglifier", "~> 2.4.0"                            # Ruby wrapper for UglifyJS JavaScript compressor.
gem 'coffee-rails', '~> 4.0.1'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'heroku', '~> 3.6.0'                              # Heroku deployments and tools
gem 'devise', '~> 3.4.1'                              # Flexible authentication solution

group :production do
  gem "rails_12factor", "~> 0.0.2"                    # Helps speed up deploys on heroku
end

group :development do
  gem "awesome_print"                                 # Nicely formatted data structures in console, for example "ap User.first"
  gem "git-smart", "~> 0.1.10"                        # Allows "git smart-pull" for less merge messes
end

group :test do
  gem 'rspec-rails', '~> 3.0.0'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'shoulda-matchers', require: false
  gem 'database_cleaner', '~> 1.3.0'
end

