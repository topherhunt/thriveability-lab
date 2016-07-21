class CreatePostConversants < ActiveRecord::Migration
  def change
    create_table :post_conversants do |t|
      t.integer :user_id
      t.integer :post_id
      t.string :intention_type
      t.string :intention_statement
      t.timestamps
    end

    add_index :post_conversants, :user_id
    add_index :post_conversants, :post_id
  end
end
