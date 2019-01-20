class RemoveBioInteriorAndExterior < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :bio_interior, :text
    remove_column :users, :bio_exterior, :text
  end
end
