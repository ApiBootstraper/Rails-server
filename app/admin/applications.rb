ActiveAdmin.register Application do

  menu :parent => "+"

  # Batch actions
  batch_action :enable do |selection|
    Application.find(selection).each {|application| application.enable! }
    redirect_to collection_path, :notice => "Applications enabled!"
  end
  batch_action :disable do |selection|
    Application.find(selection).each {|application| application.disable! }
    redirect_to collection_path, :notice => "Applications disabled!"
  end
  batch_action :destroy, false

  # Custom actions
  member_action :generate_token, :method => :put do
    application = Application.find(params[:id])
    application.regenerate_app_key!
    redirect_to :action => :show, :notice => "App Key regenerated!"
  end

  # Scopes
  scope :all, :default => true
  scope :enabled
  scope :disabled

  # Index view
  index do
    selectable_column
    column("Name", :ordering => :name) {|a| link_to "#{a.name}", admin_application_path(a) }
    column("App Id")                   {|a| a.app_id }
    column("App Key")                  {|a| a.app_key }
    column("Active?")                              {|a| status_tag(a.is_enable? ? "Yes" : "No", a.is_enable? ? "ok" : "error") }
    column("Created at", :sortable => :created_at) {|a| l(a.created_at, :format => :short) }
    column("Updated at", :sortable => :updated_at) {|a| l(a.updated_at, :format => :short) }
    default_actions
  end

  # Form view
  form do |f|
    f.inputs do
      f.input :name,    :as => :string
      f.input :comment, :as => :text
      f.input :enable,  :as => :boolean, :label => "Activate"
    end
    f.buttons
  end

  action_item :only => [:show, :edit] do
    link_to "Regenerate App Key", generate_token_admin_application_path, :confirm => "Are you sure?", :method => :put
  end

  # TODO: Custom details view

end
