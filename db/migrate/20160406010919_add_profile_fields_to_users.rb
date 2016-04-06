class AddProfileFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_attachment :users, :image
    add_column :users, :dream_of_future_where, :string
  end
end
