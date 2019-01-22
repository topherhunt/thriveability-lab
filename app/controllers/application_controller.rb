class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :load_current_user
  helper_method :current_user

  #
  # Auth helpers
  #

  def sign_in!(user)
    # We don't expire session. You stay logged in until you log out or close browser.
    session[:user_id] = user.id
    user.update!(last_signed_in_at: Time.current)
    @current_user = user
  end

  def load_current_user
    if session[:user_id]
      if @current_user = User.find_by(id: session[:user_id])
        # Great, you're logged in.
      else
        Rails.logger.warn "Resetting invalid session user_id #{session[:user_id]}."
        reset_session
        redirect_to root_path
      end
    end
  end

  def current_user
    @current_user
  end

  def require_logged_in
    unless current_user
      if request.method == "GET"
        session[:return_to] = request.original_url
      else
        session[:return_to] = request.referer
      end
      redirect_to root_path, alert: "You must be logged in to take that action."
    end
  end

  #
  # Other helpers
  #

  # Add request metadata to Lograge payload (see config/initializers/lograge.rb)
  def append_info_to_payload(payload)
    super
    payload[:ip] = request.remote_ip
    payload[:user] = current_user ? "#{current_user.id} (#{current_user.name})" : "none"
  end

  def requester_is_robot?
    ["AhrefsBot", "DotBot", "Googlebot"]
      .any? { |string| string.in?(request.user_agent || '') }
  end

  def log(sev, message)
    raise "Unknown severity #{sev}!" unless sev.in? [:info, :warn, :error]
    Rails.logger.send(sev, "#{self.class}: #{message}")
  end

  #
  # Rescues
  #

  # We can assume that most CSRF violations are due to login timeouts.
  # TODO: Review how MAPP does this. Anything to improve here?
  rescue_from ActionController::InvalidAuthenticityToken do
    session[:return_to] = request.referer
    redirect_to root_path, alert: "You must be logged in to take that action."
  end

  # Explicitly control handling of 404s
  rescue_from ActiveRecord::RecordNotFound do |e|
    log :warn, "Got ActiveRecord::RecordNotFound. url: #{request.original_url}, "\
      "error: #{e}, useragent: #{request.user_agent.inspect}"
    render file: "public/404.html", layout: false, status: 404
  end
end
