class PostConversantsController < ApplicationController
  before_action :require_login
  before_action :require_user_name
  before_action :load_post

  def new
    @post_conversant = PostConversant.new
  end

  def create
    @post_conversant = PostConversant.new(post_conversant_params)
    if @post_conversant.save
      redirect_to post_path(@post), notice: "We're glad you've joined the discussion! Reply to this post in-line or at the bottom of the page."
    else
      flash.now.alert = "Unable to add you to the conversation. Please see error messages below."
      render "new"
    end
  end

  private

  def load_post
    @post = Post.find(params[:post_id])
  end

  def post_conversant_params
    params.require(:post_conversant).permit(:post_id, :intention_type, :intention_statement).merge(post: @post, user: current_user)
  end
end
