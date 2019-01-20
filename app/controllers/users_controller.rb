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
    marshal_prompts_from_db
  end

  def update
    if @user.update(user_params) && upsert_profile_prompts
      Event.register(@user, "update", @user)
      redirect_to user_path(@user), notice: "Your profile has been updated."
    else
      flash.now.alert = "Unable to save your changes. See error messages below."
      marshal_prompts_from_params
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
    params.require(:user).permit(:name, :tagline, :location, :image)
  end

  def marshal_prompts_from_db
    @filled_prompts = @user.profile_prompts
      .map { |p| {stem: p.stem, response: p.response} }
    filled_stems = @filled_prompts.map { |p| p[:stem] }
    @unfilled_prompts = (UserProfilePrompt::TEMPLATES - filled_stems)
      .map { |stem| {stem: stem, response: ""} }
  end

  def marshal_prompts_from_params
    all_prompts = (params[:prompts] || {}).values
    @filled_prompts   = all_prompts.select { |p| p[:response].present? }
    @unfilled_prompts = all_prompts.select { |p| p[:response].blank? }
  end

  def upsert_profile_prompts
    return true unless params[:prompts]

    @prompt_errors = UpsertProfilePrompts.call(
      user: @user,
      submitted_prompts: params[:prompts].values)
    @prompt_errors.count == 0
  end
end
