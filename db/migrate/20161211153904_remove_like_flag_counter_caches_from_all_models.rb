class RemoveLikeFlagCounterCachesFromAllModels < ActiveRecord::Migration
  def change
    # In the long run we'll need counter caches but for now they're only likely
    # to add rigidity to our implementation because we don't yet know how we
    # want to rate popularity.
    remove_column :resources, :like_flags_count, :integer, default: 0
    remove_column :posts,     :like_flags_count, :integer, default: 0
  end
end
