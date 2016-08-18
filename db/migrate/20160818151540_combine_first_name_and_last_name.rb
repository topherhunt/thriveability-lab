class CombineFirstNameAndLastName < ActiveRecord::Migration
  def up
    rename_column :users, :first_name, :name
    User.all.each do |u|
      u.update!(name: "#{u.name} #{u.last_name}") if u.last_name.present?
    end
    remove_column :users, :last_name
  end

  def down
    rename_column :users, :name, :first_name
    add_column :users, :last_name, :string
  end
end
