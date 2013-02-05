ApiBootstraper::Application.routes.draw do

  # ------------------------------------------------------------------------------------------------
  # ApiVersions
  #
  scope :module => "api" do

    # --------------------------------------------------------------------------
    # V0.1.0
    #
    api_version :module => "V1__0__0",
                :header => {:name => "X-Api-Version", :value => "1.0.0"} do

      # Devise Controllers
      devise_for :users, :skip => :all

      # UsersController
      post "/user"                => "users#create"

      get  "/user/:uuid"          => "users#show", :constraints => {:uuid => /[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/}
      get  "/user/search"         => "users#search"
      get  "/user/my"             => "users#show_current_user"
      put  "/user/my"             => "users#update_current_user"
      get  "/user/availability"   => "users#verify_availability"

      # TodosController
      get    "/todo/my"           => "todos#show_current_user_todos"
      post   "/todo"              => "todos#create"
      get    "/todo/:uuid"        => "todos#show",                  :constraints => {:uuid => /[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/}
      put    "/todo/:uuid"        => "todos#update",                :constraints => {:uuid => /[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/}
      put    "/todo/:uuid/:state" => "todos#change_accomplishment", :constraints => {:uuid => /[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/,
                                                                                     :state => /(check|uncheck)/}
      delete "/todo/:uuid"        => "todos#destroy",               :constraints => {:uuid => /[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/}
      get    "/todo/search"       => "todos#search"

      # Not found API route
      match "/*path" => "default#not_found", :module => "api"
    end
    # --------------------------------------------------------------------------

  end
  # ------------------------------------------------------------------------------------------------



  # ------------------------------------------------------------------------------------------------
  # ActiveAdmin routes
  #
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config
  # ------------------------------------------------------------------------------------------------

  # Not found
  match "/*path" => "default#not_found"#, :constraints => {:path => /(.*)+/i}
  root :to => "default#not_found"

end
