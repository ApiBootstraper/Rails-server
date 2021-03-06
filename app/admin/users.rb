ActiveAdmin.register User do

  menu :priority => 2

  # Batch actions
  batch_action :enable do |selection|
    User.find(selection).each {|user| user.enable! }
    redirect_to collection_path, :notice => "Users enabled!"
  end
  batch_action :disable do |selection|
    User.find(selection).each {|user| user.disable! }
    redirect_to collection_path, :notice => "Users disabled!"
  end
  batch_action :destroy, false

  # Scopes
  scope :all, :default => true
  scope :enabled
  scope :disabled

  # Fitlers
  filter :uuid
  filter :email
  filter :username
  filter :is_enable
  filter :enabled_at
  filter :current_sign_in_ip
  filter :last_sign_in_ip
  filter :created_at
  filter :updated_at
  filter :reset_password_send_at
  filter :remember_created_at
  filter :sign_in_at

  # Index view
  index do
    selectable_column
    column("UUID")   {|u| link_to "#{u.uuid}", admin_user_path(u) }
    column("Username", :sortable => :name) {|u| link_to "#{u.username}", admin_user_path(u) }
    column :email
    column("Active")                               {|u| status_tag(u.is_enable? ? "Yes" : "No", u.is_enable? ? "ok" : "error") }
    column("Created at", :sortable => :created_at) {|u| l(u.created_at, :format => :short) }
    column("Updated at", :sortable => :updated_at) {|u| l(u.updated_at, :format => :short) }
    default_actions
  end

  # Form view
  form do |f|
    f.inputs do
      f.input :email,    :as => :string
      f.input :username, :as => :string
      f.input :password, :as => :string
      f.input :enable,   :as => :boolean, :label => "Activate"
    end
    f.buttons
  end

  # TODO: Custom details view

end
