class MergePostIntentionFields < ActiveRecord::Migration
  def change
    remove_column :posts, :intention_statement
    rename_column :posts, :intention_type, :intention
  end
end
