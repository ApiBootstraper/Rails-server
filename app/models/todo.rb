class Todo < ActiveRecord::Base
  include ModelExtensions::Paginable

  # Associations
  belongs_to :user # TODO change the local name to author ?

  # Accessors
  attr_accessible :name, :description, :user, :is_accomplished

  # Hooks
  before_create :before_create

  # Validators
  validates :uuid, :uniqueness => true
  validates :name, :presence => true
  validates :user, :presence => true

  # Named Scopes
  scope :accomplished,   lambda{ where("is_accomplished = ?", true) }
  scope :unaccomplished, lambda{ where("is_accomplished != ?", true) }

  def is_accomplished= state
    if state === true && ! (is_accomplished? === true)
      self.accomplished_at = Time.now
    elsif ! (state === true) && (is_accomplished? === true)
      self.accomplished_at = nil
    end
  end
  def is_accomplished; is_accomplished? end
  def is_accomplished?; !self.accomplished_at.nil? end

private
  def before_create
    self.uuid = UUID.generate
  end
end
