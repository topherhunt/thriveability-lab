class UsersController < ApplicationController
  before_action :require_logged_in, only: [:edit, :update]
  before_action :load_user, only: [:show, :edit, :update]
  before_action :verify_current_user_is_target, only: [:edit, :update]

  def index
    @most_active_users = User.most_recent(8)
    @recent_events = Event.latest(5)
  end

  def show
    @projects = @user.projects.latest(5)
    @resources = @user.created_resources.latest(5)
    @participating_in_conversations = @user.participating_in_conversations.latest(5)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      Event.register(@user, "update", @user)
      redirect_to user_path(@user), notice: "Your profile has been updated."
    else
      flash.now.alert = "Unable to save your changes. See error messages below."
      render 'edit'
    end
  end

  private

  def load_user
    @user = User.find(params[:id])
  end

  def verify_current_user_is_target
    unless @user.id == current_user.id
      redirect_to root_path, alert: "You don't have permission to make that change."
    end
  end

  def user_params
    params.require(:user).permit(
      :name, :tagline, :location,
      :bio_interior, :bio_exterior, :image)
  end
end
