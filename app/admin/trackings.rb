ActiveAdmin.register Tracking do
  menu :parent => "+"
  actions :index, :show

  # Index
  index do
    column("UUID")  {|t| link_to "#{t.uuid}", admin_tracking_path(t) }
    column :request
    column :method
    column :code
    column("IP")  {|t| link_to "#{t.remote_ip}", admin_trackings_path(:q => {:remote_ip_contains => t.remote_ip}) }
    column :user
    column :application
    column("")    {|t| "#{l( t.created_at, :format => :short )}" }
  end

end
