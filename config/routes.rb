ApiBootstraper::Application.routes.draw do

  # ------------------------------------------------------------------------------------------------
  # ApiVersions
  #
  scope :module => "api" do

    # --------------------------------------------------------------------------
    # V1.0.0
    #
    api_version :module => "V1__0__0",
                :header => {:name => "X-Api-Version", :value => "1.0.0"} do

      # Devise Controllers
      devise_for :users, :skip => :all

      # UsersController
      post "/users"                => "users#create"

      get  "/users/:uuid"          => "users#show", :constraints => {:uuid => /[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/}
      get  "/users/search"         => "users#search"
      get  "/users/my"             => "users#show_current_user"
      put  "/users/my"             => "users#update_current_user"
      get  "/users/availability"   => "users#verify_availability"

      # TodosController
      get    "/todos/my"           => "todos#show_current_user_todos"
      post   "/todos"              => "todos#create"
      get    "/todos/:uuid"        => "todos#show",                  :constraints => {:uuid => /[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/}
      put    "/todos/:uuid"        => "todos#update",                :constraints => {:uuid => /[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/}
      put    "/todos/:uuid/:state" => "todos#change_accomplishment", :constraints => {:uuid => /[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/,
                                                                                     :state => /(check|uncheck)/}
      delete "/todos/:uuid"        => "todos#destroy",               :constraints => {:uuid => /[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/}
      get    "/todos/search"       => "todos#search"

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
