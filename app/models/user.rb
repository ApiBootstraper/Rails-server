class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable and :omniauthable
  devise :database_authenticatable, :token_authenticatable, :registerable, :encryptable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :username, :enable

  # Hooks
  before_create :before_create

  # Validators
  validates :uuid,      :uniqueness => true
  validates :username,  :presence => true,
                        :uniqueness => true,
                        :format => {:with => /^[A-Za-z\d_-]+$/, :message => "can only be alphanumeric with no spaces"}
  validates :email,     :presence => true,
                        :uniqueness => true

  validates :password,  :presence => true, :on => :create

  # Named Scopes
  scope :enabled,  lambda{ where("is_enable = ?", true) }
  scope :disabled, lambda{ where("is_enable != ?", true) }


  # API V0.1.0 // Verify Authenticate
  def self.api_v010_is_correct_user?(email, password)
    user = self.find_by_email(email.downcase)
    if user and user.valid_password?(password)
      return user
    end
    return false
  end

  # API V0.1.1 // Verify Authenticate
  def self.api_v011_is_correct_user?(email, password)
    user = self.find_by_email(email.downcase)
    if user and user.valid_password?(password)
      return user
    end
    return false
  end


  # Enable / Disable entity
  def enable=(value)
    self.is_enable = value
    self.enabled_at = Time.now
  end
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
    self.uuid   = UUID.generate
    self.enable = true
  end

end
