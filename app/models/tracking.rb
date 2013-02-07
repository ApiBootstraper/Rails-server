class Tracking < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :application

  # Accessors
  attr_accessible :uuid, :request, :method, :remote_ip, :version, :code, :request,
                  :application, :user

  # Validators
  validates :uuid,      :uniqueness => true
end
