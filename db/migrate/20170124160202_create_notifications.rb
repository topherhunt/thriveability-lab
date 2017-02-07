class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :notify_user_id
      t.integer :actor_id
      t.string :action
      t.string :target_type
      t.integer :target_id
      t.boolean :read, default: false, null: false
      t.timestamps
    end

    add_index :notifications, :notify_user_id
    add_index :notifications, :actor_id # likely won't use this
    add_index :notifications, [:target_type, :target_id] # likely won't use this
  end
end
