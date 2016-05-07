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
    if @post.update(post_params)
      if params[:commit] == "Publish!"
        @post.publish!
        redirect_to post_path(@post), notice: "Post published!"
      else
        redirect_to post_path(@post), notice: "Post updated."
      end
    else
      flash.now.alert = "Unable to save your changes. See error messages below."
      render "edit"
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

  def verify_authorship
    unless @post.author == current_user
      redirect_to post_path(@post), alert: "You don't have permission to edit this post."
    end
  end

end
