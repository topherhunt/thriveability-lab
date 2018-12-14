class RemoveOmniauthAccounts < ActiveRecord::Migration
  def change
    drop_table :omniauth_accounts
  end
end
