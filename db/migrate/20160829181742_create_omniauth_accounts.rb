class CreateOmniauthAccounts < ActiveRecord::Migration
  def change
    create_table :omniauth_accounts do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.timestamps
    end

    add_index :omniauth_accounts, :user_id
    add_index :omniauth_accounts, [:provider, :uid]
  end
end
