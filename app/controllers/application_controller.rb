class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # before_filter :configure_permitted_parameters, if: :devise_controller?

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.for(:sign_up) do |u|
  #     u.permit(:username, :email, :password, :password_confirmation)
  #   end
  # end

  def require_login
    unless current_user
      if request.method == "GET"
        session[:return_to] = request.path
      else
        session[:return_to] = request.referer
      end
      redirect_to new_user_session_path, alert: "You must be logged in to take that action."
    end
  end

  def require_user_name
    unless current_user.first_name.present?
      redirect_to edit_user_path(current_user), alert: "We'd like to know you better! Please fill in your name before taking that action."
    end
  end

  def after_sign_in_path_for(user)
    if session[:return_to]
      session.delete(:return_to)
    elsif user.first_name.present?
      root_path
    else
      user_path(user)
    end
  end

  rescue_from ActionController::InvalidAuthenticityToken do
    session[:return_to] = request.referer
    redirect_to new_user_session_path, alert: "You must be logged in to take that action."
  end
end
