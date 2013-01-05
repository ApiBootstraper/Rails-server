class Api::V100::TodoPresenter < Api::V100::BasePresenter

  def initialize
    @user_presenter = Api::V100::UserPresenter.new
  end

  def collection collection
    formated_todos = []
    collection.each do |p|
      formated_todos.push({
        :uuid        => todo.uuid,
        :name        => todo.name,
        :description => todo.description,
        :created_at  => todo.created_at,
        :updated_at  => todo.updated_at,
      })
    end
    return formated_todos
  end

  def single todo
    {
      :uuid        => todo.uuid,
      :name        => todo.name,
      :description => todo.description,
      :created_at  => todo.created_at,
      :updated_at  => todo.updated_at,
    }
  end

end