class PostsController < ApplicationController
  before_action :require_login, only: [:new, :edit, :update]
  before_action :load_post, only: [:edit, :update, :show]
  before_action :verify_authorship, only: [:edit, :update]

  def index
    @filters = params.slice(:author_id, :tag, :intention_type)
    @posts = Post.where(published: true).order("published_at DESC")
    if @filters[:author_id]
      @posts = @posts.where(author_id: @filters[:author_id])
    end
    if @filters[:intention_type]
      @posts = @posts.where(intention_type: @filters[:intention_type])
    end
    if @filters[:tag]
      @posts = @posts.tagged_with(@filters[:tag])
    end

    @authors = User.where(id: @posts.pluck(:author_id).uniq).order(:last_name)
    @intention_types = @posts.pluck(:intention_type).uniq.sort
    @tag_counts = @posts.tag_counts_on(:tags)
    @drafts_count = Post.where(author: current_user, published: false).count
  end

  def drafts
    @posts = Post.where(author: current_user, published: false)
  end

  def new
    # In order to enable ajax autosave, we create the record immediately and
    # all writing happens during #edit. TODO: Routinely clean up orphaned posts
    @post = current_user.posts.new
    @post.save(validate: false) # the Post is not yet valid
    redirect_to edit_post_path(@post)
  end

  def edit
  end

  def update
    if params[:commit] == "Publish!"
      @post.published = true
      @post.published_at = Time.now
    end

    if @post.update(post_params)
      respond_to do |format|
        format.html { redirect_to post_path(@post), notice: update_success_message }
        format.js { render json: { success: true } }
      end
    else
      respond_to do |format|
        format.html {
          flash.now.alert = "Unable to save your changes. See error messages below."
          render "edit"
        }
        format.js { render json: { errors: @post.errors.full_messages } }
      end

    end
  end

  def show
    unless @post.published? or @post.author == current_user
      raise ActiveRecord::RecordNotFound
    end
  end

  private

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to posts_path, alert: "That post doesn't exist."
  end

  def post_params
    params.require(:post).permit(:title, :content, :intention_type, :intention_statement, :tag_list)
  end

  def load_post
    @post = Post.find(params[:id])
  end

  def update_success_message
    if @post.published? and @post.published_at > 1.minute.ago
      "Post published!"
    else
      "Post updated."
    end
  end

  def verify_authorship
    unless @post.author == current_user
      redirect_to post_path(@post), alert: "You don't have permission to edit this post."
    end
  end

end
