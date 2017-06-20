class UsersController < ApplicationController
  before_action :require_login, except: [:dashboard, :index, :show]

  def dashboard
    @most_active_users = User.most_recent(8)
    @most_recent_activity = RecentEvent.latest(5)
  end

  def index
    @users = User.where("first_name IS NOT NULL OR last_name IS NOT NULL").order("updated_at DESC")
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.published.order("published_at DESC").limit(10)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      NotificationGenerator.new(current_user, :updated_profile, current_user).run
      redirect_to user_path(@user), notice: "Your profile has been updated."
    else
      flash.now.alert = "Unable to save your changes. See error messages below."
      render 'edit'
    end
  end

  def reset_password
    @user = current_user
    @user.send_reset_password_instructions
    sign_out # Devise's pw reset mechanism won't work if I'm signed in
    redirect_to root_path, notice: "We've emailed a password reset link to <#{@user.email}>. Please check your email for the link."
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :tagline, :image, :location, :bio_interior, :bio_exterior)

  end

end
