class ChangeProjectQuestions < ActiveRecord::Migration
  def up
    add_column :projects, :partners, :text
    add_column :projects, :video_url, :string
    add_column :projects, :desired_impact, :text
    add_column :projects, :contribution_to_world, :text
    add_column :projects, :location_of_impact, :text
    add_column :projects, :q_background, :text
    add_column :projects, :q_meaning, :text
    add_column :projects, :q_community, :text
    add_column :projects, :q_goals, :text
    add_column :projects, :q_how_make_impact, :text
    add_column :projects, :q_how_measure_impact, :text
    add_column :projects, :q_potential_barriers, :text
    add_column :projects, :q_project_assets, :text
    add_column :projects, :q_larger_vision, :text

    rename_column :projects, :location, :location_of_home
    rename_column :projects, :call_to_action, :help_needed

    remove_column :projects, :introduction
    remove_column :projects, :quadrant_ul
    remove_column :projects, :quadrant_ur
    remove_column :projects, :quadrant_ll
    remove_column :projects, :quadrant_lr
  end

  def down
    remove_column :projects, :partners
    remove_column :projects, :video_url
    remove_column :projects, :desired_impact
    remove_column :projects, :contribution_to_world
    remove_column :projects, :location_of_impact
    remove_column :projects, :q_background
    remove_column :projects, :q_meaning
    remove_column :projects, :q_community
    remove_column :projects, :q_goals
    remove_column :projects, :q_how_make_impact
    remove_column :projects, :q_how_measure_impact
    remove_column :projects, :q_potential_barriers
    remove_column :projects, :q_project_assets
    remove_column :projects, :q_larger_vision

    rename_column :projects, :location_of_home, :location
    rename_column :projects, :help_needed, :call_to_action

    add_column :projects, :introduction, :text
    add_column :projects, :quadrant_ul, :text
    add_column :projects, :quadrant_ur, :text
    add_column :projects, :quadrant_ll, :text
    add_column :projects, :quadrant_lr, :text
  end
end
