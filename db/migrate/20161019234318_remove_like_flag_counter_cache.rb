class RemoveLikeFlagCounterCache < ActiveRecord::Migration
  def change
    remove_column :projects, :like_flags_count, :integer, default: 0
  end
end
