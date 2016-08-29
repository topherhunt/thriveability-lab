class PostsController < ApplicationController
  before_action :require_login, only: [:drafts, :create, :edit, :update, :destroy]
  before_action :require_user_name, only: [:edit]
  before_action :load_post, only: [:edit, :update, :show, :destroy]
  before_action :verify_authorship, only: [:edit, :update, :destroy]

  def index
    @filters = params.slice(:author_id, :tag, :intention_type)
    @posts = Post.roots.visible_to(current_user).order("published_at DESC")
    filter_posts
    @authors = User.where(id: @posts.pluck(:author_id).uniq).order(:name)
    @intention_types = @posts.pluck(:intention_type).uniq.select(&:present?).sort
    @tag_counts = @posts.tag_counts_on(:tags)
  end

  def create
    # In order to enable ajax autosave, we create the record immediately and
    # all writing happens during #edit. TODO: Routinely clean up orphaned posts
    @post = current_user.posts.create!(
      parent: (params[:parent_id] ? Post.find(params[:parent_id]) : nil),
      reply_at_char_position: params[:reply_at_char_position].presence)
    respond_to do |format|
      format.html { redirect_to edit_post_path(@post) }
      format.js do
        render json: { form_html: render_to_string(partial: "form_#{template_variant}", locals: { post: @post }) }
      end
    end
  end

  def edit
    @post.draft_content = @post.published_content if @post.draft_content.blank?
    respond_to do |format|
      format.html { render "edit_#{template_variant}" }
      format.js { render partial: "form_#{template_variant}", locals: { post: @post } }
    end
  end

  def update
    prepare_publishable_post_for_validation if publishing?
    if @post.update(post_params)
      complete_publishing_post if publishing?
      respond_to do |format|
        format.html { redirect_to post_path(@post.root), notice: update_success_message }
        format.js { render json: { success: true } }
      end
    else
      reset_dirtied_post_attributes
      respond_to do |format|
        format.html {
          flash.now.alert = "Unable to save your changes. See error messages below."
          render "edit_#{template_variant}" }
        format.js { render json: { errors: @post.errors.full_messages } }
      end
    end
  end

  def show
    unless @post.published? or @post.author == current_user
      raise ActiveRecord::RecordNotFound
    end
    @conversants = @post.conversants.to_a + [@post.author]
    @post_conversant = PostConversant.new
  end

  def destroy
    redirect_to_path = @post.root? ? posts_path : post_path(@post.root)
    @post.destroy!
    redirect_to redirect_to_path, notice: "Successfully removed the draft \"#{@post.title}\"."
  end

  private

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to posts_path, alert: "That post doesn't exist."
  end

  # === Loaders ===

  def load_post
    @post = Post.find(params[:id])
  end

  def verify_authorship
    unless @post.author == current_user
      redirect_to post_path(@post), alert: "You don't have permission to edit this post."
    end
  end

  # === Queries & calculators ===

  def post_params
    params.require(:post).permit(:title, :draft_content, :intention_type, :intention_statement, :tag_list)
  end

  def publishing?
    params[:commit].to_s.downcase.include?("publish")
  end

  def template_variant
    if @post.root?
      "root"
    elsif @post.reply_at_char_position.present?
      "inline_comment"
    else
      "bottom_comment"
    end
  end

  def update_success_message
    if publishing?
      "This post has been published!"
    else
      "Your changes have been saved as a draft."
    end
  end

  # === Mutators ===

  def filter_posts
    if @filters[:author_id]
      @posts = @posts.where(author_id: @filters[:author_id])
    end
    if @filters[:intention_type]
      @posts = @posts.where(intention_type: @filters[:intention_type])
    end
    if @filters[:tag]
      @posts = @posts.tagged_with(@filters[:tag])
    end
  end

  # Need to set some publish-related values prior to running validations
  def prepare_publishable_post_for_validation
    @post.published = true
    @post.published_content = post_params[:draft_content]
  end

  def complete_publishing_post
    @post.draft_content = nil
    @post.published_at ||= Time.now.utc
    @post.save!
  end

  # On #update some publishing-related attributes must be set prior to updating
  # so validations run properly. If validation fails, we then need to undo those
  # publishing-related changes before rendering the page.
  def reset_dirtied_post_attributes
    @post.reload
    @post.assign_attributes(post_params)
  end

end
