class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :author_id
      t.string :title
      t.text :content
      t.string :intention_type
      t.string :intention_statement
      t.boolean :published, default: false
      t.datetime :published_at
      t.timestamps
    end
  end
end
