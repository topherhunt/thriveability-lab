class Users::OmniauthAccountsController < ApplicationController
  before_action :require_login

  def destroy
    account = current_user.omniauth_accounts.find_by!(provider: params[:provider])
    account.destroy!
    redirect_to edit_user_registration_path, notice: "Your #{params[:provider]} account has been unlinked."
  end
end
