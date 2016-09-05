class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_or_create_or_link_from_omniauth(auth: request.env["omniauth.auth"], logged_in_user: current_user)

    if @user.persisted?
      sign_in @user
      redirect_to after_sign_in_path_for(@user), notice: "You're signed in via your Facebook account."
    else
      # TODO: When would this branch be accessed?
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url # TODO: Do we need a flash message here?
    end
  end

  def google_oauth2
    @user = User.find_or_create_or_link_from_omniauth(auth: request.env["omniauth.auth"], logged_in_user: current_user)

    if @user.persisted?
      sign_in @user
      redirect_to after_sign_in_path_for(@user), notice: "You're signed in via your Google account."
    else
      # TODO: When would this branch be accessed?
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url # TODO: Do we need a flash message here?
    end
  end

  def linkedin
    @user = User.find_or_create_or_link_from_omniauth(auth: request.env["omniauth.auth"], logged_in_user: current_user)

    if @user.persisted?
      sign_in @user
      redirect_to after_sign_in_path_for(@user), notice: "You're signed in via your LinkedIn account."
    else
      # TODO: When would this branch be accessed?
      session["devise.linkedin_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url # TODO: Do we need a flash message here?
    end
  end

  def failure
    raise "Omniauth failure callback invoked! Please check the logs for errors."
    # redirect_to root_path, alert: "We were unable to connect your account."
  end
end
