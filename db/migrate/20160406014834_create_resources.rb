class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.integer :creator_id
      t.boolean :ownership_affirmed
      t.string :title
      t.text :description
      t.string :url
      t.attachment :attachment
    end
  end
end
