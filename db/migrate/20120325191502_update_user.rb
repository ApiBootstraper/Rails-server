class UpdateUser < ActiveRecord::Migration
  def change
    add_column :users, :uuid, :string
    add_column :users, :username, :string
    add_column :users, :is_enable, :boolean, :default => true
    add_column :users, :enabled_at, :datetime
    add_index  :users, :is_enable
    add_index  :users, :uuid
  end

 def down
    remove_index  :users, :uuid
    remove_index  :users, :is_enable
    remove_column :users, :enabled_at
    remove_column :users, :is_enable
    remove_column :users, :username
    remove_column :users, :uuid
  end
end
