require "test_helper"

class CommentsControllerTest < ActionController::TestCase
  tests CommentsController

  setup do
    @user = create :user
    sign_in @user
    @conversation = create :conversation, creator: create(:user) # (someone else)

    @create_params = {
      context_type: "Conversation",
      context_id: @conversation.id,
      intention: "blah",
      comment: {body: "comment body"}
    }
  end

  describe "before filters" do
    test "#require_logged_in redirects if unauthenticated" do
      sign_out @user
      post :create, @create_params
      assert_redirected_to new_user_session_path
    end

    test "#load_context raises RecordNotFound if context isn't found" do
      assert_raises(ActiveRecord::RecordNotFound) do
        post :create, @create_params.merge(context_id: 9999)
      end
    end

    test "#load_comment raises RecordNotFound if I don't own this comment" do
      @comment = create :comment, author: create(:user), context: @conversation
      assert_raises(ActiveRecord::RecordNotFound) do
        get :edit, id: @comment.id
      end
    end
  end

  describe "#create" do
    it "rejects and re-renders form if invalid params" do
      pre_count = Comment.count
      post :create, @create_params.merge(intention: "")
      assert_content "Unable to save your changes"
      assert_equals pre_count, Comment.count
    end

    it "creates the comment and redirects if valid params" do
      post :create, @create_params
      assert_equals 1, @conversation.comments.count
      assert_equals "comment body", @conversation.comments.last.body
      assert_redirected_to conversation_path(@conversation)
    end

    # TODO: I feel like the notification system should be covered in unit tests
    # rather than controller tests.
    it "notifies followers of this event" do
      @user2 = create :user
      StayInformedFlag.where(user: @user2, target: @user).create!

      post :create, @create_params

      assert_notified @user2, [@user, :comment, @conversation]
    end
  end

  describe "#edit" do
    it "renders the edit form" do
      comment = create :comment, context: @conversation, author: @user
      get :edit, id: comment.id
      assert_response 200
    end
  end

  describe "#update" do
    setup do
      @comment = create :comment, context: @conversation, author: @user
    end

    it "rejects and re-renders form if invalid params" do
      pre_body = @comment.body
      patch :update, id: @comment.id, comment: {body: ""}
      assert_content "Unable to save your changes"
      assert_equals pre_body, @comment.reload.body
    end

    it "updates the comment and redirects if valid params" do
      patch :update, id: @comment.id, comment: {body: "new body"}
      assert_redirected_to conversation_path(@conversation)
      assert_equals "new body", @comment.reload.body
    end
  end

  describe "#destroy" do
    it "destroys the comment and redirects" do
      comment = create :comment, context: @conversation, author: @user
      delete :destroy, id: comment.id
    end
  end
end
