# == Schema Information
#
# Table name: admin_users
#
#  id                     :integer(4)      not null, primary key
#  email                  :string          not null
#  encrypted_password     :string          nit null
#  reset_password_token   :datetime
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#
class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
end
