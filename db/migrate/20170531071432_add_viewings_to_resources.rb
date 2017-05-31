class AddViewingsToResources < ActiveRecord::Migration
  def change
    add_column :resources, :viewings, :integer, default: 0
    add_index :resources, :viewings
  end
end
