class MakeEmailNotRequired < ActiveRecord::Migration
  def change
    remove_column :users, :email
    add_column :users, :email, :string
    add_column :users, :email_confirmed_at, :datetime
  end
end
