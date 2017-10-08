class AddRelevantToToResources < ActiveRecord::Migration
  def change
    add_column :resources, :relevant_to, :text
  end
end
