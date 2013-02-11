class Api::V100::UsersController < Api::V100::BaseController
  skip_before_filter :authenticate_user!, :only => [:create, :verify_availability]
  skip_before_filter :http_authenticate, :only => [:create, :verify_availability]

  # Create a new user
  # POST /users
  def create
    user = User.new params_filter(params[:user], [:username, :password, :email])

    if user.save!
      UserMailer.welcome_email(user).deliver
      return respond_with({:user => @presenter.single_for_current_user(user)}, :status => {:msg => "User created", :code => 201})
    end
    respond_with({:errors => user.errors}, :status => {:msg => "User can't be created", :code => 400})
  end

  # Show user by UUID
  # GET /users/:uuid
  def show
    user = User.enabled.includes(:todos).find_by_uuid!(params[:uuid])
    respond_with({:user => @presenter.single(user)})
  end

  # Show current user
  # GET /users/my
  def show_current_user
    user = User.includes(:todos).find(current_user.id)
    respond_with({:user => @presenter.single_for_current_user(user)})
  end

  # Update current user
  # PUT /users/my
  def update_current_user
    if current_user.update_attributes! params_filter(params[:user], [:password, :email])
      return respond_with({:user => @presenter.single_for_current_user(current_user)}, :code => 200)
    end
    respond_with(nil, :status => {:msg => "Current User can't be updated", :code => 400})
  end

  # Search users
  # GET /users/search?q=
  def search
    return respond_with(nil, :status => {:msg => "Query can't be blank", :code => 400})     if params[:q].blank?
    return respond_with(nil, :status => {:msg => "Query length must be > 3", :code => 400}) if params[:q].length < 3

    offset, limit = api_offset_and_limit
    users = User.enabled
                .search(:username_or_email_contains => params[:q])
                .order('updated_at DESC')
                .offset(offset).limit(limit)

    respond_with({:total => users.total_count, :limit => limit, :offset => offset, :query => params[:q], :users => @presenter.collection(users)})
  end

  # Verify availability
  # GET /users/availability?username=
  def verify_availability
    return respond_with(nil, :status => {:msg => "Username can't be blank", :code => 400})  if params[:username].blank?
    return respond_with(nil, :status => {:msg => "Query length must be > 3", :code => 400}) if params[:username].length < 3

    user      = User.find_by_username(params[:username])
    available = user.nil? ? true : false
    respond_with({:username => params[:username], :available => available})
  end
end
