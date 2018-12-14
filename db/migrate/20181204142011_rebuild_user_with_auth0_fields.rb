class RebuildUserWithAuth0Fields < ActiveRecord::Migration
  def up
    remove_column :users, :encrypted_password
    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at
    remove_column :users, :remember_created_at
    remove_column :users, :sign_in_count
    remove_column :users, :current_sign_in_at
    remove_column :users, :last_sign_in_at
    remove_column :users, :current_sign_in_ip
    remove_column :users, :last_sign_in_ip
    remove_column :users, :confirmation_token
    remove_column :users, :confirmed_at
    remove_column :users, :confirmation_sent_at
    remove_column :users, :unconfirmed_email
    remove_column :users, :has_set_password
    remove_column :users, :first_name
    remove_column :users, :last_name

    add_column :users, :name, :string, null: false
    add_column :users, :auth0_uid, :string, null: false
    add_column :users, :last_signed_in_at, :datetime
  end

  def down
    raise "Reverse migration not yet written..."
  end
end
