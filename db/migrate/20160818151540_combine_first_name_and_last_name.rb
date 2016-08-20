class CombineFirstNameAndLastName < ActiveRecord::Migration
  def up
    rename_column :users, :first_name, :name
    User.all.each do |user|
      if user.last_name.present?
        user.name = "#{user.name} #{user.last_name}"
        user.save(validate: false)
      end
    end
    remove_column :users, :last_name
  end

  def down
    rename_column :users, :name, :first_name
    add_column :users, :last_name, :string
  end
end
