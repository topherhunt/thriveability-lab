class CreatePredefinedTags < ActiveRecord::Migration
  def change
    create_table :predefined_tags do |t|
      t.string :name
      t.timestamps
    end
  end
end
