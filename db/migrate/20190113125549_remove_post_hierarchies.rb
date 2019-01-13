class RemovePostHierarchies < ActiveRecord::Migration
  def change
    drop_table :post_hierarchies
  end
end
