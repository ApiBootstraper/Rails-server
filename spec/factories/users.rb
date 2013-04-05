# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :user do
    email    { Faker::Internet.email }
    username { Faker::Internet.user_name }
    password { Faker::Lorem.characters(20) }
  end
end
