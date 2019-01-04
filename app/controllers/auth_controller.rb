class AuthController < ApplicationController
  # On successful auth, Auth0 redirects the user back here. The Omniauth gem
  # registers a magical middleware that exchanges the auth token for the userinfo
  # (see config/initializers/omniauth.rb) and puts the userinfo in request.env.
  def auth0_callback
    user = Services::FindOrCreateUserFromAuth.call(auth: request.env["omniauth.auth"])
    sign_in! user
    redirect_to session.delete(:return_to) || root_path
  end

  # Logs out of both the app and Auth0 session - see https://auth0.com/docs/logout
  def logout
    reset_session
    redirect_to auth0_logout_url
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

  private

  def auth0_logout_url
    domain = ENV.fetch("AUTH0_DOMAIN")
    returnTo = CGI.escape(root_url)
    client_id = ENV.fetch("AUTH0_CLIENT_ID")
    "https://#{domain}/v2/logout?returnTo=#{returnTo}&client_id=#{client_id}"
  end
end
