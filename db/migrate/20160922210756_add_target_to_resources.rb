class AddTargetToResources < ActiveRecord::Migration
  def change
    add_column :resources, :target_type, :string
    add_column :resources, :target_id, :integer
    add_index :resources, [:target_type, :target_id]
  end
end
