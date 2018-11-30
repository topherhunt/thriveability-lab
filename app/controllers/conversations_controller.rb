class ConversationsController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update]
  before_action :load_conversation, only: [:edit, :update, :show]
  before_action :verify_ownership, only: [:edit, :update]

  def index
    @most_active_conversations = Conversation.most_popular(8)
    @recent_comments = Comment.order("updated_at DESC").limit(8).includes(:author)
    @tag_counts = Conversation.order("updated_at DESC").limit(100)
      .tag_counts_on(:tags)
      .sort_by(&:name)
  end

  def new
    @conversation = Conversation.new
    @comment = Comment.new
    @participant = ConversationParticipantJoin.new
  end

  def create
    ActiveRecord::Base.transaction do
      @conversation = Conversation.create!(conversation_params.merge(
        creator: current_user))
      @comment = Comment.create!(comment_params.merge(
        context: @conversation,
        author: current_user))
      @participant = ConversationParticipantJoin.create!(
        conversation: @conversation,
        participant: current_user,
        intention: params[:intention])
    end
    Event.register(current_user, "create", @conversation)
    redirect_to conversation_path(@conversation),
      info: "Great, you've started the conversation!"
  rescue ActiveRecord::RecordInvalid => e
    @conversation ||= Conversation.new
    @comment ||= Comment.new
    @participant ||= ConversationParticipantJoin.new
    @errors = (
      @conversation.errors.full_messages +
      @comment.errors.full_messages +
      @participant.errors.full_messages)

    flash.now.alert = "Unable to save your changes. Please see errors below."
    render "new"
  end

  def edit
  end

  def update
    if @conversation.update(conversation_params)
      redirect_to conversation_path(@conversation), info: "Your changes have been saved."
    else
      flash.now.alert = "Unable to save your changes. Please see errors below."
      render "edit"
    end
  end

  def show
    @intentions = load_intentions_by_participant(@conversation)
    @comments = @conversation.comments.order("created_at ASC").includes(:author)
    @must_state_intention = current_user && !@conversation.participant?(current_user)
  end

  private

  def load_conversation
    @conversation = Conversation.find(params[:id])
  end

  def load_intentions_by_participant(conversation)
    conversation.participant_joins.inject({}) do |hash, pj|
      hash[pj.participant_id] = pj.intention
      hash
    end
  end

  def verify_ownership
    unless @conversation.creator == current_user
      raise "User #{current_user.id} isn't authorized to edit conversation #{@conversation.id}"
    end
  end

  def conversation_params
    params.require(:conversation).permit(:title, :tag_list)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
