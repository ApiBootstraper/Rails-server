class Api::V100::TodosController < Api::V100::BaseController

  # Create a new Todo
  # POST /todos
  def create
    todo = Todo.new(params_filter(params[:todo], [:name, :description]))
    todo.user = current_user

    if todo.save!
      return respond_with({:todo => @presenter.single(todo)}, :status => {:msg => "Todo created", :code => 201})
    end
    respond_with({:errors => todo.errors}, :status => {:msg => "Todo can't be created", :code => 400})
  end

  # Show Todo
  # GET /todos/:uuid
  def show
    todo = Todo.find_by_uuid!(params[:uuid])
    return respond_with(nil, :status => {:msg => "You are not the author of this todo, you can't show it", :code => 403}) unless current_user === todo.user

    respond_with({:todo => @presenter.single(todo)})
  end

  # Get todos of current user
  # GET /todos/my
  def show_current_user_todos
    offset, limit = api_offset_and_limit
    todos = Todo.where("user_id = ?", current_user.id)
                .order("updated_at DESC")
                .offset(offset).limit(limit)

    respond_with({:total => todos.total_count, :limit => limit, :offset => offset, :todos => @presenter.collection(todos)})
  end

  # Update Todo
  # PUT /todos/:uuid
  def update
    todo = Todo.find_by_uuid!(params[:uuid])
    return respond_with(nil, :status => {:msg => "You are not the author of this todo, you can't update it", :code => 403}) unless current_user === todo.user

    if todo.update_attributes!(params_filter(params[:todo], [:name, :description]))
      return respond_with({:todo => @presenter.single(todo)})
    end
    respond_with({:errors => todo.errors}, :status => {:msg => "Todo can't be updated", :code => 400})
  end

  # Change accomplishment state of a Todo
  # PUT /todos/:uuid/(check|uncheck)
  def change_accomplishment
    todo = Todo.find_by_uuid!(params[:uuid])
    return respond_with(nil, :status => {:msg => "You are not the author of this todo, you can't check it", :code => 403}) unless current_user === todo.user

    todo.is_accomplished = params[:state] === 'check' ? true : false

    if todo.save!
      return respond_with({:todo => @presenter.single(todo)})
    else
      respond_with(nil, :status => {:msg => "Todo can't be updated", :code => 400})
    end
  end

  # Delete Todo
  # DELETE /todos/:uuid
  def destroy
    todo = Todo.find_by_uuid!(params[:uuid])
    return respond_with(nil, :status => {:msg => "You are not the author of this todo, you can't delete it", :code => 403}) unless current_user === todo.user

    if todo.destroy
      return respond_with(nil)
    end
    respond_with(nil, :status => {:msg => "Todo can't be deleted", :code => 400})
  end

  # Search Todos
  # GET /todos/search?q=
  def search
    return respond_with(nil, :status => {:msg => "Query can't be blank", :code => 400})     if params[:q].blank?
    return respond_with(nil, :status => {:msg => "Query length must be > 3", :code => 400}) if params[:q].length < 3

    offset, limit = api_offset_and_limit
    todos = Todo.where("user_id = ?", current_user.id)
                .search(:name_or_description_contains => params[:q])
                .order('updated_at DESC')
                .offset(offset).limit(limit)

    respond_with({:total => todos.total_count, :limit => limit, :offset => offset, :query => params[:q], :todos => @presenter.collection(todos)})
  end
end
