class CommentsController < ApplicationController
  before_action :require_login
  before_action :load_context, only: [:create]
  before_action :load_comment, only: [:edit, :update, :destroy]

  def create
    @comment = Comment.new(comment_params.merge(context: @context, author: current_user))
    add_participant_to_conversation if user_is_new_to_conversation?
    if @comment.errors.empty? && @comment.save
      redirect_to @context, notice: "Your comment was posted!"
    else
      flash.now.alert = "Unable to save your changes: "\
        "#{@comment.errors.full_messages.join(", ")}"
      render "new", locals: {
        context: @context,
        comment: @comment,
        must_state_intention: user_is_new_to_conversation?}
    end
  end

  def edit
    render "edit", locals: {context: @comment.context, comment: @comment}
  end

  def update
    if @comment.update(comment_params)
      redirect_to @comment.context, notice: "Your comment was saved."
    else
      flash.now.alert = "Unable to save your changes: "\
        "#{@comment.errors.full_messages.join(", ")}"
      render "edit", locals: {context: @comment.context, comment: @comment}
    end
  end

  def destroy
    @comment.destroy!
    redirect_to @comment.context, notice: "Your comment was deleted."
  end

  private

  def load_context
    type = params.fetch(:context_type)
    id = params.fetch(:context_id)
    unless type.in?(%w(Conversation Project Resource))
      raise "Unknown context_type #{type}!"
    end
    @context = type.constantize.find(id)
  end

  def load_comment
    @comment = current_user.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def user_is_new_to_conversation?
    @context.is_a?(Conversation) && !@context.participant?(current_user)
  end

  def add_participant_to_conversation
    if intention = params[:intention].presence
      ConversationParticipantJoin.create!(
        conversation: @context,
        participant: current_user,
        intention: intention)
    else
      @comment.errors.add(:base, "Intention statement can't be blank")
    end
  end
end
