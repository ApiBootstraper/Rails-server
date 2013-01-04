class Api::V010::UsersController < Api::V010::BaseController
  skip_before_filter :authenticate_user!, :only => [:create, :verify_availability]
  skip_before_filter :http_authenticate, :only => [:create, :verify_availability]

  #
  # Create a new user
  #
  def create
    user = User.new params_filter(params[:user], [:username, :password, :email])

    if user.save!
      # Tell the UserMailer to send a welcome Email after save
      UserMailer.welcome_email(user).deliver

      respond_with({:user => @presenter.single_for_current_user(user)}, :status => {:msg => "User created", :code => 201})
    else
      respond_with({:errors => user.errors}, :status => {:msg => "User can't be created", :code => 400})
    end
  end

  #
  # Show user by UUID
  #
  def show
    user = User.find_by_uuid!(params[:uuid])
    respond_with({:user => @presenter.single(user)})
  end

  #
  # Show current user
  #
  def show_current_user
    respond_with({:user => @presenter.single_for_current_user(current_user)})
  end

  #
  # Update current user
  #
  def update_current_user
    if current_user.update_attributes! params_filter(params[:user], [:password, :email])
      respond_with({:user => @presenter.single_for_current_user(current_user)}, :code => 200)
    else
      respond_with(nil, :status => {:msg => "Current User can't be updated", :code => 400})
    end
  end

  #
  # Search users
  #
  def search
    # TODO verify limit of length
    if params[:q].blank?
      respond_with(nil, :status => {:msg => "Query can't be blank", :code => 400})
      return
    end
    users = User.search(:username_contains => params[:q]).page(params[:page])
    respond_with({:total => users.total_count, :page => users.current_page, :query => params[:q], :users => @presenter.collection(users)})
  end

  #
  # Verify availability
  #
  def verify_availability
    # TODO verify limit of length
    if params[:username].blank?
      respond_with(nil, :status => {:msg => "Username can't be blank", :code => 400})
      return
    end
    user = User.find_by_username(params[:username])
    available = user.nil? ? true : false
    respond_with({:username => params[:username], :available => available})
  end

end
