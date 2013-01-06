class Todo < ActiveRecord::Base
  # Associations
  belongs_to :user

  # Accessors
  attr_accessible :name, :user, :accomplished_at

  # Hooks
  before_create :before_create

  # Validators
  validates :uuid, :uniqueness => true
  validates :name, :presence => true
  validates :user, :presence => true

  def accomplished?; !self.accomplished_at.nil? end

private
  def before_create
    self.uuid = UUID.generate
  end
end
