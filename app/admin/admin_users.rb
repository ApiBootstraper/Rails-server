ActiveAdmin.register AdminUser do
  menu :parent => "+"
  # actions :index, :show, :edit, :update, :destroy

  # Listing view
  index do
    column("\#", :sortable => :id)      {|u| link_to "#{u.id}", admin_admin_user_path(u) }
    column("Name", :sortable => :name)  {|u| link_to "#{u.email}", admin_admin_user_path(u) }
    column("Created at", :sortable => :created_at) {|u| l(u.created_at, :format => :short) }
    column("Updated at", :sortable => :updated_at) {|u| l(u.updated_at, :format => :short) }
    default_actions
  end

  # Form view
  form do |f|
    f.inputs do
      f.input :email,       :as => :string
      f.input :password,    :as => :password
    end
    f.buttons
  end

end
