# This logic might be applicable to any oauth2 adapter, but we use Auth0.
class Auth0Controller < ApplicationController
  before_filter :require_not_logged_in, only: [:login_succeeded]

  # Auth0 redirects the user back here after a login attempt (successful or not).
  def login_callback
    auth = request.env["omniauth.auth"]
    if auth.uid.present?
      user = find_or_create_user(auth)
      sign_in! user
      redirect_to session.delete(:return_to) || root_path
    else
      puts "omniauth.auth is: #{request.env["omniauth.auth"]}"
      puts "omniauth.error is: #{request.env["omniauth.error"]}"
      raise "TODO: Test what data we're given on auth failure"
      # TODO: I'm not sure if this will work. See "Display Error Descriptions" guide.
      error_key = request.env["omniauth.error.type"]
      error_description = Rack::Utils.escape(env['omniauth.error'].error_reason)
      redirect_to root_path, alert: "Unable to log you in. The error message: #{error_key}: \"#{error_description}\""
    end
  end

  def failure
    raise "TODO: Figure out when is this called, and what data is provided with it. Request.env is: #{request.env}"
  end

  def logout
    reset_session
    redirect_to root_path
  end

  private

  def find_or_create_user(auth)
    # Auth hash format: https://github.com/omniauth/omniauth/wiki/Auth-Hash-Schema
    raise "Unknown provider #{auth.provider}" unless auth.provider == "auth0"
    uid = auth.uid || raise("UID is required")

    if user = User.find_by(auth0_uid: uid)
      # TODO: Consider updating the user based on their latest account settings
      user
    else
      name = auth.info.name || raise("Name is required")
      image = auth.info.image
      User.create!(auth0_uid: uid, name: name, image: image)
    end
  rescue => e
    raise "Failed to validate Auth0 auth data: #{e}. The full auth data provided by Auth0 was: #{auth.to_json}"
  end

  def sign_in!(user)
    # We don't expire session. You stay logged in until you log out or close browser.
    session[:user_id] = user.id
    user.update!(last_signed_in_at: Time.current)
    @current_user = user
  end

  def log(message)
    Rails.logger.info "#{self.class}: #{message}"
  end
end
