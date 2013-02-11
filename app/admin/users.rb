ActiveAdmin.register User do
  menu :priority => 2

  scope :all, :default => true
  scope :enabled
  scope :disabled

  # Listing view
  index do
    column("UUID")   {|u| link_to "#{u.uuid}", admin_user_path(u) }
    column("Username", :sortable => :name)  {|u| link_to "#{u.username}", admin_user_path(u) }
    column :email
    column("Active?")                              {|u| u.is_enable? ? "YES" : "NO" }
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

end
