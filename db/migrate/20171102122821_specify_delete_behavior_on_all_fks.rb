class SpecifyDeleteBehaviorOnAllFks < ActiveRecord::Migration
  def up
    remove_foreign_key :events, :actors
    add_foreign_key :events, :users, column: :actor_id, on_delete: :cascade

    remove_foreign_key :notifications, :events
    add_foreign_key :notifications, :events, column: :event_id, on_delete: :cascade

    remove_foreign_key :notifications, :notify_users
    add_foreign_key :notifications, :users, column: :notify_user_id, on_delete: :cascade

    remove_foreign_key :messages, :senders
    add_foreign_key :messages, :users, column: :sender_id, on_delete: :cascade

    remove_foreign_key :messages, :recipients
    add_foreign_key :messages, :users, column: :recipient_id, on_delete: :cascade

    remove_foreign_key :messages, :projects
    add_foreign_key :messages, :projects, on_delete: :nullify
  end

  def down
    up
  end
end
