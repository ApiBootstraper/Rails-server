source 'http://rubygems.org'

gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'versionist'
gem 'uuid'

gem 'devise'
gem 'devise-encryptable'
gem 'session_off'

gem 'activeadmin'
gem 'cancan'

gem 'kaminari'

# Database searcg gems
# gem 'meta_search'
# gem 'texticle', "2.0", :require => 'texticle/rails' # Only for PgSQL DB

# Famous APM - http://newrelic.com/
# gem 'newrelic_rpm'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

# If you want use rspec instead of the Tests of ActiveSupport
group :test do
  gem 'rspec-rails'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end

# Include database gems for the adapters found in the database
# configuration file
# (Found on redmine.org Gemfile)
require 'erb'
database_file = File.join(File.dirname(__FILE__), "config/database.yml")
if File.exist?(database_file)
  database_config = YAML::load(ERB.new(IO.read(database_file)).result)
  adapters = database_config.values.map {|c| c['adapter']}.compact.uniq
  if adapters.any?
    adapters.each do |adapter|
      case adapter
      when /mysql/
        gem "mysql", "~> 2.8.1", :platforms => [:mri_18, :mingw_18]
        gem "mysql2", "~> 0.3.11", :platforms => [:mri_19, :mingw_19]
        gem "activerecord-jdbcmysql-adapter", :platforms => :jruby
      when /postgresql/
        gem "pg", ">= 0.11.0", :platforms => [:mri, :mingw]
        gem "activerecord-jdbcpostgresql-adapter", :platforms => :jruby
      when /sqlite3/
        gem "sqlite3", :platforms => [:mri, :mingw]
        gem "activerecord-jdbcsqlite3-adapter", :platforms => :jruby
      when /sqlserver/
        gem "tiny_tds", "~> 0.5.1", :platforms => [:mri, :mingw]
        gem "activerecord-sqlserver-adapter", :platforms => [:mri, :mingw]
      else
        warn("Unknown database adapter `#{adapter}` found in config/database.yml, use Gemfile.local to load your own database gems")
      end
    end
  else
    warn("No adapter found in config/database.yml, please configure it first")
  end
else
  warn("Please configure your config/database.yml first")
end
