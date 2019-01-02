# This logic might be applicable to any oauth2 adapter, but we use Auth0.
# TODO: Rename to AuthController
class Auth0Controller < ApplicationController
  before_filter :require_not_logged_in, only: [:login_succeeded]

  # On successful auth, Auth0 redirects the user back here. The Omniauth gem
  # registers a magical middleware that exchanges the auth token for the userinfo
  # (see config/initializers/omniauth.rb) and puts the userinfo in request.env.
  def login_callback
    user = Services::FindOrCreateUserFromAuth.call(auth: request.env["omniauth.auth"])
    sign_in! user
    redirect_to session.delete(:return_to) || root_path
  end

  def logout
    reset_session
    redirect_to root_path
  end

  # Auth0 lets the admin force-login as any registered user, but this is useful
  # for tests etc. too.
  def force_login
    if params[:password] == ENV["FORCE_LOGIN_PASSWORD"]
      user = User.find(params[:user_id])
      log :warn, "#force_login succeeded, logging in as user #{user.id}."
      sign_in! user # Note: this will update the timestamp like normal signins
      redirect_to root_path, notice: "You're logged in as #{user.name}."
    else
      sleep 1 # prevent brute forcing
      raise "#force_login called with wrong password! Provided password was: #{params[:password]}"
    end
  end
end
