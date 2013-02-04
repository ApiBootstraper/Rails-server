class Api::V100::TodoPresenter < Api::V100::BasePresenter

  def collection collection
    formated_todos = []
    collection.each do |t|
      formated_todos.push({
        :uuid            => t.uuid,
        :name            => t.name,
        :is_accomplished => t.is_accomplished?,
        :created_at      => t.created_at,
        :updated_at      => t.updated_at,
      })
    end
    return formated_todos
  end

  def single todo
    {
      :uuid            => todo.uuid,
      :name            => todo.name,
      :description     => todo.description,
      :is_accomplished => todo.is_accomplished?,
      :created_at      => todo.created_at,
      :updated_at      => todo.updated_at,
    }
  end

end