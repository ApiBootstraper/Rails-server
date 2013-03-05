# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Create a default user
AdminUser.create!(:email => 'admin@apibootstraper.com', :password => 'password', :password_confirmation => 'password')
User.create!(:email => 'user@apibootstraper.com', :password => 'password', :password_confirmation => 'password', :username => 'demo')

Application.create!(:name => 'Demo Application') # Add this in Rails4 -- :is_enable => true)
