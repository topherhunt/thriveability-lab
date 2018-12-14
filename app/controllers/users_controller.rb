class UsersController < ApplicationController
  before_action :require_logged_in, except: [:index, :search, :show]

  def index
    @most_active_users = User.most_recent(8)
    @recent_events = Event.latest(5)
  end

  def show
    @user = User.find(params[:id])
    @projects = @user.projects.latest(5)
    @resources = @user.created_resources.latest(5)
    @participating_in_conversations = @user.participating_in_conversations.latest(5)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      Event.register(current_user, "update", current_user)
      redirect_to user_path(@user), notice: "Your profile has been updated."
    else
      flash.now.alert = "Unable to save your changes. See error messages below."
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :tagline, :location, :bio_interior, :bio_exterior, :image, :email)
  end

end
