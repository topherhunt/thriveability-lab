class UsersBreakNameIntoFirstNameAndLastName < ActiveRecord::Migration
  def up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string

    User.all.each do |user|
      names = user.name.to_s.split(' ')
      user.first_name = names[0]
      user.last_name  = names[1..-1].join(' ')
      user.save!
    end

    remove_column :users, :name, :string
  end

  def down
    add_column :users, :name, :string

    User.all.each do |user|
      user.name = "#{user.first_name} #{user.last_name}"
      user.save!
    end

    remove_column :users, :first_name, :string
    remove_column :users, :last_name, :string
  end
end
