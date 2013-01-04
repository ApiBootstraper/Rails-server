class Application < ActiveRecord::Base

  # Hooks
  before_create :before_create

  # Protect datas
  attr_accessible :app_id, :app_key, :name, :comment, :enable

  # Validators
  validates :name,  :presence => true,
                    :uniqueness => true

  # Named Scopes
  scope :enabled,  lambda{ where("is_enable = ?", true) }
  scope :disabled, lambda{ where("is_enable != ?", true) }


  def regenerate_app_key!
    chars = ['A'..'Z', 'a'..'z', '0'..'9'].map{|r|r.to_a}.flatten
    self.app_key = get_token(32)
    self.save!
  end

  # Enable / Disable entity
  def enable=(value); self.is_enable = value end
  def enable; self.is_enable end
  def is_enable?; self.is_enable ? true : false end

  def enable!
    self.enable = true
    self.save!
  end

  def disable!
    self.enable = false
    self.save!
  end

private
  def before_create
    self.app_id  = get_token(16)
    self.app_key = get_token(32)
  end

  def get_token(length=16)
    chars = ['A'..'Z', 'a'..'z', '0'..'9'].map{|r|r.to_a}.flatten
    Array.new(length).map{chars[rand(chars.size)]}.join
  end
end
