class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :load_current_user

  helper_method :current_user

  #
  # Auth helpers
  #

  def load_current_user
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    end
  end

  def current_user
    @current_user
  end

  def require_not_logged_in
    if current_user
      redirect_to root_path, alert: "You are already logged in."
    end
  end

  def require_logged_in
    unless current_user
      if request.method == "GET"
        session[:return_to] = request.original_url
      else
        session[:return_to] = request.referer
      end
      redirect_to new_user_session_path, alert: "You must be logged in to take that action."
    end
  end

  def requester_is_robot?
    ["AhrefsBot", "DotBot", "Googlebot"]
      .any? { |string| string.in?(request.user_agent || '') }
  end

  rescue_from ActionController::InvalidAuthenticityToken do
    session[:return_to] = request.referer
    redirect_to new_user_session_path, alert: "You must be logged in to take that action."
  end

  rescue_from ActionController::RoutingError do |e|
    if requester_is_robot?
      render nothing: true, status: 404
    else
      Rails.logger.warn "Got ActionController::RoutingError from an unknown useragent. The useragent: #{request.user_agent.inspect}"
      raise e
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    if requester_is_robot?
      render nothing: true, status: 404
    else
      Rails.logger.warn "Got ActiveRecord::RecordNotFound from an unknown useragent. The useragent: #{request.user_agent.inspect}"
      raise e
    end
  end
end
