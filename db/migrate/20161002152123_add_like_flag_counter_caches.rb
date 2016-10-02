class AddLikeFlagCounterCaches < ActiveRecord::Migration
  def change
    add_column :projects, :like_flags_count, :integer, default: 0
    add_column :posts, :like_flags_count, :integer, default: 0
    add_column :resources, :like_flags_count, :integer, default: 0
  end
end
