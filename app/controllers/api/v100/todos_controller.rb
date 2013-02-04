class Api::V100::TodosController < Api::V100::BaseController

  # Get todos of current user
  # GET /todo/my
  def show_current_user_todos
    todos = Todo.where("user_id = ?", current_user.id)
                .order("updated_at DESC")
                .page(params[:page])
    respond_with({:total => todos.total_count, :page => todos.current_page, :todos => @presenter.collection(todos)})
  end


  # Create a new Todo
  # POST /todo
  def create
    todo = Todo.new(params_filter(params[:todo], [:name, :description]))
    todo.user = current_user

    if todo.save!
      respond_with({:todo => @presenter.single(todo)}, :status => {:msg => "Todo created", :code => 201})
    else
      respond_with({:errors => todo.errors}, :status => {:msg => "Todo can't be created", :code => 400})
    end
  end


  # Show Todo
  # GET /todo/:uuid
  def show
    todo = Todo.find_by_uuid!(params[:uuid])
    respond_with({:todo => @presenter.single(todo)})
  end


  # Update Todo
  # PUT /todo/:uuid
  def update
    todo = Todo.find_by_uuid!(params[:uuid])
    if current_user != todo.user
      respond_with(nil, :status => {:msg => "You are not the author of this todo, you can't update it", :code => 403})
      return
    end

    if todo.update_attributes!(params_filter(params[:todo], [:name, :description]))
      respond_with({:todo => @presenter.single(todo)})
    else
      respond_with(nil, :status => {:msg => "Todo can't be updated", :code => 400})
    end
  end


  # Change accomplishment state of a Todo
  # PUT /todo/:uuid/(check|uncheck)
  def change_accomplishment
    todo = Todo.find_by_uuid!(params[:uuid])
    if current_user != todo.user
      respond_with(nil, :status => {:msg => "You are not the author of this todo, you can't check it", :code => 403})
      return
    end

    todo.is_accomplished = params[:state] === 'check' ? true : false

    if todo.save!
      respond_with({:todo => @presenter.single(todo)})
    else
      respond_with(nil, :status => {:msg => "Todo can't be updated", :code => 400})
    end
  end


  # Delete Todo
  # DELETE /todo/:uuid
  def destroy
    todo = Todo.find_by_uuid!(params[:uuid])
    if current_user != todo.user
      respond_with(nil, :status => {:msg => "You are not the author of this todo, you can't delete it", :code => 403})
      return
    end

    if todo.destroy
      respond_with(nil)
    else
      respond_with(nil, :status => {:msg => "Todo can't be deleted", :code => 400})
    end
  end


  # Search Todos
  def search
    if params[:q].blank?
      respond_with(nil, :status => {:msg => "Query can't be blank", :code => 400})
    else
      todos = Todo.search(:name_contains => params[:q]).order('updated_at DESC').page(params[:page])
      respond_with({:total => todos.total_count, :page => todos.current_page, :query => params[:q], :todos => @presenter.collection(todos)})
    end
  end
end
