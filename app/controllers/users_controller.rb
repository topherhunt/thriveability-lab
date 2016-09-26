class UsersController < ApplicationController
  before_action :require_login, except: [:index, :show]

  def index
    @users = User.order("current_sign_in_at DESC")
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.where(published: true).order("published_at DESC").limit(10)

    if @user == current_user and @user.name.blank?
      redirect_to edit_user_path(@user), alert: "You haven't told us about yourself yet! Once you answer the following questions, you can contribute more to the community and you'll get more value out of Integral Climate Hub."
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
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
    params.require(:user).permit(:name, :image, :self_passions, :self_skills, :self_proud_traits, :self_weaknesses, :self_evolve, :self_dreams, :self_looking_for, :self_work_at, :self_professional_goals, :self_fields_of_expertise)

  end

end
