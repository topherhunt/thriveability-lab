class LikeFlagsController < ApplicationController
  before_action :require_logged_in

  def create
    @target = params[:target_type].constantize.find(params[:target_id])
    @flag = LikeFlag.where(user: current_user, target: @target).first_or_create!
    Event.register(current_user, "like", @target)
    redirect_to url_for(@target)
  end

  def destroy
    @target = params[:target_type].constantize.find(params[:target_id])
    @flag = LikeFlag.find_by!(user: current_user, target: @target)
    @flag.destroy!
    redirect_to url_for(@target)
  end

end
