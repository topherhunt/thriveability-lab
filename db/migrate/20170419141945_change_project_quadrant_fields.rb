class ChangeProjectQuadrantFields < ActiveRecord::Migration
  def change
    change_column :projects, :quadrant_ul, :text
    change_column :projects, :quadrant_ur, :text
    change_column :projects, :quadrant_ll, :text
    change_column :projects, :quadrant_lr, :text
    change_column :projects, :call_to_action, :text
  end
end
