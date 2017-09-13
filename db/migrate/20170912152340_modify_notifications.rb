class ModifyNotifications < ActiveRecord::Migration
  def change
    remove_column :notifications, :actor_id, :integer
    remove_column :notifications, :action, :string
    remove_column :notifications, :target_type, :string
    remove_column :notifications, :target_id, :integer
    add_column :notifications, :event_id, :integer

    add_index :notifications, :event_id
    add_foreign_key :notifications, :events, column: :event_id
    add_foreign_key :notifications, :users, column: :notify_user_id
  end
end
