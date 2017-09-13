class StayInformedFlagsController < ApplicationController
  before_action :require_login

  def create
    @target = params[:target_type].constantize.find(params[:target_id])
    @flag = StayInformedFlag.where(user: current_user, target: @target).first_or_create!
    Event.register(current_user, "follow", @target)
    redirect_to url_for(@target)
  end

  def destroy
    @target = params[:target_type].constantize.find(params[:target_id])
    @flag = StayInformedFlag.find_by!(user: current_user, target: @target)
    @flag.destroy!
    redirect_to url_for(@target)
  end

  def index
    @target = current_user.projects.find(params[:target_id])
    @flags = StayInformedFlag.where(target: @target).includes(:user)
  end

end
