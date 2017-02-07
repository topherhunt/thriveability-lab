class LikeFlagsController < ApplicationController
  before_action :require_login

  def create
    @target = params[:target_type].constantize.find(params[:target_id])
    @flag = LikeFlag.where(user: current_user, target: @target).first_or_create!
    NotificationGenerator.new(current_user, :liked_object, @target).run
    redirect_to url_for(@target)
  end

  def destroy
    @target = params[:target_type].constantize.find(params[:target_id])
    @flag = LikeFlag.find_by!(user: current_user, target: @target)
    @flag.destroy!
    redirect_to url_for(@target)
  end

end
