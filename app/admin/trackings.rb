ActiveAdmin.register Tracking do

  menu :parent => "+"
  actions :index, :show

  # Batch actions
  batch_action :destroy, false

  # Fitlers
  filter :user, :as => :select, :input_html => { :multiple => true }
  filter :application, :as => :select, :input_html => { :multiple => true }
  filter :uuid
  filter :request
  filter :method, :as => :select, :input_html => { :multiple => true }, :collection => [:get, :post, :put, :patch, :delete]
  filter :code
  filter :ip
  filter :version
  filter :created_at
  filter :updated_at

  # Index view
  index do
    column("UUID")  {|t| link_to "#{t.uuid[0,7]}...", admin_tracking_path(t), :title => t.uuid }
    column :request
    column :method
    column :code
    column("ver.")   {|t| link_to "#{t.version}", admin_trackings_path(:q => {:version_contains => t.version}) }
    column("IP")  {|t| link_to "#{t.remote_ip}", admin_trackings_path(:q => {:remote_ip_contains => t.remote_ip}) }
    column :user
    column :application
    column("")    {|t| "#{l( t.created_at, :format => :short )}" }
  end

end
