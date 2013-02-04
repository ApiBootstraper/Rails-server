ActiveAdmin.register Todo do
  menu :priority => 3

  scope :all, :default => true
  scope :accomplished do |todos|
    todos.where("accomplished_at IS NOT NULL")
  end
  scope :not_accomplished do |todos|
    todos.where("accomplished_at IS NULL")
  end

  # Listing view
  index do
    column("\#", :sortable => :id)      {|t| link_to "#{t.id}", admin_admin_user_path(t) }
    column("Name", :sortable => :name)  {|t| link_to "#{t.name}", admin_admin_user_path(t) }
    column("Accomplished", :sortable => :accomplished_at)  {|t| t.is_accomplished? ? "Yes" : "No" }
    column("Created at", :sortable => :created_at)         {|t| l(t.created_at, :format => :short) }
    column("Updated at", :sortable => :updated_at)         {|t| l(t.updated_at, :format => :short) }
    default_actions
  end

  # Form view
  form do |f|
    f.inputs do
      f.input :name,            :as => :string
      f.input :description
      f.input :user
      f.input :is_accomplished, :as => :boolean
    end
    f.buttons
  end
end
