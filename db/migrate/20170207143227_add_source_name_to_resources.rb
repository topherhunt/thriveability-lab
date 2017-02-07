class AddSourceNameToResources < ActiveRecord::Migration
  def change
    rename_column :resources, :url, :current_url
    add_column :resources, :source_name, :string
  end
end
