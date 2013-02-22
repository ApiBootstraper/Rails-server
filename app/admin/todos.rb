ActiveAdmin.register Todo do

  menu :priority => 3

  # Batch actions
  batch_action :accomplish do |selection|
    Todo.find(selection).each do |todo|
      todo.is_accomplished = true
      todo.save!
    end
    redirect_to collection_path, :notice => "Todos accomplished!"
  end
  batch_action :unaccomplish do |selection|
    Todo.find(selection).each do |todo|
      todo.is_accomplished = false
      todo.save!
    end
    redirect_to collection_path, :notice => "Todos unaccomplished!"
  end
  batch_action :destroy, false

  # Scopes
  scope :all, :default => true
  scope :accomplished do |todos|
    todos.where("accomplished_at IS NOT NULL")
  end
  scope :not_accomplished do |todos|
    todos.where("accomplished_at IS NULL")
  end

  # Index view
  index do
    selectable_column
    column("\#", :sortable => :id)     {|t| link_to "#{t.id}", admin_admin_user_path(t) }
    column("Name", :sortable => :name) {|t| link_to "#{t.name}", admin_admin_user_path(t) }
    column("Accomplished", :sortable => :accomplished_at) {|t| status_tag(t.is_accomplished? ? "Yes" : "No", t.is_accomplished? ? "ok" : "error") }
    column("Created at", :sortable => :created_at)        {|t| l(t.created_at, :format => :short) }
    column("Updated at", :sortable => :updated_at)        {|t| l(t.updated_at, :format => :short) }
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
