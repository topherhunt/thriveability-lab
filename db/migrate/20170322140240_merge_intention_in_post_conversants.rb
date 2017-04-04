class MergeIntentionInPostConversants < ActiveRecord::Migration
  def change
    remove_column :post_conversants, :intention_statement
    rename_column :post_conversants, :intention_type, :intention
  end
end
