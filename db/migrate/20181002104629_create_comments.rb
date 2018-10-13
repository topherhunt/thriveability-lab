class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :context_type, null: false
      t.integer :context_id, null: false
      t.integer :author_id, null: false
      t.text :body
      t.timestamps
    end

    add_index :comments, [:context_type, :context_id]
    add_foreign_key :comments, :users, column: :author_id
    add_index :comments, :author_id
  end
end
