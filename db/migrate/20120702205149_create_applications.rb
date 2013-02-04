class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string  :name
      t.string  :app_id
      t.string  :app_key
      t.text    :comment
      t.boolean :is_enable, :default => true

      t.timestamps
    end
    add_index :applications, :app_id
    add_index :applications, :app_key
    add_index :applications, :is_enable

    change_table :trackings do |t|
      t.references :user
      t.integer    :application_id
    end
    add_index :trackings, :application_id
  end
end
