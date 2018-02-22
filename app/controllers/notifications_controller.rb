class NotificationsController < ApplicationController
  before_action :require_login

  def index
    @notifications = current_user.notifications.includes(:event)
      .order("created_at DESC")
      .limit(50)
  end

  def show
    @notification = current_user.notifications.find(params[:id])
    @notification.update!(read: true) unless @notification.read?
    redirect_to notification_redirect_path
  end

  def mark_all_read
    current_user.notifications.where(read: false).update_all(read: true)
    redirect_to request.referer || root_path
  end

  private

  def notification_redirect_path
    destination = params[:redirect_to] == "actor" ? "actor" : "target"
    url_for @notification.event.send(destination)
  end
end
