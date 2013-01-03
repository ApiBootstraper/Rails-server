RailsRestApiBootstrap::Application.routes.draw do

  # -----------------------------------------------------------------------------------------------------------------------------------------
  # ActiveAdmin routes
  #
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config
  # -----------------------------------------------------------------------------------------------------------------------------------------

  # Not found
  match "/*path" => "default#not_found", :constraints => {:path => /(.*)+/i}
  root :to => "default#not_found"

end
