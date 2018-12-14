require "test_helper"

class ConversationsControllerTest < ActionController::TestCase
  tests ConversationsController

  setup do
    @user = create :user
    sign_in @user
  end

  describe "before filters" do
    setup do
      @c = create :conversation, creator: @user
    end

    test "#require_logged_in redirects if unauthenticated" do
      sign_out @user
      get :edit, id: @c.id
      assert_redirected_to new_user_session_path
    end

    test "#load_conversation raises RecordNotFound if conversation isn't found" do
      assert_raises(ActiveRecord::RecordNotFound) { get :edit, id: 9999 }
    end

    test "#verify_ownership raises RuntimeError if I'm not the creator" do
      @c.update!(creator: create(:user))
      assert_raises(RuntimeError) { get :edit, id: @c.id }
    end
  end

  describe "#index" do
    it "renders the dashboard even when signed out" do
      sign_out @user
      3.times { c = create :conversation; create :comment, context: c }
      get :index
      assert_response 200
    end
  end

  describe "#new" do
    it "renders the new conversation page" do
      get :new
      assert_response 200
    end
  end

  describe "#create" do
    setup do
      @create_params = {
        conversation: {title: "Blah"},
        comment: {body: "blah"},
        intention: "blah"
      }
    end

    it "rejects changes if invalid params" do
      pre_count = Conversation.count
      post :create, @create_params.merge(intention: "")
      assert_content "Unable to save your changes."
      assert_equals pre_count, Conversation.count
    end

    it "creates the convo, comment, and participant if valid params" do
      post :create, @create_params

      c = Conversation.last
      assert_redirected_to conversation_path(c)
      assert_equals 1, Conversation.count
      assert_equals @user, c.creator
      assert_equals 1, c.comments.count
      assert_equals [@user], c.participants
    end

    it "notifies followers of this event" do
      @user2 = create :user
      StayInformedFlag.where(user: @user2, target: @user).create!

      post :create, @create_params

      assert_notified @user2, [@user, :create, @user.conversations.last]
    end
  end

  describe "#edit" do
    it "renders the edit form" do
      c = create :conversation, creator: @user
      get :edit, id: c.id
      assert_response 200
    end
  end

  describe "#update" do
    it "rejects changes if invalid params" do
      c = create :conversation, creator: @user
      patch :update, id: c.id, conversation: {title: ""}
      assert_content "Unable to save your changes."
    end

    it "updates the convo if valid params" do
      c = create :conversation, creator: @user
      patch :update, id: c.id, conversation: {title: "blah", tag_list: "a,b"}
      assert_redirected_to conversation_path(c)
      assert_equals "blah", c.reload.title
      assert_equals ["a", "b"], c.tag_list.sort
    end
  end

  describe "#show" do
    it "renders the conversation even when signed out" do
      sign_out @user
      c = create :conversation
      create :comment, context: c
      get :show, id: c
    end
  end
end
