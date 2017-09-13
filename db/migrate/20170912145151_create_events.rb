class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :actor_id
      t.string :action
      t.string :target_type
      t.integer :target_id
      t.datetime :created_at
    end

    add_index :events, :actor_id
    add_index :events, :action
    add_index :events, [:target_type, :target_id]
    add_foreign_key :events, :users, column: :actor_id
  end
end
