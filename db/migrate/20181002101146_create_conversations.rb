class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :creator_id, null: false
      t.string :title, null: false
      t.timestamps
    end

    add_foreign_key :conversations, :users, column: :creator_id
    add_index :conversations, :creator_id
  end
end
