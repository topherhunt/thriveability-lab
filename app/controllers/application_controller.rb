class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_devise_params, if: :devise_controller?

  def configure_permitted_devise_params
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
  end

  def require_login
    unless current_user
      if request.method == "GET"
        session[:return_to] = request.original_url
      else
        session[:return_to] = request.referer
      end
      redirect_to new_user_session_path, alert: "You must be logged in to take that action."
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

  def requester_is_robot?
    ["AhrefsBot", "DotBot", "Googlebot"]
      .any? { |string| string.in?(request.env['HTTP_USER_AGENT'] || '') }
  end

  rescue_from ActionController::InvalidAuthenticityToken do
    session[:return_to] = request.referer
    redirect_to new_user_session_path, alert: "You must be logged in to take that action."
  end

  rescue_from ActionController::RoutingError do |e|
    if requester_is_robot?
      render nothing: true, status: 404
    else
      raise e
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    if requester_is_robot?
      render nothing: true, status: 404
    else
      raise e
    end
  end
end
