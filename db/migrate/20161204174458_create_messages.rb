class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.integer :project_id
      t.string :subject_code
      t.text :body
      t.timestamps
      t.datetime :sent_at
    end

    add_index :messages, :sender_id
    add_index :messages, :recipient_id
    add_index :messages, :project_id
    add_foreign_key :messages, :users, column: :sender_id
    add_foreign_key :messages, :users, column: :recipient_id
    add_foreign_key :messages, :projects
  end
end
