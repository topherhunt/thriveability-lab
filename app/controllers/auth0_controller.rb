# This logic might be applicable to any oauth2 adapter, but we use Auth0.
class Auth0Controller < ApplicationController
  before_filter :require_not_logged_in, only: [:login_succeeded]

  # Auth0 redirects the user back here after a successful auth.
  def login_callback
    user = Services::FindOrCreateUserFromAuth.call(auth: request.env["omniauth.auth"])
    sign_in! user
    redirect_to session.delete(:return_to) || root_path
  end

  def failure
    raise "TODO: Figure out when is this called, and what data is provided with it. Request.env is: #{request.env}"
  end

  def logout
    reset_session
    redirect_to root_path
  end

  private

  def sign_in!(user)
    # We don't expire session. You stay logged in until you log out or close browser.
    session[:user_id] = user.id
    user.update!(last_signed_in_at: Time.current)
    @current_user = user
  end

  def log(severity, message)
    raise "Unknown severity #{severity}!" unless severity.to_s.in?(%w(info warn error))
    Rails.logger.send(severity, "#{self.class}: #{message}")
  end
end
