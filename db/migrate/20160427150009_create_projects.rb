class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :owner_id
      t.string :title
      t.string :subtitle
      t.text :introduction
      t.string :location
      t.string :quadrant_ul
      t.string :quadrant_ur
      t.string :quadrant_ll
      t.string :quadrant_lr
      t.string :call_to_action
      t.string :stage
      t.attachment :image
      t.timestamps
    end
  end
end
