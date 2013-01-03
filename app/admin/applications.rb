ActiveAdmin.register Application do

  # Index
  index do
    column("Name", :ordering => :name)  {|a| link_to "#{a.name}", admin_application_path(a) }
    column("App Id")                    {|a| a.app_id }
    column("App Key")                   {|a| a.app_key }
    column("Active?")                   {|a| a.is_enable? ? "YES" : "NO" }
    column("Created at", :sortable => :created_at)  {|a| l(a.created_at, :format => :short) }
    column("Updated at", :sortable => :updated_at)  {|a| l(a.updated_at, :format => :short) }
    default_actions
  end

  # Form view
  form do |f|
    f.inputs do
      f.input :name,     :as => :string
      f.input :comment,  :as => :text
      f.input :enable,   :as => :boolean, :label => "Activate"
    end
    f.buttons
  end

  action_item :only => [:show, :edit] do
    link_to "Regenerate App Key", generate_token_admin_application_path, :confirm => "Are you sure?", :method => :put
  end

  member_action :generate_token, :method => :put do
    application = Application.find(params[:id])
    application.regenerate_app_key!
    flash[:notice] = "App Key regenerated!"
    redirect_to :action => :show
  end

end
