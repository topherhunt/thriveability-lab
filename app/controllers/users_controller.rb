class UsersController < ApplicationController
  before_action :require_login, except: [:index, :search, :show]

  def index
    @most_active_users = User.most_recent(8)
    @recent_events = Event.latest(5)
  end

  def search
    @users = User.where("first_name IS NOT NULL OR last_name IS NOT NULL").order("updated_at DESC")
  end

  def show
    @user = User.find(params[:id])
    @projects = @user.projects.latest(5)
    @resources = @user.created_resources.latest(5)
    post_ids = PostConversant.where(user: @user).pluck(:post_id)
    @posts = Post.where(id: post_ids).latest(5)
    @count_drafts = @user.posts.roots.draft.count if @user == current_user
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
