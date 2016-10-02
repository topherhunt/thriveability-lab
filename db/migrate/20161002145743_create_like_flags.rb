class CreateLikeFlags < ActiveRecord::Migration
  def change
    create_table :like_flags do |t|
      t.integer :user_id
      t.string :target_type
      t.integer :target_id
      t.timestamps
    end

    add_index :like_flags, :user_id
    add_index :like_flags, [:target_type, :target_id]
  end
end
