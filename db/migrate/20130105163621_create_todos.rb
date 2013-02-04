class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string     :uuid,           :null => false
      t.references :user,           :null => false
      t.string     :name
      t.text       :description
      t.datetime   :accomplished_at

      t.timestamps
    end
    add_index :todos, :user_id
    add_index :todos, :uuid
  end
end
