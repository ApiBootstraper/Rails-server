class Todo < ActiveRecord::Base
  attr_accessible :accomplished_at, :name, :user, :uuid
end
