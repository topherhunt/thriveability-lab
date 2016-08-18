class AddPersonalFieldsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :self_passions, :string, limit: 1000
    add_column :users, :self_skills, :string, limit: 1000
    add_column :users, :self_proud_traits, :string, limit: 1000
    add_column :users, :self_weaknesses, :string, limit: 1000
    add_column :users, :self_evolve, :string, limit: 1000
    rename_column :users, :dream_of_future_where, :self_dreams
    change_column :users, :self_dreams, :string, limit: 1000
    add_column :users, :self_looking_for, :string, limit: 1000
    add_column :users, :self_work_at, :string, limit: 1000
    add_column :users, :self_professional_goals, :string, limit: 1000
    add_column :users, :self_fields_of_expertise, :string, limit: 1000
  end

  def down
    remove_column :users, :self_passions
    remove_column :users, :self_skills
    remove_column :users, :self_proud_traits
    remove_column :users, :self_weaknesses
    remove_column :users, :self_evolve
    rename_column :users, :self_dreams, :dream_of_future_where
    remove_column :users, :self_looking_for
    remove_column :users, :self_work_at
    remove_column :users, :self_professional_goals
    remove_column :users, :self_fields_of_expertise
  end
end
