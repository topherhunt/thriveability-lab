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

    @prompt_errors = ""
    existing_prompts = @user.profile_prompts.to_a

    params[:prompts].each do |index, hash|
      stem = hash.fetch(:stem)
      response = hash.fetch(:response)
      existing = existing_prompts.find { |p| p.stem == stem }
      try_create_or_update_or_destroy_prompt(existing, stem, response)
    end

    @prompt_errors.blank?
  end

  def try_create_or_update_or_destroy_prompt(existing, stem, response)
    if existing
      prompt = existing
      if response.present?
        prompt.response = response
      else
        prompt.destroy!
      end
    elsif response.present?
      prompt = @user.profile_prompts.new(stem: stem, response: response)
    else
      return
    end

    if prompt.changed?
      prompt.save || report_prompt_error(prompt)
    end
  end

  def report_prompt_error(prompt)
    @prompt_errors += "Prompt \"#{prompt.stem}\": #{prompt.errors.full_messages.join(", ")}. "
  end
end
