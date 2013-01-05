class CreateTrackings < ActiveRecord::Migration
  def change
    create_table :trackings do |t|
      t.string  :uuid
      t.string  :request
      t.string  :method
      t.integer :code
      t.string  :remote_ip
      t.string  :version

      t.timestamps
    end
    add_index :trackings, :uuid
  end
end
